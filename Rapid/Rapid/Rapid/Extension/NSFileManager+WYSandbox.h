//
//  NSFileManager+WYSandbox.h
//  Rapid
//
//  Created by wyman on 2017/9/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (WYSandbox)

/** 沙盒路径 */
- (NSString *)sandboxPath;

/** 文档路径 */
- (NSString *)documentPath;

/** 临时文件夹路径 */
- (NSString *)tmpPath;

/** lib路径 */
- (NSString *)libraryPath;

/** 缓存路径【在lib下】 */
- (NSString *)cachesPath;

@end
