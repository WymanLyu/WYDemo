//
//  WYDownloadTask.m
//  Rapid
//
//  Created by wyman on 2017/9/6.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYDownloadTask.h"
#import "NSString+WYDownload.h"

@interface WYDownloadTask ()

/** 网络任务 */
@property (strong, nonatomic) NSURLSessionDataTask *task;

/** 文件流 */
@property (strong, nonatomic) NSOutputStream *stream;


@end

@implementation WYDownloadTask

#pragma mark - 生命周期

- (instancetype)initWithDownloadURL:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state {
    if (self = [super init]) {
        // 1.设置info
        _downInfo = [[WYDownloadInfo alloc] init];
        _downInfo.url = url;
        // 2.回调
        _downInfo.progressChangeBlock = progress;
        _downInfo.stateChangeBlock = state;
        // 3.文件路径
        if (destinationPath) {
            _downInfo.filepath = destinationPath;
            _downInfo.filename = [destinationPath lastPathComponent];
        }
        // 4.状态
        if (_state == WYDownloadStateCompleted) {
            return self;
        } else if (_state == WYDownloadStateResumed) {
            return self;
        }
        // 5.设置网络任务
        [self setupURLSessionTaskWithDownloadInfo:_downInfo];

    }
    return self;
}

- (void)setupURLSessionTaskWithDownloadInfo:(WYDownloadInfo *)info {
    if (self.task) return;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:info.url]];
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", info.totalBytesWritten];
    [request setValue:range forHTTPHeaderField:@"Range"];
    self.task = [[WYDownloadConfig defaultConfig].URLSession dataTaskWithRequest:request];
    // 设置描述
    self.task.taskDescription = info.url;
    _identifier = info.url;
}

#pragma mark - 初始化方法

+ (WYDownloadTask *)download:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(WYDownloadProgressChangeBlock)progress state:(WYDownloadStateChangeBlock)state {
    WYDownloadTask *task = [[WYDownloadTask alloc] initWithDownloadURL:url toDestinationPath:destinationPath progress:progress state:state];
    [task resume];
    return task;
}

#pragma mark - 懒加载

- (NSOutputStream *)stream {
    if (_stream == nil) {
        _stream = [NSOutputStream outputStreamToFileAtPath:self.downInfo.filepath append:YES];
    }
    return _stream;
}

#pragma mark - WYDownloadOperation
/** 取消 */
- (void)cancel {
    [self.task cancel];
    self.state = WYDownloadStateNone;
}

/** 挂起 */
- (void)suspend {
    [self.task suspend];
    self.state = WYDownloadStateSuspened;
}

/** 继续 */
- (void)resume {
    [self.task resume];
    self.state = WYDownloadStateResumed;
}

/** 即将下载 */
- (void)willResume {
    self.state = WYDownloadStateWillResume;
}

- (void)setState:(WYDownloadState)state {
    if (_state!=state) {
        !self.downInfo.stateChangeBlock ? : self.downInfo.stateChangeBlock(state, self.downInfo.filepath, nil);
    }
    _state = state;
}

#pragma mark - 下载操作

/** 获取响应头 */
- (void)didReceiveResponse:(NSHTTPURLResponse *)response {
    // 获得文件总长度
    if (!self.downInfo.totalBytesExpectedToWrite) {
        self.downInfo.totalBytesExpectedToWrite = [response.allHeaderFields[@"Content-Length"] integerValue] + self.downInfo.totalBytesWritten;
        // 存储文件信息
        [[WYDownloadConfig defaultConfig] totalFileSizes][self.downInfo.url] = @(self.downInfo.totalBytesExpectedToWrite);
        [[WYDownloadConfig defaultConfig] synchronize];
    }
    
    // 打开流
    [self.stream open];
    
    // 清空错误
    self.downInfo.error = nil;
}

/** 获取数据 */
- (void)didReceiveData:(NSData *)data {
    // 写数据
    NSInteger result = [self.stream write:data.bytes maxLength:data.length];
    
    if (result == -1) {
        self.downInfo.error = self.stream.streamError;
        [self.task cancel]; // 取消请求
    }else{
        self.downInfo.bytesWritten = data.length;
        // 通知进度改变
        !self.downInfo.progressChangeBlock ? : self.downInfo.progressChangeBlock(self.downInfo.bytesWritten, self.downInfo.totalBytesWritten, self.downInfo.totalBytesExpectedToWrite);
    }
}

/** 结束 */
- (void)didCompleteWithError:(NSError *)error {
    // 关闭流
    [self.stream close];
    self.downInfo.bytesWritten = 0;
    self.stream = nil;
    self.task = nil;
    
    // 错误(避免nil的error覆盖掉之前设置的self.error)
    self.downInfo.error = error ? error : self.downInfo.error;
    
    // 通知(如果下载完毕 或者 下载出错了)
    if (_state == WYDownloadStateCompleted || error) {
        // 设置状态
        _state = error ? WYDownloadStateNone : WYDownloadStateCompleted;
    }
}


@end
