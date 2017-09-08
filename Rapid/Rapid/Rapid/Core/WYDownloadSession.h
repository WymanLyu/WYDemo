//
//  WYDownloadSession.h
//  Rapid
//
//  Created by wyman on 2017/9/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYDownloadTask.h"


@interface WYDownloadSession : NSObject

+ (instancetype)shareSession;

/** session */
@property (nonatomic, strong, readonly) NSURLSession *session;

/** 最大同时执行的下载任务数 */
@property (nonatomic, assign) NSInteger maxConcurrentCount;

/**
 创建一个下载任务

 @param url             下载地址
 @param destinationPath 目标路径
 @param progress        下载回调
 @param state           下载状态
 @return                返回一个下载任务
 */
- (WYDownloadTask *)download:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state;
- (WYDownloadTask *)download:(NSString *)url progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state;

#pragma mark - 任务操作
/** 取消task */
- (void)cancelTask:(WYDownloadTask *)task;
/** 挂起task */
- (void)suspendTask:(WYDownloadTask *)task;
/** 继续下载task */
- (void)resumeTask:(WYDownloadTask *)task;
/** 即将下载task */
- (void)willResumeTask:(WYDownloadTask *)task;
/** 取消全部 */
- (void)cancelAll;
/** 挂起全部 */
- (void)suspendAll;
/** 继续全部 */
- (void)resumeAll;
/** 即将下载全部 */
- (void)willResumeAll;

/** 增 */
- (void)appendDownloadTask:(WYDownloadTask *)task;
/** 删 */
- (void)deleteDownloadTask:(WYDownloadTask *)task;
/** 查 */
- (WYDownloadTask *)selectDownLoadTask:(NSString *)url;

@end
