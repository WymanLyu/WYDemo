//
//  main.m
//  5-19Recorder
//
//  Created by wyman on 2017/5/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CoreAudioUtil.h"

#define kNumberRecordBuffers 3 // buffer数

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
    print_ids("录音回调");
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
        print_ids("main函数");
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
