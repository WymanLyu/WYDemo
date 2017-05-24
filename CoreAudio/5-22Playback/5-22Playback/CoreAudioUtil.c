//
//  CoreAudioUtil.c
//  5-19Recorder
//
//  Created by wyman on 2017/5/24.
//  Copyright © 2017年 wyman. All rights reserved.
//

#include "CoreAudioUtil.h"

// 错误校验
extern void CheckError(OSStatus error, const char *operation)
{
    if (error == noErr) {
        return;
    }
    char errorString[20];
    // 检查四个字节的错误码
    *(UInt32 *)(errorString+1) = CFSwapInt32HostToBig(error);
    if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) { // 说明是四字节的错误码
        errorString[0] = errorString[5] = '\''; // 补上个引号，为了好看点
        errorString[6] = '\0'; // 字符串结尾
    } else { // 其他错误码，格式化写入字符串
        sprintf(errorString, "%d", (int)error);
    }
    // 打印错误并退出程序
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    exit(1);
}

// 打印格式
extern void LogASBD(AudioStreamBasicDescription *asbd, const char *operaton)
{
#ifdef LOG_ASDB
    // 转换4字符格式
    char str[20];
    *(UInt32 *)(str+1) = CFSwapInt32HostToBig(asbd->mFormatID);
    if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
        str[0] = str[5] = '\''; // 补上个引号，为了好看点
        str[6] = '\0'; // 字符串结尾
    } else { // 其他错误码，格式化写入字符串
        sprintf(str, "%d", (int)asbd->mFormatID);
    }
    printf("\n");
    printf("======AudioStreamBasicDescription======\n");
    printf("=======================================\n");
    printf(">>> operation        : %s\n", operaton);
    printf(">>> mSampleRate      : %f\n", asbd->mSampleRate);
    printf(">>> mFormatID        : %s\n", str);
    printf(">>> mFormatFlags     : %d\n", asbd->mFormatFlags);
    printf(">>> mBytesPerPacket  : %d\n", asbd->mBytesPerPacket);
    printf(">>> mFramesPerPacket : %d\n", asbd->mFramesPerPacket);
    printf(">>> mBytesPerFrame   : %d\n", asbd->mBytesPerFrame);
    printf(">>> mChannelsPerFrame: %d\n", asbd->mChannelsPerFrame);
    printf(">>> mBitsPerChannel  : %d\n", asbd->mBitsPerChannel);
    printf(">>> mReserved        : %d\n", asbd->mReserved);
    printf("=======================================\n");
    printf("======AudioStreamBasicDescription======\n");
    printf("\n");
#endif
}

// 获取设备采样率
extern OSStatus MyGetDefaultInputDeviceSampleRate(Float64 *sampleRate)
{
    OSStatus error = noErr;
    // 1.从驱动层的HAL获取录音设备
    AudioDeviceID audioDeviceID = 0;
    // 1.1.通过AudioObjectPropertyAddress对象
    AudioObjectPropertyAddress propertyAddress;
    propertyAddress.mSelector = kAudioHardwarePropertyDefaultInputDevice; // 选择：录音设备
    propertyAddress.mScope = kAudioObjectPropertyScopeGlobal; // 范围：全局返回
    propertyAddress.mElement = 0; // 元素：主元素
    UInt32 propertySize = sizeof(audioDeviceID);
    // 1.2.获取audioDeviceID
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    error = AudioHardwareServiceGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &propertySize, &audioDeviceID); // 对象地址【HAL对象】 - 硬件默认配置 - 属性缓存区大小【不是所有属性都有，无则置0】 - 属性缓存指针【不是所有属性都有，无则置NULL】- AudioDeviceID
#pragma clang diagnostic pop
    
    if (error) {
        return error;
    }
    
    // 2.根据deviceID的录音设备 就可以去查询设备的SampleRate
    propertyAddress.mSelector = kAudioClockDevicePropertyNominalSampleRate; // 选择：名义上的采样率
    propertyAddress.mScope = kAudioObjectPropertyScopeGlobal; // 范围：全局返回
    propertyAddress.mElement = 0; // 元素：主元素
    propertySize = sizeof(Float64); // 采样率大小Float64
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    error = AudioHardwareServiceGetPropertyData(audioDeviceID, &propertyAddress, 0, NULL, &propertySize, sampleRate);
#pragma clang diagnostic pop
    return error;
}

// 拷贝magic cookie到文件
extern void MyCopyEncoderCookieToFile(AudioQueueRef queue, AudioFileID recordFile)
{
    OSStatus error = noErr;
    // 1.在queue获取magic cookie的size
    UInt32 propertySize;
    error = AudioQueueGetPropertySize(queue, kAudioConverterCompressionMagicCookie, &propertySize); // 此属性用于 文件格式转换 所以是kAudioConverterCompressionMagicCookie
    // 2.在queue获取magic cookie
    if (error != noErr || propertySize <= 0) return;
    Byte *magicCookie = (Byte *)malloc(propertySize);
    error = AudioQueueGetProperty(queue, kAudioQueueProperty_MagicCookie, magicCookie, &propertySize);
    CheckError(error, "AudioQueueGetProperty");
    
    // 3.深拷贝magic cookie 到 file中
    error = AudioFileSetProperty(recordFile, kAudioFilePropertyMagicCookieData, propertySize, magicCookie);
    CheckError(error, "AudioFileSetProperty");
    free(magicCookie);
}

// 计算buffer的大小
extern int MyComputeRecordBufferSize(const AudioStreamBasicDescription *format, AudioQueueRef queue, float second)
{
    int packets, frames, bytes;
    
    // 0.总帧数
    frames = ceil(second * format->mSampleRate);
    
    // 1.获取所有帧的字节大小
    if (format->mBytesPerFrame > 0) { // 1.1.CBR下的字节数下是个每帧大小常量
        bytes = frames * format->mBytesPerFrame;
    } else {
        // 1.2.VBR下只能通过packet来计算帧的大小
        UInt32 maxPacketSize;
        
        // 1.2.1获取每一packet的最大大小
        if (format->mBytesPerPacket > 0) { // 如果是非可变packet则可以直接在格式描述中获取packet大小
            maxPacketSize = format->mBytesPerPacket;
        } else { // 没有mBytesPerPacket 则通过queue获取属性
            UInt32 propertySize = sizeof(maxPacketSize);
            OSStatus error = AudioQueueGetProperty(queue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize, &propertySize);
            CheckError(error, "AudioQueueGetProperty");
        }
        
        // 1.2.2获取packet数
        if (format->mFramesPerPacket > 0) { // 如果有mFramesPerPacket 则固定packet数 则可以直接计算
            packets = frames / format->mFramesPerPacket;
        } else { // 此时1packet = 1frame 【其实还有种可变packet的情况，不考虑】
            packets = frames;
        }
        if (packets == 0) { // 校验
            packets = 1;
        }
        
        // 1.2.3.计算大小
        bytes = packets * maxPacketSize;
    }
    return bytes;
}

// 拷贝queue的migic cookie 到文件
extern void MyCopyEncoderCookieToQueue(AudioFileID recordFile, AudioQueueRef queue)
{
    OSStatus error = noErr;
    // 1.在文件描述中获取cookie大小
    UInt32 propertySize;
    UInt32 isWritable = 1;
    error = AudioFileGetPropertyInfo(recordFile, kAudioFilePropertyMagicCookieData, &propertySize, &isWritable); // 文件直接读取 kAudioFilePropertyMagicCookieData 而不是 kAudioConverterCompressionMagicCookie
    CheckError(error, "AudioFileGetPropertyInfo");
    // 2.拷贝queue的cookie 到文件file中
    if (propertySize > 0) {
        // 2.1.获取magicCookie
        Byte *magicCookie = (Byte *)malloc(propertySize*sizeof(UInt8));
        error = AudioFileGetProperty(recordFile, kAudioFilePropertyMagicCookieData, &propertySize, magicCookie);
        CheckError(error, "AudioFileGetProperty");
        
        // 2.2.深拷贝到file
        error = AudioQueueSetProperty(queue, kAudioQueueProperty_MagicCookie, magicCookie, propertySize);
        CheckError(error, "AudioFileSetProperty");
        free(magicCookie);
    }
}

extern int MyComputePlaybackBufferSize(AudioFileID fileID, AudioStreamBasicDescription *format, float seconds, UInt32 *outNumPackets)
{
    UInt32 outBufferSize;
    OSStatus error = noErr;
    // 1.获取最大的packetSize
    UInt32 maxPacketSize;
    UInt32 propertySize = sizeof(maxPacketSize);
    error = AudioFileGetProperty(fileID, kAudioFilePropertyPacketSizeUpperBound, &propertySize, &maxPacketSize);
    CheckError(error, "AudioFileGetProperty");
    
    // 2.最大最小限制
    const int maxBufferSize = 0x10000; // 64kb
    const int minBufferSize = 0x4000;  // 16kb
    
    // 3.获取packet数, 计算buffer大小【多个则按多个算，一个则按一个算】
    if (format->mFramesPerPacket) { // 每个packet的frame固定 CBR
        // 根据时间内的frame数计算packet数
        Float64 numPacketsForTime = (format->mSampleRate * seconds) / format->mFramesPerPacket;
        // 计算需要的packetSize
        outBufferSize = numPacketsForTime * maxPacketSize;
    } else { // 不然就按照一个packet传（如果packet不足最大buffer就按最大buffer传）
        outBufferSize = maxBufferSize > maxPacketSize ? maxBufferSize : maxPacketSize;
    }
    
    // 4.校验bufferSize，获取合理的buffer大小【大于阈值时且packet多于1包，则按最大值算；小于阈值时则按最小值算】大于阈值还少于1packet则按1packet传
    if (outBufferSize > maxBufferSize && outBufferSize > maxPacketSize) { // 最后的输出的buffersize 大于阈值的同时 且 多于一包 按最大buffer传
        outBufferSize = maxBufferSize;
    } else { // 最后的输出的buffersize 小于阈值的同时 或者 少于等于一包 限制最小值
        if (outBufferSize < minBufferSize) { // 小于阈值时 按最小buffer算
            outBufferSize = minBufferSize;
        }
    }
    *outNumPackets = outBufferSize / maxPacketSize;
    if (*outNumPackets == 0) {
        *outNumPackets = 1;
    }
    return outBufferSize;
    
}



