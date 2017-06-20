//
//  WYSoundWaveBufferQueue.h
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WYSoundWaveBufferQueueDelegate <NSObject>

@required;
/** buffer出队回调 */
- (void)soundWaveBufferQueueOutCallback:(SInt16 *)reSamples reSampleCount:(int)reSampleCount;

@end

@interface WYSoundWaveBufferQueue : NSObject

#pragma mark - 初始化

/**
 * 初始化缓冲队列
 * observer          : 回调buffer
 * inputBufferSize   : 入列buffer大小:sample数
 * outputBufferSize  : 回调buffer大小:sample数
 * callbackFrequency : 回调频率 单位s
 * enqueueFrequency  : 入列频率 单位s
 */
- (instancetype)initQueueWithObserver:(id<WYSoundWaveBufferQueueDelegate>)observer
                      inputBufferSize:(int)inputSampleCount
                     outputBufferSize:(int)outputSampleCount
                    callBackFrequency:(double)callbackFrequency
               enqueueBufferFrequency:(double)enqueueFrequency;


#pragma mark - 动作

/**
 * buffer入队，更新buffer区
 */
- (void)enqueueBuffer:(SInt16 *)samples sampleCount:(int)sampleCount;


@end
