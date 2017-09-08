//
//  NSString+WYDownload.h
//  Rapid
//
//  Created by wyman on 2017/9/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WYDownload)

/**
 *  在前面拼接caches文件夹
 */
- (NSString *)prependCaches;

/**
 *  生成MD5摘要
 */
- (NSString *)MD5;

/**
 *  文件大小
 */
- (NSInteger)fileSize;

/**
 *  生成编码后的URL
 */
- (NSString *)encodedURL;


@end
