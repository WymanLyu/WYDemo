//
//  AMAudioPlayer.m
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "AMAudioPlayer.h"
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredSimple.h"


@implementation AMAudioPlayer
{
    SuperpoweredAdvancedAudioPlayer *_player;
}

- (void)dealloc {
    [self stop];
    delete _player;
#ifdef FXAM_IOS_LOG
    printf("delete play ===\n");
#endif
}

#pragma mark - 初始化
- (instancetype)initWithFileURL:(NSURL *)url {
    if (self = [super init]) {
        _player = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallback, FS, 0);
#ifdef FXAM_IOS_LOG
        printf("new play -----\n");
#endif
        [self setFileURL:url];
    }
    return self;
}

- (void)setFileURL:(NSURL *)fileURL {
    if ([fileURL.absoluteString isEqualToString:_fileURL.absoluteString]) {
        _player->seek(0);
        return;
    }
    _fileURL = fileURL;
    if (!_fileURL.absoluteString.length) {
        [self stop];
    }
    if (_fileURL.absoluteString.length) {
        [self pause];
#ifdef FXAM_IOS_LOG
        printf("%s\n\n", _fileURL.fileSystemRepresentation);
#endif
        _player->open(_fileURL.fileSystemRepresentation);
        [self pause];
    }
}

#pragma mark - 控制

- (BOOL)playWithBuffers:(float *)buffers numberOfSamples:(int)numberOfSamples {
    bool hasData = NO;
    if (NULL != buffers && !self.paused) {
        hasData = self->_player->process(buffers, false, numberOfSamples, 1.0, 0.0, -1.0);
    }
    return hasData;
}

- (void)resume {
    if (_paused) {
        _paused = NO;
    }
    _player->play(false);
}

- (void)pause {
    if (!_paused) {
        _paused = YES;
    }
    _player->pause();
}

- (void)start {
    [self stop];
    _paused = NO;
    _player->play(false);
}

- (void)stop {
    [self pause];
    _player->seek(0);
}

#pragma mark - 播放事件回调
void playerEventCallback (void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
    switch (event) {
        case SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_LoadError:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_LoadError");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_NetworkError:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_NetworkError");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_EOF:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_EOF");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_JogParameter:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_JogParameter");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_DurationChanged:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_DurationChanged");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_LoopEnd:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_LoopEnd");
        default:
            break;
    }
}


@end














