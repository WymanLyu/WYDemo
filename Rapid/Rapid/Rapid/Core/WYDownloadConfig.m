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
#import "NSFileManager+WYSandbox.h"

@interface WYDownloadConfig ()

@property (nonatomic, strong) NSMutableDictionary *downloadFileSizesDictM;

@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation WYDownloadConfig

/** 配置根文件夹 */
static NSString *_rootDirInCaches = nil;
static NSString *_defaultFileDownloadDirtDirInCaches = nil;
+ (void)configRootDir:(NSString *)rootDirInCaches {
    _rootDirInCaches = rootDirInCaches;
}
/** 配置默认下载路径[相对rootDirInCaches] */
+ (void)configDefaultFileDownloadDir:(NSString *)defaultFileDownloadDirtDirInCaches {
    _defaultFileDownloadDirtDirInCaches = defaultFileDownloadDirtDirInCaches;
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

static WYDownloadConfig *config;
+ (instancetype)defaultConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[WYDownloadConfig alloc] init];
    });
    return config;
}

- (NSURLSession *)URLSession {
    return [WYDownloadSession shareSession].session;
}

- (NSString *)rootDir {
    if (_rootDirInCaches) {
        return _rootDirInCaches;
    } else {
        return @"WYDownload";
    }
}

- (NSString *)defaultFileDownloadDir {
    return _defaultFileDownloadDirtDirInCaches;
}

- (NSString *)totalFileSizesPath {
    return [[NSString stringWithFormat:@"%@/%@", [self rootDir], @"WYDownloadFileSizes.plist".MD5] prependCaches];
}

- (NSString *)defaultFilePathForURL:(NSString *)url {
    if ([WYDownloadConfig defaultConfig].defaultFileDownloadDir) {
        return [[NSString stringWithFormat:@"%@/%@/%@", [WYDownloadConfig defaultConfig].rootDir,[WYDownloadConfig defaultConfig].defaultFileDownloadDir, [self defaultFileNameForURL:url]] prependCaches];
    } else {
        return [[NSString stringWithFormat:@"%@/%@", [WYDownloadConfig defaultConfig].rootDir, [self defaultFileNameForURL:url]] prependCaches];
    }
}

- (NSString *)defaultFileNameForURL:(NSString *)url {
    NSString *pathExtension = url.pathExtension;
    NSString *fileName = nil;
    if (pathExtension.length) {
        fileName = [NSString stringWithFormat:@"%@.%@", url.MD5, pathExtension];
    } else {
        fileName = url.MD5;
    }
    return fileName;
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
    [self.lock lock];
    [self.downloadFileSizesDictM writeToFile:self.totalFileSizesPath atomically:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.lock unlock];
    // 每次同步时检查是否有被移除的任务
   dispatch_sync(dispatch_get_global_queue(0, 0), ^{
       [self.lock lock];
       [self removeUselessFile];
       [self.lock unlock];
   });
}

#pragma mark - 私有方法

- (void)removeUselessFile {
    // 1.遍历文件名
    NSString *rootDirPath = [[WYDownloadConfig defaultConfig].rootDir prependCaches];
    NSArray *filePaths = [[NSFileManager defaultManager] allFilePathsAtPath:rootDirPath];
    
    // 2.对比WYDownloadFileSizes.plist
    NSMutableArray *useableFiles = [NSMutableArray array];
    [self.downloadFileSizesDictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 获取详情
        WYDownloadInfo *info = [[WYDownloadInfo alloc] init];
        info.url = key;
        // 对比文件名
        [useableFiles addObject:info.filename];
    }];
    
    // 3.不存在则移除
    for (NSString *filePath in filePaths) {
        if (![useableFiles containsObject:filePath.lastPathComponent]) {
            if ([filePath.lastPathComponent isEqualToString:self.totalFileSizesPath.lastPathComponent]) {
                continue; // 配置文件除外
            }
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}



@end
