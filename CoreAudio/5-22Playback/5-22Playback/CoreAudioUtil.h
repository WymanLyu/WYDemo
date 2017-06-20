//
//  CoreAudioUtil.h
//  5-19Recorder
//
//  Created by wyman on 2017/5/24.
//  Copyright © 2017年 wyman. All rights reserved.
//

#ifndef CoreAudioUtil_h
#define CoreAudioUtil_h

#include <stdio.h>
#include <AudioToolbox/AudioToolbox.h>

#define LOG_ASDB  // 是否开启打印ASDB

/**
 * 校验SSStatus错误
 */
extern void CheckError(OSStatus error, const char *operation);

/**
 * 打印线程信息
 */
extern void print_ids(const char *str);

/**
 * 打印AudioStreamBasicDescription
 */
extern void LogASBD(AudioStreamBasicDescription *asbd, const char *operaton);

/**
 * 获取当前设备的采样率
 */
extern OSStatus MyGetDefaultInputDeviceSampleRate(Float64 *sampleRate);

#pragma mark - AudioQueue 一些信息工具方法

// ------ 录音

/**
 * 从 AudioQueueRef 中拷贝 magic cookie 到文件
 */
extern void MyCopyEncoderCookieToFile(AudioQueueRef queue, AudioFileID recordFile);

/**
 * 根据 AudioStreamBasicDescription 和 时长 来计算 AudioQueueInput【录音】 的buffer大小
 *
 * 1.根据 AudioStreamBasicDescription 可以知道采样率
 * 2.根据 second * sample 可以知道采样数【帧数】
 * 3.根据 AudioStreamBasicDescription 可以知道是不是CBR 是的话直接计算出播放的dataSize作为buffer大小
 * 4.根据 AudioStreamBasicDescription 知道是VBR 此时需要通过 AudioStreamBasicDescription 获取 packet数【可变packet】
 * 5.根据 AudioQueueRef 获取 VBR下 最大的packetSize：kAudioQueueProperty_MaximumOutputPacketSize
 *
 */
extern int MyComputeRecordBufferSize(const AudioStreamBasicDescription *format, AudioQueueRef queue, float second);

// ------ 播放

/**
 * 从 AudioFileID 中拷贝 magic cookie 到queue
 */
extern void MyCopyEncoderCookieToQueue(AudioFileID recordFile, AudioQueueRef queue);

/**
 * 根据 AudioStreamBasicDescription 和 时长 来计算指定文件 AudioFileID【播放】的buffer大小 同时记录packet数
 * 
 * 1.根据 AudioStreamBasicDescription 知道采样
 * 2.根据 second * sample 可以知道采样数【帧数】
 * 3.根据
 */
extern int MyComputePlaybackBufferSize(AudioFileID fileID, AudioStreamBasicDescription *format, float seconds, UInt32 *outNumPackets);



#endif /* CoreAudioUtil_h */
