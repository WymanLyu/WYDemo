//
//  AudioManager.m
//  6-16Recorder-Effect
//
//  Created by wyman on 2017/6/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "AudioManager.h"
#import "SuperpoweredIOSAudioIO.h"
#import "SuperpoweredSimple.h"

#import "webrtc/modules/audio_processing/agc/agc.h"
#import "webrtc/modules/audio_processing/audio_processing_impl.h"

#import "SuperpoweredLimiter.h"
#import "SuperpoweredClipper.h"

#import "FXWebRTC.h"
#import "AMConst.h"

using namespace webrtc;

@interface AudioManager ()<SuperpoweredIOSAudioIODelegate>


@end

@implementation AudioManager
{
@private
    SuperpoweredIOSAudioIO *_audioIO;
    
    float *_buffers_Interleave;
    float *_buffers_Interleave_mono;
    SInt16 *_buffers_Interleave_mono_shortInt;
    
    Agc *_agc;
    
    SuperpoweredLimiter *_limiter;
    SuperpoweredClipper *_clipper;
    FXWebRTC *_webRTC;

}

- (void)dealloc {
    delete _agc;
    delete _webRTC;
    delete _limiter;
    delete _clipper;
    free(_buffers_Interleave);
    free(_buffers_Interleave_mono);
    free(_buffers_Interleave_mono_shortInt);
}

static int call_count = 0;

void printBuffer(float **buffers, unsigned int numberOfSamples)
{
    int i = 1;
    printf(">>>>buffers_debug_print==============================\n");
    while (i < 5) {
        float number1 = buffers[0][numberOfSamples-i];
        float number2 = buffers[1][numberOfSamples-i];
        printf("  ---   倒数第%i个buffer的 左声道:%f 右声道:%f \n", i, number1, number2);
        i++;
    }
    printf(">>>>buffers_debug_print==============================\n");
}

#pragma mark - IO回调
static bool audioProcessing (void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {

#ifdef FXAM_IOS_LOG
    NSLog(@"录制-------------------->\n");
//    printBuffer(buffers, numberOfSamples);
#endif

    
    bool silence = true;

    // 0.回调上下文对象
    __unsafe_unretained AudioManager *self = (__bridge AudioManager *)clientdata;
    
    // 1.初始化各种内存数据
    // 1.1.交错类型
    SuperpoweredInterleave(buffers[0], buffers[1], self->_buffers_Interleave, numberOfSamples);
    // 1.2.交错单声道
    SuperpoweredStereoToMono(self->_buffers_Interleave, self->_buffers_Interleave_mono, 0.5, 0.5, 0.5, 0.5, numberOfSamples);
    // 1.3.交错单声道短整型
    SuperpoweredFloatToShortInt(self->_buffers_Interleave_mono, self->_buffers_Interleave_mono_shortInt, numberOfSamples);
    
    // 2.BeforePreFX回调
    if ([self.delegate respondsToSelector:@selector(audioManagerIOBeforePreFX:buffers:numberOfSamples:)]) {
        silence = [self.delegate audioManagerIOBeforePreFX:self buffers:self->_buffers_Interleave numberOfSamples:numberOfSamples];
    }
    
    // 3.PreFX处理
    if (self.openPreFX) {
        silence = !self->_webRTC->process(buffers, numberOfSamples, CHANNELS);
        if (!silence) {
            [self refreshMemBuffer:buffers numberOfSamples:numberOfSamples];
        }
    }
    
    // 4.AfterPreFX回调
    if ([self.delegate respondsToSelector:@selector(audioManagerIOAfterFX:buffers:numberOfSamples:)]) {
        silence = [self.delegate audioManagerIOAfterPreFX:self buffers:self->_buffers_Interleave numberOfSamples:numberOfSamples];
    }
    
    // 5.BeforeFX回调
    if ([self.delegate respondsToSelector:@selector(audioManagerIOBeforeFX:buffers:numberOfSamples:)]) {
        silence = [self.delegate audioManagerIOBeforeFX:self buffers:self->_buffers_Interleave numberOfSamples:numberOfSamples];
    }
    
    // 6.FX处理
    if (self.openFX) {
        
    }
    
    // 7.IOAfterFX回调
    if ([self.delegate respondsToSelector:@selector(audioManagerIOAfterFX:buffers:numberOfSamples:)]) {
        silence = [self.delegate audioManagerIOAfterFX:self buffers:self->_buffers_Interleave numberOfSamples:numberOfSamples];
    }
    
    // 8.拆成左右声道
    if (!silence) {
        SuperpoweredDeInterleave(self->_buffers_Interleave, buffers[0], buffers[1], numberOfSamples);
    }
    
#ifdef FXAM_IOS_LOG
    printf("播放-------------------->\n");
#endif
    
    return !silence;

}

- (void)interruptionStarted {}
- (void)recordPermissionRefused {}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {}
- (void)interruptionEnded {}

// 刷新buffer数据
- (void)refreshMemBuffer:(float **)buffers  numberOfSamples:(int)numberOfSamples {
    // 1.1.交错类型
    SuperpoweredInterleave(buffers[0], buffers[1], self->_buffers_Interleave, numberOfSamples);
    // 1.2.交错单声道
    SuperpoweredStereoToMono(self->_buffers_Interleave, self->_buffers_Interleave_mono, 0.5, 0.5, 0.5, 0.5, numberOfSamples);
    // 1.3.交错单声道短整型
    SuperpoweredFloatToShortInt(self->_buffers_Interleave_mono, self->_buffers_Interleave_mono_shortInt, numberOfSamples);
}

#pragma mark - 构造
- (instancetype)initWithDelegate:(id<AudioManagerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        // 初始化IO回调
        _audioIO = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:self preferredBufferSize:BUFFER_SIZE preferredMinimumSamplerate:FS audioSessionCategory:AVAudioSessionCategoryPlayAndRecord channels:CHANNELS audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
        _openIO = NO;
        _openPreFX = NO;
        [_audioIO stop];
        
        // 初始化内存
        posix_memalign((void **)&self->_buffers_Interleave_mono, 16, (sizeof(float)*BUFFER_SAMPLE_COUNT+64));
        posix_memalign((void**)&self->_buffers_Interleave_mono_shortInt, 16, (sizeof(SInt16)*BUFFER_SAMPLE_COUNT+64));
        posix_memalign((void **)&self->_buffers_Interleave, 16, (sizeof(float)*BUFFER_SAMPLE_COUNT+64)*CHANNELS);
        
        // 效果器
        self->_webRTC = new FXWebRTC(BUFFER_SAMPLE_COUNT, WEBRTC_BUFFER_SAMPLE_COUNT, CHANNELS);
        
        self->_clipper = new SuperpoweredClipper();
        self->_clipper->thresholdDb = -2.0;
        self->_clipper->maximumDb = -3.0;
        
        self->_limiter = new SuperpoweredLimiter(FS);
        self->_limiter->enable(YES);
        self->_limiter->ceilingDb = -1.0;
        self->_limiter->thresholdDb = 0.0;
        
    }
    return self;
}

#pragma mark - IO开关
- (void)openAudioIO {
    if (![_audioIO started]) {
        [_audioIO start];
        _openIO = YES;
    }
}

- (void)closeAudioIO {
    if ([_audioIO started]) {
        [_audioIO stop];
         _openIO = NO;
    }
}

- (void)setAgcState:(bool)enable {
    self->_webRTC->apm->setAgcState(enable);
}

- (void)setNsLevel:(bool)enable {
    self->_webRTC->apm->setNsState(enable);
}


@end
