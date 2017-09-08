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

//@synthesize bytesWritten=_bytesWritten, totalBytesWritten=_totalBytesWritten, totalBytesExpectedToWrite=_totalBytesExpectedToWrite, filename=_filename, filepath=_filepath, url=_url, error=_error;

#pragma mark - Getter

- (NSString *)filepath {
    if (_filepath == nil) {
        _filepath = [[NSString stringWithFormat:@"%@/%@", [WYDownloadConfig defaultConfig].rootDir, self.filename] prependCaches];
    }
    if (_filepath && ![[NSFileManager defaultManager] fileExistsAtPath:_filepath]) {
        NSString *dir = [_filepath stringByDeletingLastPathComponent];
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _filepath;
}

- (NSString *)filename {
    if (_filename == nil) {
        NSString *pathExtension = self.url.pathExtension;
        if (pathExtension.length) {
            _filename = [NSString stringWithFormat:@"%@.%@", self.url.MD5, pathExtension];
        } else {
            _filename = self.url.MD5;
        }
    }
    return _filename;
}

- (NSInteger)totalBytesWritten {
    return self.filepath.fileSize;
}

- (NSInteger)totalBytesExpectedToWrite {
    if (0==_totalBytesExpectedToWrite) {
        _totalBytesWritten = [[WYDownloadConfig defaultConfig].totalFileSizes[self.url] integerValue];
    }
    return _totalBytesExpectedToWrite;
}


@end
