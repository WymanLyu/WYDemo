//
//  WYDownloadTask.h
//  Rapid
//
//  Created by wyman on 2017/9/6.
//  Copyright © 2017年 wyman. All rights reserved.
//
//  下载任务

#import <Foundation/Foundation.h>
#import "WYDownloadInfo.h"
#import "WYDownloadOperation.h"
#import "WYDownloadConfig.h"

@interface WYDownloadTask : NSObject <WYDownloadOperation>

/** 下载状态 */
@property (assign, nonatomic, readonly) WYDownloadState state;

/** 下载详情 */
@property (nonatomic, strong) WYDownloadInfo *downInfo;

/** 下载任务标示 */
@property (nonatomic, copy, readonly) NSString *identifier;

/**
 创建一个下载任务,未启动

 @param url             下载地址
 @param destinationPath 目标路径
 @param progress        下载回调
 @param state           下载状态
 @return                返回一个下载任务
 */
+ (WYDownloadTask *)download:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state;

@end
