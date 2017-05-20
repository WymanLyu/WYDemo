//
//  main.m
//  5-19Recorder
//
//  Created by wyman on 2017/5/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

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
}

// 回调
static void MyAQInputCallback(
        AudioQueueRef                   inAQ,
        AudioQueueBufferRef             inBuffer,
        const AudioTimeStamp *          inStartTime,
        UInt32                          inNumberPacketDescriptions,
        const AudioStreamPacketDescription * __nullable inPacketDescs)
{
    
};

// 录音机
typedef struct MyRecorder {
    // 文件id
    AudioFileID recordFile;
    // 录音packet
    SInt64 recordPacket;
    // 是否正在录音
    Boolean running;
} MyRecorder;


// 获取设备采样率
static void MyGetDefaultInputDeviceSampleRate(Float64 *sampleRate)
{

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
        MyGetDefaultInputDeviceSampleRate(&recorderFormat.mSampleRate);
        // 1.4.其余给系统Audio进行设置
        UInt32 propertySize = sizeof(recorderFormat);
        
        
        
//        AudioFileGetGlobalInfo(<#AudioFilePropertyID inPropertyID#>, <#UInt32 inSpecifierSize#>, <#void * _Nullable inSpecifier#>, <#UInt32 * _Nonnull ioDataSize#>, <#void * _Nonnull outPropertyData#>)
//        
//        theErr = AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, <#UInt32 inSpecifierSize#>, <#const void * _Nullable inSpecifier#>, <#UInt32 * _Nullable ioPropertyDataSize#>, <#void * _Nullable outPropertyData#>)
        
        
        // 2.创建AudioQueue
        
        // 3.设置文件
        
        // 4.设置其他
        
        // 5.开启queue
        
        // 6.关闭queue
       
    }
    return 0;
}
