//
//  AudioManager.h
//  6-16Recorder-Effect
//
//  Created by wyman on 2017/6/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioManager;
@protocol AudioManagerDelegate <NSObject>

@optional
/** 前处理器，处理前回调 */
- (void)audioManagerIOBeforePreFX:(AudioManager *)manager buffers:(UInt16 *)buffers;

/** 前处理器，处理后回调 */
- (void)audioManagerIOAfterPreFX:(AudioManager *)manager buffers:(UInt16 *)buffers;

/** 处理器，处理前回调 */
- (void)audioManagerIOBeforeFX:(AudioManager *)manager buffers:(UInt16 *)buffers;

/** 处理器，处理后回调 */
- (void)audioManagerIOAfterFX:(AudioManager *)manager buffers:(UInt16 *)buffers;

@end

@interface AudioManager : NSObject

@property (nonatomic, weak) id<AudioManagerDelegate> delegate;

#pragma mark - 构造
- (instancetype)initWithDelegate:(id<AudioManagerDelegate>)delegate;

#pragma mark - IO开关
- (void)openAudioIO;

- (void)closeAudioIO;


@end
