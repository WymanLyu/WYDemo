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
    float *_audioFileBuffer;
}

#pragma mark - 初始化
- (instancetype)initWithFileURL:(NSURL *)url {
    if (self = [super init]) {
        if (posix_memalign((void **)&_audioFileBuffer, 16, (BUFFER_SAMPLE_COUNT*sizeof(float)*CHANNELS + 64)) != 0) {
            //  32-bit interleaved stereo input/output buffer. Should be numberOfSamples * 8 + 64 bytes big
            abort();
        };
        _player = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallback, FS, 0);
        _fileURL = url;
        if (_fileURL.absoluteString.length) {
            _player->open(_fileURL.fileSystemRepresentation);
        }
        _paused = YES;
    }
    return self;
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
    _paused = NO;
    _player->play(false);
}

- (void)stop {
    _paused = YES;
    free(_audioFileBuffer);
    _audioFileBuffer = NULL;
    delete _player;
    _player = NULL;
    if (posix_memalign((void **)&_audioFileBuffer, 16, (BUFFER_SAMPLE_COUNT*sizeof(float)*CHANNELS + 64)) != 0) {
        //  32-bit interleaved stereo input/output buffer. Should be numberOfSamples * 8 + 64 bytes big
        abort();
    };
    _player = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallback, FS, 0);
    if (_fileURL.absoluteString.length) {
        _player->open(_fileURL.fileSystemRepresentation);
    }
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














