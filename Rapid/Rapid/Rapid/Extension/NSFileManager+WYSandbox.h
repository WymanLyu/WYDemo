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


/** 
 * 获取目录所以文件的路径,递归查找
 *
 *  结构：Dir
 *         - subDir1
 *              file1
 *         - subDir2
 *              file2
 *              file3
 *         file
 *
 *  返回值：@[ @[file1], @[file2, file3], file];
 **/
- (NSArray *)allFilePathsAtPathKeepStructure:(NSString *)direString;

/**
 * 获取目录所以文件的路径,递归查找
 *
 *  结构：Dir
 *         - subDir1
 *              file1
 *         - subDir2
 *              file2
 *              file3
 *         file
 *
 *  返回值：@[file1, @file2, file3, file];
 **/
- (NSArray *)allFilePathsAtPath:(NSString *)direString;

/**
 * 获取目录所以文件的路径,递归查找
 *
 *  结构：Dir
 *         - subDir1
 *              file1
 *         - subDir2
 *              file2
 *              file3
 *         file
 *
 *  返回值：@[fileName1, @fileName2, fileName3, fileName];
 **/
- (NSArray *)allFileNamesAtPath:(NSString *)direString;




@end
