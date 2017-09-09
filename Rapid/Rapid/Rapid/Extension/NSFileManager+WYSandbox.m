//
//  NSFileManager+WYSandbox.m
//  Rapid
//
//  Created by wyman on 2017/9/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "NSFileManager+WYSandbox.h"

@implementation NSFileManager (WYSandbox)

- (NSString *)sandboxPath {
    return NSHomeDirectory();
}

- (NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)tmpPath {
    return NSTemporaryDirectory();
}

- (NSString *)libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}


- (NSString *)cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSArray *)allFilePathsAtPathKeepStructure:(NSString *)direString {
    // 0.非文件夹路径则崩溃
    if(!direString) { // 路径不存在
        NSAssert(NO, @"cachePath不能为空");
    }else if(direString.pathExtension.length != 0) { // 存在则为文件
        // 正则表达判断
        NSString *lastComponent = direString.lastPathComponent;
        NSString *pattern = @"[.]";
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *results = [regular matchesInString:lastComponent options:NSMatchingReportProgress range:NSMakeRange(0, lastComponent.length)];
        if (results.count == 1) { // 除去命名中带多个点的路径
            NSAssert(NO, @"请传入文件夹路径");
        }
    }
    // 1.递归获取文件
    NSMutableArray *pathArray = [NSMutableArray array];
    NSArray *tempArray = [self contentsOfDirectoryAtPath:direString error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [direString stringByAppendingPathComponent:fileName];
        if ([self fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                // ignore .DS_Store
                if (![[fileName substringToIndex:1] isEqualToString:@"."]) {
                    [pathArray addObject:fullPath];
                }
            } else {
                [pathArray addObject:[self allFilePathsAtPathKeepStructure:fullPath]];
            }
        }
    }
    return [NSArray arrayWithArray:pathArray];
}

- (NSArray *)allFileNamesAtPath:(NSString *)direString {
    // 0.非文件夹路径则崩溃
    if(!direString) { // 路径不存在
        NSAssert(NO, @"cachePath不能为空");
    }else if(direString.pathExtension.length != 0) { // 存在则为文件
        // 正则表达判断
        NSString *lastComponent = direString.lastPathComponent;
        NSString *pattern = @"[.]";
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *results = [regular matchesInString:lastComponent options:NSMatchingReportProgress range:NSMakeRange(0, lastComponent.length)];
        if (results.count == 1) { // 除去命名中带多个点的路径
            NSAssert(NO, @"请传入文件夹路径");
        }
    }
    // 1.递归获取文件
    NSMutableArray *nameArray = [NSMutableArray array];
    NSArray *pathArray = [self allFilePathsAtPath:direString];
    for (NSString *path in pathArray) {
        NSString *fileName = path.lastPathComponent;
        [nameArray addObject:fileName];
    }
    return [NSArray arrayWithArray:nameArray];
}

- (NSArray *)allFilePathsAtPath:(NSString *)direString {
    // 0.非文件夹路径则崩溃
    if(!direString) { // 路径不存在
        NSAssert(NO, @"cachePath不能为空");
    }else if(direString.pathExtension.length != 0) { // 存在则为文件
        // 正则表达判断
        NSString *lastComponent = direString.lastPathComponent;
        NSString *pattern = @"[.]";
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *results = [regular matchesInString:lastComponent options:NSMatchingReportProgress range:NSMakeRange(0, lastComponent.length)];
        if (results.count == 1) { // 除去命名中带多个点的路径
            NSAssert(NO, @"请传入文件夹路径");
        }
    }
    // 1.递归获取文件
    NSMutableArray *pathArray = [NSMutableArray array];
    NSArray *pathArrayKeepStructure = [self allFilePathsAtPathKeepStructure:direString];
    [self enumerPathArray:pathArrayKeepStructure toArray:pathArray];
    return [NSArray arrayWithArray:pathArray];
}

- (void)enumerPathArray:(NSArray *)pathArray toArray:(NSMutableArray *)array {
    for (NSObject *obj in pathArray) {
        if ([obj isKindOfClass:[NSString class]]) {
            [array addObject:obj];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            [self enumerPathArray:(NSArray *)obj toArray:array];
        }
    }
}

@end
