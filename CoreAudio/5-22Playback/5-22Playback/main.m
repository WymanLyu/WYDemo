//
//  main.m
//  5-22Playback
//
//  Created by wyman on 2017/5/22.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CoreAudioUtil.h"

#define kPlaybackFileLocation CFSTR("/Users/wyman/Documents/xcodeDemo/CoreAudio/5-22Playback/5-22Playback/辛晓琪歌曲.m4a")
#define kNumberPlaybackBuffers 3

// 播放器
typedef struct MyPlayer {
    AudioFileID playbackFile; // 播放文件
    SInt64 packetPosition;    // packet位置
    UInt32 numPacketsToRead;  // packet读取数
    AudioStreamPacketDescription *packetDescs; // 包描述数组
    Boolean isDone;           // 播放是否完成
    UInt32 byteCountPerPacket; // 每个packet近似大小

} MyPlayer;


// 回调
static void MyAQOutputCallback ( void * __nullable       inUserData,
                                 AudioQueueRef           inAQ,
                                 AudioQueueBufferRef     inBuffer)
{
    OSStatus theErr = noErr;
    MyPlayer *player = (MyPlayer *)inUserData;
    if (player->isDone) return; // 关闭了
    UInt32 numBytes;// = player->numPacketsToRead * 0x10000; 【注释233】
    UInt32 nPackets = player->numPacketsToRead; // 当前需要读取的packet数
    // 读取文件媒体数据包 打开【注释233】时则可以使用AudioFileReadPacketData进行读取流
    // 【1】此处第三个参数ioNumBytes的意义：
    //     + 在读取数据时，告诉IO读的操作，期待读取的数据长度
    //     + 在读取完毕后，IO通过此数据，告诉实际读取的长度
    //     + 在 AudioFileReadPacketData 方法中只有“IO通过此数据，告诉实际读取的长度”的作用，不同于 AudioFileReadPacketData 只需要设置 大约帧大小*帧数 去告诉IO读取的长度，此方法需要设置 最大帧大小*帧数 来初始化buffer的内存，必须要告诉对应的读取的长度[而AudioFileReadPacketData则可不要告诉，它会主动fix最大的包内存，所以AudioFileReadPacketData 主要用于非压缩格式，和未知长度时]，从而少计算内存细节直接读取，因为此方法更高效地读取压缩格式，但是高效的同时也必然是通过浪费部分内存导致的...
    // 【2】此处倒数第二个参数ioNumPackets的意义：
    //     + 在读取数据时，告诉IO读的操作，期待读取的数据packet的个数
    //     + 在读取完毕后，IO通过此数据，告诉实际读取packet的长度
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    theErr = AudioFileReadPackets(player->playbackFile, FALSE, &numBytes, player->packetDescs, player->packetPosition, &nPackets, inBuffer->mAudioData); // 文件 - 是否内存缓存 - 如上【1】注释 - packet的媒体描述格式 - packet当前的开始位置（文件的第几个packet） - 如上注释【2】 - 读取的音频流内容
#pragma clang diagnostic pop
    CheckError(theErr, "AudioFileReadPackets");
    if (nPackets > 0) { // 实际读取的packet数
        inBuffer->mAudioDataByteSize = numBytes; // 记录buffer的实际大小
        theErr = AudioQueueEnqueueBuffer(inAQ, inBuffer, (player->packetDescs ? nPackets : 0), player->packetDescs); // 通过player->packetDescs判断是否VBR还是CBR 再设置packet的实际数
        CheckError(theErr, "AudioQueueEnqueueBuffer");
        player->packetPosition += nPackets; // 增加读取packet的索引
    } else { // 什么都没有读取到，可能是读完了
        theErr = AudioQueueStop(inAQ, TRUE);
        CheckError(theErr, "AudioQueueStop");
        player->isDone = TRUE;
        
    }

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        OSStatus theErr = noErr;
        
        // 0.初始化播放器
        MyPlayer player = {0};
        
        // 1.打开音频文件
        CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, kPlaybackFileLocation, kCFURLPOSIXPathStyle, FALSE);
        theErr = AudioFileOpenURL(fileURL, kAudioFileReadPermission, kAudioFileM4AType, &player.playbackFile);
        CheckError(theErr, "AudioFileOpenURL");
        
        // 2.设置格式
        AudioStreamBasicDescription asdb;
        UInt32 dataSize = sizeof(AudioStreamBasicDescription);
        theErr = AudioFileGetProperty(player.playbackFile, kAudioFilePropertyDataFormat, &dataSize, &asdb);
        CheckError(theErr, "AudioFileGetProperty");
        
        // 3.设置queue
        AudioQueueRef queue;
        theErr = AudioQueueNewOutput(&asdb, MyAQOutputCallback, &player, NULL, NULL, 0, &queue);
        CheckError(theErr, "AudioQueueNewOutput");
        // 3.0.计算buffer大小 和 packet数
        UInt32 bufferByteSize = MyComputePlaybackBufferSize(player.playbackFile, &asdb, 0.5, &player.numPacketsToRead);
        // 3.1.设置描述结构
        Boolean isFormatVBR = (asdb.mBytesPerPacket == 0 || asdb.mFramesPerPacket == 0);
        if (isFormatVBR) { // 是VBR 则根据packet数创建 媒体描述的内存大小
            player.packetDescs = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription)*player.numPacketsToRead);
        } else {
            player.packetDescs = NULL;
        }
        // 3.2.拷贝文件cookie到queue【用于回调中文件的读取】
        MyCopyEncoderCookieToQueue(player.playbackFile, queue);
        // 3.3.初始化播放器
        player.isDone = FALSE;
        player.packetPosition = 0;
        // 3.4.设置buffer【设置读取文件的buffer】
        AudioQueueBufferRef buffers[kNumberPlaybackBuffers];
        for (int i = 0; i < kNumberPlaybackBuffers; i++) {
            theErr = AudioQueueAllocateBuffer(queue, bufferByteSize, &buffers[i]);
            CheckError(theErr, "AudioQueueAllocateBuffer");
            // 在播放前，先填满queue中的buffer
            MyAQOutputCallback(&player, queue, buffers[i]);
        }
        
        // 4.播放文件
        theErr = AudioQueueStart(queue, NULL);
        CheckError(theErr, "AudioQueueStart");
        
        // 5.开启事件循环等待播放完毕
        do {
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, FALSE); // 因为播放时0.5s播放一段
        } while (!player.isDone);
        // 5.1.可能缓存池中仍有1.5s时长的数据，则等待播放完毕
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2, FALSE);
        
        // 6.回收内存
        player.isDone = TRUE;
        theErr = AudioQueueStop(queue, TRUE);
        CheckError(theErr, "AudioQueueStop");
        AudioQueueDispose(queue, TRUE);
        AudioFileClose(player.playbackFile);
   
    }
    return 0;
}
