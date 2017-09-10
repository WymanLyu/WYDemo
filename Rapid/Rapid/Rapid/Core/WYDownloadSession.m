//
//  WYDownloadSession.m
//  Rapid
//
//  Created by wyman on 2017/9/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYDownloadSession.h"
#import "NSFileManager+WYSandbox.h"

@interface WYDownloadSession () <NSURLSessionDataDelegate>

/** session */
@property (nonatomic, strong) NSURLSession *session;

/** 回调的队列 */
@property (strong, nonatomic) NSOperationQueue *queue;

/** 有序任务队列 */
@property (nonatomic, strong) NSMutableArray<WYDownloadTask<WYDownloadOperation> *> *downloadTaskArrM;

@end

@implementation WYDownloadSession

#pragma mark - 生命方法

- (instancetype)init {
    if (self = [super init]) {
        _downloadTaskArrM = [NSMutableArray array];
        _maxConcurrentCount = 2;
    }
    return self;
}

static WYDownloadSession *_downloadSession;
+ (instancetype)shareSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadSession = [[WYDownloadSession alloc] init];
    });
    return _downloadSession;
}


#pragma mark - 懒加载
- (NSURLSession *)session {
    if (!_session) {
        // 配置
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        // session
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:self.queue];
    }
    return _session;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

#pragma mark - 核心方法

- (WYDownloadTask *)createDownloadTask:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state {
    WYDownloadTask *task = [WYDownloadTask download:url toDestinationPath:destinationPath progress:progress state:state];
    [self appendDownloadTask:task];
    return task;
}

- (WYDownloadTask *)download:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state autoResume:(BOOL)autoResume {
    // 查找任务
    WYDownloadTask *task = [self selectDownLoadTask:url];
    // 创建任务
    if (nil==task) {
        task = [self createDownloadTask:url toDestinationPath:destinationPath progress:progress state:state];
    }
    // 更新任务回调,目标地址改变了则重新创建
    if ([task.downInfo.filepath isEqualToString:destinationPath]||
        (nil==destinationPath&&nil==task.downInfo.filepath)     ||
        (nil==destinationPath&&[task.downInfo.filepath isEqualToString:[[WYDownloadConfig defaultConfig] defaultFilePathForURL:url]])) {
        // 未更新地址信息,则更新回调，下载中禁止更新【有可能在回调中触发更新导致递归】
        if (task.state!=WYDownloadStateResumed) {
            task.downInfo.progressChangeBlock = progress;
            task.downInfo.stateChangeBlock = state;
        }
    } else {
        [self deleteDownloadTask:task];
        task = [self createDownloadTask:url toDestinationPath:destinationPath progress:progress state:state];
    }
    // 开启任务
    if (autoResume) {
        [self resumeTask:task];
    }
    return task;
}

- (WYDownloadTask *)download:(NSString *)url progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state {
    return [self download:url toDestinationPath:nil progress:progress state:state autoResume:YES];
}

- (WYDownloadTask *)download:(NSString *)url progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state autoResume:(BOOL)autoResume {
    return [self download:url toDestinationPath:nil progress:progress state:state autoResume:autoResume];
}

#pragma mark - 操作

- (void)appendDownloadTask:(WYDownloadTask *)task {
    if (!task || !task.identifier || [self.downloadTaskArrM containsObject:task]) return;
    WYDownloadTask *downTask = [self.downloadTaskArrM filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier==%@", task.identifier]].firstObject;
    if (task.identifier!=downTask.identifier) {
        [self.downloadTaskArrM addObject:task];
    } else { // 更新下载任务
        [self deleteDownloadTask:downTask];
        [self appendDownloadTask:task];
    }
}

- (void)deleteDownloadTask:(WYDownloadTask *)task {
    if (!task || !task.identifier) return;
    WYDownloadTask *downTask = [self selectDownLoadTask:task.identifier];
    if (downTask==task) {
        [self.downloadTaskArrM removeObject:downTask];
        [[WYDownloadConfig defaultConfig].totalFileSizes removeObjectForKey:downTask.identifier];
        [[WYDownloadConfig defaultConfig] synchronize];
    }
}

- (WYDownloadTask *)selectDownLoadTask:(NSString *)url {
    if (url == nil) return nil;
    WYDownloadTask *downTask = [self.downloadTaskArrM filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier==%@", url]].firstObject;
    if (nil==downTask && [[WYDownloadConfig defaultConfig].totalFileSizes.allKeys containsObject:url]) {
        // 如果session不存在此任务，但磁盘中存在则新启个下载任务
        // 获取原有文件路径
        NSString *fileName = [[WYDownloadConfig defaultConfig] defaultFileNameForURL:url];
        NSArray<NSString *> *filePaths = [[NSFileManager defaultManager] allFilePathsAtPath:[WYDownloadConfig defaultConfig].rootDir];
        __block NSString *desPath = nil;
        [filePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.lastPathComponent isEqualToString:fileName]) {
                desPath = obj;
                *stop = YES;
            }
        }];
        downTask = [self createDownloadTask:url toDestinationPath:desPath progress:nil state:nil];
    }
    return downTask;
}

- (void)cancelTask:(WYDownloadTask *)task {
    WYDownloadTask *downTask = [self selectDownLoadTask:task.identifier];
    if (downTask==task) {
        [task cancel];
    }
}

- (void)suspendTask:(WYDownloadTask *)task {
    WYDownloadTask *downTask = [self selectDownLoadTask:task.identifier];
    if (downTask==task) {
        [task suspend];
        // 恢复等待下载的
        [self resumeFirstWillResume];
    }
}

- (void)resumeTask:(WYDownloadTask *)task {
    WYDownloadTask *downTask = [self selectDownLoadTask:task.identifier];
    if (downTask!=task) {
        return;
    }
    if (downTask.state == WYDownloadStateResumed) {
        return;
    }
    // 如果此时已经有最大下载数则此任务进入等待状态
    NSArray *downloadingDownloadInfoArray = [self.downloadTaskArrM filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", WYDownloadStateResumed]];
    if (self.maxConcurrentCount && downloadingDownloadInfoArray.count == self.maxConcurrentCount) {
        // 等待下载
        [downTask willResume];
    } else {
        // 继续
        [downTask resume];
    }
}

- (void)willResumeTask:(WYDownloadTask *)task {
    WYDownloadTask *downTask = [self selectDownLoadTask:task.identifier];
    if (downTask==task) {
        [task willResume];
    }
}

- (void)cancelAll {
    [self.downloadTaskArrM makeObjectsPerformSelector:@selector(cancel)];
}

- (void)suspendAll {
    [self.downloadTaskArrM makeObjectsPerformSelector:@selector(suspend)];
//    // 是因为在 [self suspendTask:obj]; 中处理了willResume逻辑
//    [self.downloadTaskArrM enumerateObjectsUsingBlock:^(WYDownloadTask<WYDownloadOperation> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self suspendTask:obj];
//    }];
}

- (void)resumeAll {
    // 不直接  [self.downloadTaskArrM makeObjectsPerformSelector:@selector(resume)];
    // 是因为在 [self resumeTask:obj] 中处理了willResume逻辑
    [self.downloadTaskArrM enumerateObjectsUsingBlock:^(WYDownloadTask<WYDownloadOperation> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self resumeTask:obj];
    }];
}

- (void)willResumeAll {
    [self.downloadTaskArrM makeObjectsPerformSelector:@selector(willResume)];
}

- (void)resumeFirstWillResume {
    WYDownloadTask *willDownTask = [self.downloadTaskArrM filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", WYDownloadStateWillResume]].firstObject;
    [self resumeTask:willDownTask];
}

#pragma mark - <NSURLSessionDataDelegate>
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 获取下载任务
    WYDownloadTask *downTask = [self selectDownLoadTask:dataTask.taskDescription];
    
    // 处理响应
    if ([downTask respondsToSelector:@selector(didReceiveResponse:)]) {
        [downTask didReceiveResponse:response];
    }
    // 继续
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 获取下载任务
    WYDownloadTask *downTask = [self selectDownLoadTask:dataTask.taskDescription];
    
    // 处理数据
    if ([downTask respondsToSelector:@selector(didReceiveData:)]) {
        [downTask didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 获取下载任务
    WYDownloadTask *downTask = [self selectDownLoadTask:task.taskDescription];
    
    // 处理结束/异常
    if ([downTask respondsToSelector:@selector(didCompleteWithError:)]) {
        [downTask didCompleteWithError:error];
    }
    
    // 恢复等待下载的
    [self resumeFirstWillResume];
}


@end
