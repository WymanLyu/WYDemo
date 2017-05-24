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
 * 打印AudioStreamBasicDescription
 */
extern void LogASBD(AudioStreamBasicDescription *asbd, const char *operaton);

/**
 * 获取当前设备的采样率
 */
extern OSStatus MyGetDefaultInputDeviceSampleRate(Float64 *sampleRate);

#pragma mark - AudioQueue 一些信息工具方法

/**
 * 从 AudioQueueRef 中拷贝 magic cookie 到文件
 */
extern void MyCopyEncoderCookieToFile(AudioQueueRef queue, AudioFileID recordFile);

/**
 * 根据 AudioStreamBasicDescription 和 时长来计算 AudioQueueInput 的buffer大小
 */
extern int MyComputeRecordBufferSize(const AudioStreamBasicDescription *format, AudioQueueRef queue, float second);


#endif /* CoreAudioUtil_h */
