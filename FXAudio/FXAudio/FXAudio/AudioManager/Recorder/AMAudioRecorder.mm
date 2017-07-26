//
//  AMAudioRecorder.m
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "AMAudioRecorder.h"
#import "SuperpoweredRecorder.h"
#import "SuperpoweredSimple.h"

@implementation AMAudioRecorder
{
    SuperpoweredRecorder *_recorder;
}

- (void)dealloc {
    delete _recorder;
}

#pragma mark - 初始化
- (instancetype)initWithFileURL:(NSURL *)url {
    if (self = [super init]) {
        _fileURL = url;
        if (!_fileURL.absoluteString.length) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *recorderPath= [NSString stringWithFormat:@"%@/%@.wav", path, [[NSDate date] description]];
            _fileURL = [NSURL fileURLWithPath:recorderPath];
        }
        const char *p = _fileURL.fileSystemRepresentation;
        _recorder = new SuperpoweredRecorder(p, FS, 1);
        _paused = YES;
    }
    return self;
}

#pragma mark - 控制

- (void)recordWithBuffers:(float *)buffers numberOfSamples:(int)numberOfSamples {
    if (NULL != buffers && !self.paused) {
        self->_recorder->process(buffers, NULL, numberOfSamples);
    }
}

- (void)resume {
    if (_paused) {
        _paused = NO;
    }
}

- (void)pause {
    if (!_paused) {
        _paused = YES;
    }
}

- (void)start {
    [self stop];
    _paused = NO;
    // [_fileURL.absoluteString cStringUsingEncoding:NSUTF8StringEncoding] 带文件协议头
    bool r = false;
    r = self->_recorder->start(_fileURL.fileSystemRepresentation);
#ifdef FXAM_IOS_LOG
    NSLog(@"====%zd", r);
#endif
}

- (void)stop {
    _paused = YES;
    self->_recorder->stop();
}


@end
