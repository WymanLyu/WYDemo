//
//  WYDownloadSession.m
//  Rapid
//
//  Created by wyman on 2017/9/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYDownloadSession.h"

@interface WYDownloadSession () <NSURLSessionDataDelegate>

/** session */
@property (nonatomic, strong) NSURLSession *session;

/** 回调的队列 */
@property (strong, nonatomic) NSOperationQueue *queue;

/** 有序任务队列 */
@property (nonatomic, strong) NSMutableArray<WYDownloadTask<WYDownloadOperation> *> *downloadDaskArrM;

@end

@implementation WYDownloadSession

#pragma mark - 生命方法

- (instancetype)init {
    if (self = [super init]) {
        _downloadDaskArrM = [NSMutableArray array];
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

- (WYDownloadTask *)download:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state {
    // 查找任务
    WYDownloadTask *task = [self selectDownLoadTask:url];
    // 创建任务
    if (nil==task) {
        task = [self createDownloadTask:url toDestinationPath:destinationPath progress:progress state:state];
    }
    // 更新任务回调,目标地址没变则更新，反之则重新创建
    if ([task.downInfo.filepath isEqualToString:destinationPath]||
        (nil==destinationPath&&nil==task.downInfo.filepath)     ||
        (nil==destinationPath&&[task.downInfo.filepath isEqualToString:[[WYDownloadConfig defaultConfig] defaultFilePathForURL:url]])) {
        task.downInfo.progressChangeBlock = progress;
        task.downInfo.stateChangeBlock = state;
    } else {
        [self deleteDownloadTask:task];
        task = [self createDownloadTask:url toDestinationPath:destinationPath progress:progress state:state];
    }
    // 开启任务
    [task resume];
    
    
//    if (nil!=task && (destinationPath.length && [task.downInfo.filepath isEqualToString:destinationPath])) { // 更新任务回调
//        task.downInfo.progressChangeBlock = progress;
//        task.downInfo.stateChangeBlock = state;
//    } else if (task.state == WYDownloadStateResumed || task.state == WYDownloadStateSuspened || task.state == WYDownloadStateWillResume) {
//        [task resume];
//    } else {  // 新启一个任务
//        [self deleteDownloadTask:task];
//        task = [self createDownloadTask:url toDestinationPath:destinationPath progress:progress state:state];
//    }
    return task;
}

- (WYDownloadTask *)download:(NSString *)url progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state {
    return [self download:url toDestinationPath:nil progress:progress state:state];
}

#pragma mark - 操作

- (void)appendDownloadTask:(WYDownloadTask *)task {
    if (!task || !task.identifier) return;
    [self.downloadDaskArrM addObject:task];
}

- (void)deleteDownloadTask:(WYDownloadTask *)task {
    if (!task || !task.identifier) return;
    WYDownloadTask *downTask = [self selectDownLoadTask:task.identifier];
    if (downTask==task) {
        [self.downloadDaskArrM removeObject:downTask];
        [[WYDownloadConfig defaultConfig].totalFileSizes removeObjectForKey:downTask.identifier];
        [[WYDownloadConfig defaultConfig] synchronize];
    }
}

- (WYDownloadTask *)selectDownLoadTask:(NSString *)url {
    if (url == nil) return nil;
    WYDownloadTask *downTask = [self.downloadDaskArrM filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier==%@", url]].firstObject;
    if (nil==downTask && [[WYDownloadConfig defaultConfig].totalFileSizes.allKeys containsObject:url]) {
        // 如果session不存在此任务，但磁盘中存在则新启个下载任务
        downTask = [self createDownloadTask:url toDestinationPath:nil progress:nil state:nil];
    }
    return downTask;
}

- (void)cancelTask:(WYDownloadTask *)task {
    WYDownloadTask *downTask = [self selectDownLoadTask:task.description];
    if (downTask==task) {
        [task cancel];
    }
}

- (void)suspendTask:(WYDownloadTask *)task {
    WYDownloadTask *downTask = [self selectDownLoadTask:task.description];
    if (downTask==task) {
        [task suspend];
    }
}

- (void)resumeTask:(WYDownloadTask *)task {
    WYDownloadTask *downTask = [self selectDownLoadTask:task.description];
    if (downTask==task) {
        [task resume];
    }
}

- (void)willResumeTask:(WYDownloadTask *)task {
    WYDownloadTask *downTask = [self selectDownLoadTask:task.description];
    if (downTask==task) {
        [task willResume];
    }
}

- (void)cancelAll {
    [self.downloadDaskArrM makeObjectsPerformSelector:@selector(cancel)];
}

- (void)suspendAll {
    [self.downloadDaskArrM makeObjectsPerformSelector:@selector(suspend)];
}

- (void)resumeAll {
    [self.downloadDaskArrM makeObjectsPerformSelector:@selector(resume)];
}

- (void)willResumeAll {
    [self.downloadDaskArrM makeObjectsPerformSelector:@selector(willResume)];
}

- (void)resumeFirstWillResume {
    WYDownloadTask *willDownTask = [self.downloadDaskArrM filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", WYDownloadStateWillResume]].firstObject;
    [willDownTask resume];
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
