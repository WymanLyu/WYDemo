//
//  WYDownloadConfig.h
//  Rapid
//
//  Created by wyman on 2017/9/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 下载状态 */
typedef NS_ENUM(NSInteger, WYDownloadState) {
    WYDownloadStateNone = 0,     // 闲置状态（除后面几种状态以外的其他状态）
    WYDownloadStateWillResume,   // 即将下载（等待下载）
    WYDownloadStateResumed,      // 下载中
    WYDownloadStateSuspened,     // 暂停中
    WYDownloadStateCompleted     // 已经完全下载完毕
} NS_ENUM_AVAILABLE_IOS(2_0);

/**
 *  跟踪下载进度的Block回调
 *
 *  @param bytesWritten              【这次回调】写入的数据量
 *  @param totalBytesWritten         【目前总共】写入的数据量
 *  @param totalBytesExpectedToWrite 【最终需要】写入的数据量
 */
typedef void (^WYDownloadProgressChangeBlock)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);

/**
 *  状态改变的Block回调
 *
 *  @param file     文件的下载路径
 *  @param error    失败的描述信息
 */
typedef void (^WYDownloadStateChangeBlock)(WYDownloadState state, NSString *file, NSError *error);

@interface WYDownloadConfig : NSObject

+ (instancetype)defaultConfig;

- (NSURLSession *)URLSession;

- (NSString *)rootDir;

- (NSMutableDictionary *)totalFileSizes;

- (void)synchronize;

- (NSString *)defaultFilePathForURL:(NSString *)url;

- (NSString *)defaultFileNameForURL:(NSString *)url;


@end
