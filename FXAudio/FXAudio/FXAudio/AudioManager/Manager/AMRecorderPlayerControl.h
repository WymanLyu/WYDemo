//
//  AMRecorderPlayerControl.h
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioManager.h"

@interface AMRecorderPlayerControl : NSObject<AudioManagerDelegate>

/** 获取conrtol */
+ (instancetype)controlWithRecordFileURL:(NSURL *)recordFileURL playFileURL:(NSURL *)playFileURL;

/** 开启返听 */
@property (nonatomic, assign, getter=isOpenReturnVoice) BOOL openReturnVoice;
/** 返听开关仅当耳机时开启 默认是NO */
@property (nonatomic, assign) BOOL openReturnVoicePropertyActivityWhenHeadSetPlugging;

/** 伴奏混音比重大小 0是无伴奏声音 1是最大声 默认1.0 */
@property (nonatomic, assign) float volume;

@property (nonatomic, strong) NSURL *playFileURL;

#pragma mark - 控制
- (void)startRecorder;
- (void)pauseRecorder;
- (void)stopRecorder;

- (void)startPlayer;
- (void)pausePlayer;
- (void)stopPlayer;


@end
