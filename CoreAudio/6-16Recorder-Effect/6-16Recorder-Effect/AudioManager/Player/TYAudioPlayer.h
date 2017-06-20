//
//  TYAudioPlayer.h
//  6-16Recorder-Effect
//
//  Created by wyman on 2017/6/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYAudioPlayer : NSObject

+ (instancetype)initWithFileURL:(NSURL *)url;

@property (nonatomic, strong) NSURL *fileURL;

#pragma mark - 控制

- (void)play;

- (void)resume;

- (void)stop;

@end
