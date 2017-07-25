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
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, assign, readonly) BOOL paused;

#pragma mark - 初始化
- (instancetype)initWithFileURL:(NSURL *)url;

#pragma mark - 控制

- (BOOL)playWithBuffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

- (void)resume;

- (void)pause;

- (void)start;

- (void)stop;

@end
