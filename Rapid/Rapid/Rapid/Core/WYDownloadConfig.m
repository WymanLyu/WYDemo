//
//  WYDownloadConfig.m
//  Rapid
//
//  Created by wyman on 2017/9/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYDownloadConfig.h"
#import "WYDownloadSession.h"
#import "NSString+WYDownload.h"

@interface WYDownloadConfig ()

@property (nonatomic, strong) NSMutableDictionary *downloadFileSizesDictM;

@end

@implementation WYDownloadConfig

static WYDownloadConfig *config;
+ (instancetype)defaultConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [WYDownloadConfig new];
    });
    return config;
}

- (NSURLSession *)URLSession {
    return [WYDownloadSession shareSession].session;
}

- (NSString *)rootDir {
    return @"WYDownload";
}

- (NSString *)totalFileSizesPath {
    return [[NSString stringWithFormat:@"%@/%@", [self rootDir], @"WYDownloadFileSizes.plist".MD5] prependCaches];
}

- (NSMutableDictionary *)totalFileSizes {
    if (nil == _downloadFileSizesDictM) {
        _downloadFileSizesDictM = [NSMutableDictionary dictionaryWithContentsOfFile:self.totalFileSizesPath];
        if (nil == _downloadFileSizesDictM) {
            _downloadFileSizesDictM = [NSMutableDictionary dictionary];
        }
    }
    return _downloadFileSizesDictM;
}

- (void)synchronize {
    [self.downloadFileSizesDictM writeToFile:self.totalFileSizesPath atomically:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
