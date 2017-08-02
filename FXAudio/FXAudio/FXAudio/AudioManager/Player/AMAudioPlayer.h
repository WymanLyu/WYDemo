//
//  AMAudioPlayer.h
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConst.h"

@interface AMAudioPlayer : NSObject

#pragma mark - 属性
/** 重设URL，URL合法后会暂停播放，需要重新start */
@property (nonatomic, strong) NSURL *fileURL;
/** 是否暂停 */
@property (nonatomic, assign, readonly) BOOL paused;

#pragma mark - 初始化
- (instancetype)initWithFileURL:(NSURL *)url;

#pragma mark - 控制

/** 读取交错双声道 numberOfSamples采样数的buffer，返回值为是否读取有数据：YES==有数据 */
- (BOOL)playWithBuffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

- (void)resume;

- (void)pause;

- (void)start;

- (void)stop;

@end
