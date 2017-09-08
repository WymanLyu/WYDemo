//
//  AMAudioRecorder.h
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConst.h"

@interface AMAudioRecorder : NSObject

#pragma mark - 属性
/** 重设URL，URL合法后会暂停录制，需要重新start */
@property (nonatomic, strong) NSURL *fileURL;
/** 是否暂停 */
@property (nonatomic, assign, readonly) BOOL paused;

#pragma mark - 初始化
- (instancetype)initWithFileURL:(NSURL *)url;

#pragma mark - 控制

/** 写入numberOfSamples采样数的交错双声道buffer到文件中 */
- (void)recordWithBuffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

- (void)resume;

- (void)pause;

- (void)start;

- (void)stop;

@end
