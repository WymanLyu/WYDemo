//
//  AudioManager.m
//  6-16Recorder-Effect
//
//  Created by wyman on 2017/6/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "AudioManager.h"
#import "SuperpoweredIOSAudioIO.h"

#define FS 44100       // 采样率
#define BUFFER_SIZE 12 // IO回调buffer的大小 == 2^12 个samples

@interface AudioManager ()<SuperpoweredIOSAudioIODelegate>

@end

@implementation AudioManager
{
@private
    SuperpoweredIOSAudioIO *_audioIO;

}

#pragma mark - IO回调
static bool audioProcessing (void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
    return YES;
}

#pragma mark - 构造
- (instancetype)initWithDelegate:(id<AudioManagerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        // 初始化IO回调
        _audioIO = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:self preferredBufferSize:BUFFER_SIZE preferredMinimumSamplerate:FS audioSessionCategory:AVAudioSessionCategoryPlayAndRecord channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
        [_audioIO start];
    }
    return self;
}

#pragma mark - IO开关
- (void)openAudioIO {
    
}

- (void)closeAudioIO {
    
}


@end
