//
//  WYDownloadInfo.m
//  Rapid
//
//  Created by wyman on 2017/9/6.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYDownloadInfo.h"
#import "NSString+WYDownload.h"
#import "WYDownloadConfig.h"

@interface WYDownloadInfo()


@end

@implementation WYDownloadInfo

#pragma mark - Getter

- (NSString *)filepath {
    if (_filepath == nil && self.filename) {
        _filepath = [[WYDownloadConfig defaultConfig] defaultFilePathForURL:self.url];
    }
    if (_filepath && ![[NSFileManager defaultManager] fileExistsAtPath:_filepath]) {
        NSString *dir = [_filepath stringByDeletingLastPathComponent];
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _filepath;
}

- (NSString *)filename {
    if (_filename == nil) {
        _filename = [[WYDownloadConfig defaultConfig] defaultFileNameForURL:self.url];
    }
    return _filename;
}

- (NSInteger)totalBytesWritten {
    return self.filepath.fileSize;
}

- (NSInteger)totalBytesExpectedToWrite {
    if (0==_totalBytesExpectedToWrite) {
        _totalBytesExpectedToWrite = [[WYDownloadConfig defaultConfig].totalFileSizes[self.url] integerValue];
    }
    return _totalBytesExpectedToWrite;
}


@end
