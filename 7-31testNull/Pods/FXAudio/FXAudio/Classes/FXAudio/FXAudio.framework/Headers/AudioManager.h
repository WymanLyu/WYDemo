//
//  AudioManager.h
//  6-16Recorder-Effect
//
//  Created by wyman on 2017/6/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXAudio/FXItem.h"

@class AudioManager;
@protocol AudioManagerDelegate <NSObject>

@optional

//
// 音频IO线程回调，buffers为交错双声道float格式，返回值代表喇叭是否静音，YES则代表静音，NO代表有非静音
//

/** 前处理器，处理前回调 */
- (BOOL)audioManagerIOBeforePreFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

/** 前处理器，处理后回调 */
- (BOOL)audioManagerIOAfterPreFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

/** 处理器，处理前回调 */
- (BOOL)audioManagerIOBeforeFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

/** 处理器，处理后回调 */
- (BOOL)audioManagerIOAfterFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

@end

@interface AudioManager : NSObject

@property (nonatomic, weak) id<AudioManagerDelegate> delegate;

@property (nonatomic, assign, getter=isOpenIO, readonly) BOOL openIO;

@property (nonatomic, assign) BOOL openPreFX;
@property (nonatomic, assign) BOOL openFX;

#pragma mark - 构造
- (instancetype)initWithDelegate:(id<AudioManagerDelegate>)delegate;

#pragma mark - IO开关
- (void)openAudioIO;

- (void)closeAudioIO;

#pragma mark - preFX控制
- (void)setAgcState:(bool)enable;
- (void)setNsLevel:(bool)enable;

#pragma mark - FX控制
@property (nonatomic, strong) NSMutableArray<FXItem *> *fxArrayM;



@end
