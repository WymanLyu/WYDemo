//
//  main.c
//  6-26AUPlayerFile
//
//  Created by wyman on 2017/6/26.
//  Copyright © 2017年 wyman. All rights reserved.
//

#include <stdio.h>
#include <AudioToolbox/AudioToolbox.h>
#include <AudioUnit/AudioUnit.h>
#include "CoreAudioUtil.h"

#define kInputFileLocation CFSTR("/Users/wyman/Documents/xcodeDemo/CoreAudio/resources/xxq.m4a")

#pragma mark - 自定义结构

typedef struct MyAUGraphPlayer {
    AudioStreamBasicDescription inputFormat;
    AudioFileID inputFile;
    AUGraph graph;
    AudioUnit fileAU;
} MyAUGraphPlayer;

#pragma mark - 工具方法

void CreateMyAUGraph(MyAUGraphPlayer *player)
{
    OSStatus theErr = noErr;
    // 1.创建音频图谱
    theErr = NewAUGraph(&player->graph);
    CheckError(theErr, "创建音频图谱错误");
    
    // 2.创建节点
    // 2.1.创建输出节点描述
    AudioComponentDescription outputcd = {0};
    outputcd.componentType = kAudioUnitType_Output; // 节点类型
    outputcd.componentSubType = kAudioUnitSubType_DefaultOutput; // 节点子类型
    outputcd.componentManufacturer = kAudioUnitManufacturer_Apple; // 节点厂商信息
    // 2.2.根据节点描述，创建输出节点并加入有向图中
    AUNode outputNode;
    theErr = AUGraphAddNode(player->graph, &outputcd, &outputNode);
    CheckError(theErr, "根据节点描述，创建节点并加入有向图中错误");
    // 2.3.创建输入节点描述
    AudioComponentDescription fileplayercd = {0};
    fileplayercd.componentType = kAudioUnitType_Generator;
    fileplayercd.componentSubType = kAudioUnitSubType_AudioFilePlayer;
    fileplayercd.componentManufacturer = kAudioUnitManufacturer_Apple;
    // 2.4.根据节点描述，创建输入音源节点并加入有向图中
    AUNode fileNode;
    theErr = AUGraphAddNode(player->graph, &fileplayercd, &fileNode);
    CheckError(theErr, "根据节点描述，创建输入音源节点并加入有向图中错误");
    
    // 3.打开音频有向图
    theErr = AUGraphOpen(player->graph);
    CheckError(theErr, "打开音频有向图错误");
    
    // 4.获取节点单元的组件
    theErr = AUGraphNodeInfo(player->graph, fileNode, &fileplayercd, &player->fileAU);
    CheckError(theErr, "获取音源文件播放单元错误");
    
    // 5.连接有向图
    theErr = AUGraphConnectNodeInput(player->graph, fileNode, 0, outputNode, 0); // 有向图-节点-节点编号-节点-节点编号 【节点编号0是输出，1是输入】此处则是将fileNode的输出连接到outputNode的输出
    CheckError(theErr, "连接有向图失败");
    
    // 6.初始化有向图
    theErr = AUGraphInitialize(player->graph);
    CheckError(theErr, "初始化有向图错误");

}

Float64 PrepareFileAU(MyAUGraphPlayer *player)
{
    OSStatus theErr = noErr;
    
    // 1.关联文件到音频单元【设置音频单元的IDs属性】
    theErr = AudioUnitSetProperty(player->fileAU, kAudioUnitProperty_ScheduledFileIDs, kAudioUnitScope_Global, 0, &player->inputFile, sizeof(player->inputFile)); // 音频单元组件-属性名称-作用域-总线编号-属性值-属性大小
    CheckError(theErr, "关联文件到音频单元失败");
    
    // 2.设置音频单元的播放区间【设置音频单元的ScheduledFileRegion属性】
    UInt64 nPackets;
    UInt32 propsize = sizeof(nPackets);
    theErr = AudioFileGetProperty(player->inputFile, kAudioFilePropertyAudioDataPacketCount, &propsize, &nPackets);
    CheckError(theErr, "读取音频文件PacketCount");
    // 2.1.创建文件区域
//    AudioTimeStamp										mTimeStamp;
//    ScheduledAudioFileRegionCompletionProc __nullable	mCompletionProc;
//    void * __nullable									mCompletionProcUserData;
//    struct OpaqueAudioFileID *							mAudioFile;
//    UInt32												mLoopCount;
//    SInt64												mStartFrame;
//    UInt32												mFramesToPlay;
    ScheduledAudioFileRegion rgn;
    memset(&rgn.mTimeStamp, 0, sizeof(rgn.mTimeStamp)); // 清空时间戳
    rgn.mTimeStamp.mSampleTime = 0;
    rgn.mTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
    rgn.mCompletionProc = NULL;
    rgn.mCompletionProcUserData = NULL;
    rgn.mAudioFile = player->inputFile;
    rgn.mLoopCount = 1;
    rgn.mStartFrame = 0;
    rgn.mFramesToPlay = (UInt32)nPackets * player->inputFormat.mFramesPerPacket;
    theErr = AudioUnitSetProperty(player->fileAU, kAudioUnitProperty_ScheduledFileRegion, kAudioUnitScope_Global, 0, &rgn, sizeof(rgn));
    CheckError(theErr, "设置音频单元的播放区间错误");
    // 2.1.创建文件播放开启时间
//    Float64             mSampleTime;
//    UInt64              mHostTime;
//    Float64             mRateScalar;
//    UInt64              mWordClockTime;
//    SMPTETime           mSMPTETime;
//    AudioTimeStampFlags mFlags;
//    UInt32              mReserved;
//    AudioTimeStamp startTime;
//    memset (&startTime, 0, sizeof(startTime));
//    startTime.mSampleTime = -1;
//    startTime.mFlags = kAudioTimeStampSampleTimeValid;
//    theErr = AudioUnitSetProperty(player->fileAU, kAudioUnitProperty_ScheduleStartTimeStamp, kAudioUnitScope_Global, 0, &startTime, sizeof(startTime));
//    CheckError(theErr, "设置音频单元的播放开启时间错误");
    return (nPackets * player->inputFormat.mFramesPerPacket) / player->inputFormat.mSampleRate;
}


#pragma mark - 主函数

int main(int argc, const char * argv[]) {
    
    // 1.加载音频文件
    CFURLRef inputFileRef = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, kInputFileLocation, kCFURLPOSIXPathStyle, false);
    MyAUGraphPlayer player = {0};
    OSStatus theErr = noErr;
    theErr = AudioFileOpenURL(inputFileRef, kAudioFileReadPermission, 0, &player.inputFile);
    CheckError(theErr, "打开文件错误");
    CFRelease(inputFileRef);
    
    // 2.加载文件信息
    UInt32 propSize = sizeof(player.inputFormat);
    theErr = AudioFileGetProperty(player.inputFile, kAudioFilePropertyDataFormat, &propSize, &player.inputFormat);
    CheckError(theErr, "记载文件kAudioFilePropertyDataFormat错误");
    
    // 3.设置音频图谱
    CreateMyAUGraph(&player);
    
    // 4.准备AudioUnit 并记录时长
    Float64 fileDuration = PrepareFileAU(&player);
    
    // 5.开启音频图谱
    theErr = AUGraphStart(player.graph);
    CheckError(theErr, "开启音频图谱失败");
    
    // 6.主线程保证程序等待
    usleep((int)(fileDuration*1000.0*1000.0));
    
    // 7.播放完毕清空资源
    AUGraphStop(player.graph);
    AUGraphUninitialize(player.graph);
    AUGraphClose(player.graph);
    AudioFileClose(player.inputFile);
    
    return 0;
}



















