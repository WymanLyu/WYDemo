//
//  WYDownloadInfo.h
//  Rapid
//
//  Created by wyman on 2017/9/6.
//  Copyright © 2017年 wyman. All rights reserved.
//
//  下载任务所需信息

#import <Foundation/Foundation.h>
#import "WYDownloadConfig.h"

@interface WYDownloadInfo : NSObject

/** 这次写入的数量 */
@property (assign, nonatomic) NSInteger bytesWritten;

/** 已下载的数量 */
@property (assign, nonatomic) NSInteger totalBytesWritten;

/** 文件的总大小 */
@property (assign, nonatomic) NSInteger totalBytesExpectedToWrite;

/** 文件名 */
@property (copy, nonatomic) NSString *filename;

/** 文件路径 */
@property (copy, nonatomic) NSString *filepath;

/** 文件url */
@property (copy, nonatomic) NSString *url;

/** 下载的错误信息 */
@property (strong, nonatomic) NSError *error;

///>>>>> 回调

@property (nonatomic, copy) WYDownloadProgressChangeBlock progressChangeBlock;
@property (nonatomic, copy) WYDownloadStateChangeBlock stateChangeBlock;

///>>>>> 回调

@end
