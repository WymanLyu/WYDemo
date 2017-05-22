//
//  main.m
//  5-19Recorder
//
//  Created by wyman on 2017/5/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define LOG_ASDB
#define kNumberRecordBuffers 3 // buffer数

// 错误校验
static void CheckError(OSStatus error, const char *operation)
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
static void LogASBD(AudioStreamBasicDescription *asbd, const char *operaton)
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
    printf(">>> operation        : %s \n", operaton);
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

// 录音机
typedef struct MyRecorder {
    // 文件id
    AudioFileID recordFile;
    // 录音packet序号
    SInt64 recordPacket;
    // 是否正在录音
    Boolean running;
} MyRecorder;

// 回调
static void MyAQInputCallback ( void * __nullable               inUserData,
                                AudioQueueRef                   inAQ,
                                AudioQueueBufferRef             inBuffer,
                                const AudioTimeStamp *          inStartTime,
                                UInt32                          inNumberPacketDescriptions,
                                const AudioStreamPacketDescription * __nullable inPacketDescs)
{
    
    MyRecorder *recorder = (MyRecorder *)inUserData;
    OSStatus theRrr = noErr;
    if (inNumberPacketDescriptions > 0) {
        // 写入packet
        theRrr = AudioFileWritePackets(recorder->recordFile, FALSE, inBuffer->mAudioDataByteSize, inPacketDescs, recorder->recordPacket, &inNumberPacketDescriptions, inBuffer->mAudioData); // 写入文件 - 是否内存缓存 - packet的格式数据结构 - 相对于第一个packet当前的packet序号 - 这一次音频数据包含的packet数 - 音频数据
        CheckError(theRrr, "AudioFileWritePackets");
        
        // 记录packet序号
        recorder->recordPacket += inNumberPacketDescriptions;
    }
    // 这个buffer重新入队 / 只有还在running时
    if (recorder->running) {
        theRrr = AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
        CheckError(theRrr, "AudioQueueEnqueueBuffer");
    }
};

// 获取设备采样率
static OSStatus MyGetDefaultInputDeviceSampleRate(Float64 *sampleRate)
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
static void MyCopyEncoderCookieToFile(AudioQueueRef queue, AudioFileID recordFile)
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
static int MyComputeRecordBufferSize(const AudioStreamBasicDescription *format, AudioQueueRef queue, float second)
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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // 0.创建录音机
        MyRecorder recorder = {0};
        OSStatus theErr = noErr;
        
        // 1.设置格式
        AudioStreamBasicDescription recorderFormat;
        memset(&recorderFormat, 0, sizeof(AudioStreamBasicDescription));
        // 1.1.格式
        recorderFormat.mFormatID = kAudioFormatMPEG4AAC;
        // 1.2.双通道
        recorderFormat.mChannelsPerFrame = 2;
        // 1.3.采样率
        theErr = MyGetDefaultInputDeviceSampleRate(&recorderFormat.mSampleRate);
        CheckError(theErr, "MyGetDefaultInputDeviceSampleRate");
        // 1.4.其余给系统Audio进行设置
        LogASBD(&recorderFormat, "获取系统formatInfo前");
        UInt32 propertySize = sizeof(recorderFormat);
        theErr = AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &propertySize, &recorderFormat);
        CheckError(theErr, "AudioFormatGetProperty");
        LogASBD(&recorderFormat, "获取系统formatInfo后");
        
        // 2.创建AudioQueue
        AudioQueueRef queue = {0};
        theErr =  AudioQueueNewInput(&recorderFormat, MyAQInputCallback, &recorder, NULL, NULL, 0, &queue);
        CheckError(theErr, "AudioQueueNewInput");
//        // 2.1.通过audioQueue补充更完整的格式【这个好像完全木有必要】
//        LogASBD(&recorderFormat, "AudioQueue补充格式前");
//        propertySize = sizeof(recorderFormat);
//        theErr = AudioQueueGetProperty(queue, kAudioConverterCurrentOutputStreamDescription, &recorderFormat, &propertySize);
//        CheckError(theErr, "AudioQueueGetProperty");
//        LogASBD(&recorderFormat, "AudioQueue补充格式后");
        
        // 3.设置文件
        // 3.1.输出文件URL
        CFURLRef myFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,  CFSTR("output.caf"), kCFURLPOSIXPathStyle, false);// 内存申请方式 - 字符串路径 - url规则 - 是否是文件夹
        // 3.2.根据URL创建文件引用
        theErr = AudioFileCreateWithURL(myFileURL, kAudioFileCAFType, &recorderFormat, kAudioFileFlags_EraseFile, &recorder.recordFile); // URL - 文件格式 - 音频格式 - 是否覆盖原有文件 - 输出文件
        CheckError(theErr, "AudioFileCreateWithURL");
        CFRelease(myFileURL);
        // 3.3.由于aac是压缩格式，所以还要告诉文件这个媒体格式的magic cookie【而此信息queue是知道的】，用来给文件写入时的编解码
        MyCopyEncoderCookieToFile(queue, recorder.recordFile);
        
        // 4.设置queue的buffer
        // 4.1.由于acc是压缩格式，所以buffer的大小要根据queue进行计算
        int bufferByteSize = MyComputeRecordBufferSize(&recorderFormat, queue, 0.5);
        // 4.2.根据buffer大小创建queue的3个buffer
        for (int index = 0; index < kNumberRecordBuffers; index++) {
            // 4.2.1.创建buffer
            AudioQueueBufferRef buffer;
            theErr = AudioQueueAllocateBuffer(queue, bufferByteSize, &buffer);
            CheckError(theErr, "AudioQueueAllocateBuffer");
            // 4.2.2.buffer入列
            theErr = AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
            CheckError(theErr, "AudioQueueEnqueueBuffer");
        }
        
        // 5.开启queue
        recorder.running = TRUE;
        theErr = AudioQueueStart(queue, NULL); // 队列 - 开启时间[NULL立刻开启]
        CheckError(theErr, "AudioQueueStart");
        // 5.1.处理暂停逻辑
        printf("Recording, press <return> to stop:\n");
        getchar(); // 阻塞等待按下return
        printf("* Recoring done *\n");
        recorder.running = FALSE;
        theErr = AudioQueueStop(queue, TRUE);
        CheckError(theErr, "AudioQueueStop");
        
        // 6.关闭queue
        // 6.1.关闭前重新设置file的magic cookie【因为和录制时可能不一致】
        MyCopyEncoderCookieToFile(queue, recorder.recordFile);
        // 6.2.关闭queue
        theErr = AudioQueueDispose(queue, TRUE);
        CheckError(theErr, "AudioQueueDispose");
        // 6.3.关闭文件流
        AudioFileClose(recorder.recordFile);
        
    }
    return 0;
}
