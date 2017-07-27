//
//  AudioManager.m
//  6-16Recorder-Effect
//
//  Created by wyman on 2017/6/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "AudioManager.h"
#import "AMConst.h"
#import "SuperpoweredSimple.h"
#import "SuperpoweredIOSAudioIO.h"

#import "FXWebRTC.h"
#import "SuperpoweredLimiter.h"
#import "SuperpoweredClipper.h"


#import "LimiterFxUnit.h"
#import "ClipperFxUnit.h"
#import "FlangerFxUnit.h"
#import "ReverbFxUnit.h"
#import "EchoFxUnit.h"
#import "FxConstants.h"

#import "FXHeader.h"

using namespace webrtc;

@interface AudioManager ()<SuperpoweredIOSAudioIODelegate>

@end

@implementation AudioManager
{
@private
    SuperpoweredIOSAudioIO *_audioIO;
    
    float *_buffers_Interleave;
    
    SuperpoweredLimiter *_limiter;
    SuperpoweredClipper *_clipper;
    // preFX
    FXWebRTC *_webRTC;
    // FX
    FlangerFxUnit *_flangerFX;
    ReverbFxUnit *_reverbFX;
    LimiterFxUnit *_limiterFX;
    EchoFxUnit *_echoFX;
    

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    delete _webRTC;
    delete _limiter;
    delete _clipper;
    
    delete _reverbFX;
    delete _flangerFX;
    delete _limiterFX;
    delete _echoFX;
    free(_buffers_Interleave);
}

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
        posix_memalign((void **)&self->_buffers_Interleave, 16, (sizeof(float)*BUFFER_SAMPLE_COUNT+64)*CHANNELS);
        _fxArrayM = [NSMutableArray array];
        
        // 效果器
        self->_webRTC = new FXWebRTC(BUFFER_SAMPLE_COUNT, WEBRTC_BUFFER_SAMPLE_COUNT, CHANNELS);
        
        self->_clipper = new SuperpoweredClipper();
        self->_clipper->thresholdDb = -2.0;
        self->_clipper->maximumDb = -3.0;
        
        self->_limiter = new SuperpoweredLimiter(FS);
        self->_limiter->enable(YES);
        self->_limiter->ceilingDb = -1.0;
        self->_limiter->thresholdDb = 0.0;
        
        self->_reverbFX = new ReverbFxUnit(FS);
        self->_flangerFX = new FlangerFxUnit(FS);
        self->_limiterFX = new LimiterFxUnit(FS);
        self->_echoFX = new EchoFxUnit(FS);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFX) name:UPDATE_FX_PROPERTY object:nil];
        
    }
    return self;
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
    
    // 2.BeforePreFX回调
    if ([self.delegate respondsToSelector:@selector(audioManagerIOBeforePreFX:buffers:numberOfSamples:)]) {
        silence = [self.delegate audioManagerIOBeforePreFX:self buffers:self->_buffers_Interleave numberOfSamples:numberOfSamples];
    }
    
    // 3.PreFX处理
    if (self.openPreFX) {
        silence = !self->_webRTC->process(buffers, numberOfSamples, CHANNELS);
        if (!silence) {
            SuperpoweredInterleave(buffers[0], buffers[1], self->_buffers_Interleave, numberOfSamples);
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
        [self updateFX];
        self->_reverbFX->process(self->_buffers_Interleave, self->_buffers_Interleave, numberOfSamples);
        self->_flangerFX->process(self->_buffers_Interleave, self->_buffers_Interleave, numberOfSamples);
        self->_echoFX->process(self->_buffers_Interleave, self->_buffers_Interleave, numberOfSamples);
        self->_limiterFX->process(self->_buffers_Interleave, self->_buffers_Interleave, numberOfSamples);
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

#pragma mark - 效果器设置

- (void)updateFX {
    for (FXItem *item in _fxArrayM) {
        if (!item.isDirty) {
            continue;
        }
        switch (item.fxId) {
            case FX_TYPE_FILTER:
            {
            
            }
                break;
            case FX_TYPE_REVERB:
            {
                FXReverbItem *realItem = (FXReverbItem *)item;
                self->_reverbFX->setWet(realItem.wet);
                self->_reverbFX->setDry(realItem.dry);
                self->_reverbFX->setMix(realItem.mix);
                self->_reverbFX->setDamp(realItem.damp);
                self->_reverbFX->setWidth(realItem.width);
                self->_reverbFX->setRoomSize(realItem.roomSize);
                self->_reverbFX->enable(realItem.enble);
                realItem.dirty = NO;
            }
                break;
            case FX_TYPE_FLANGER:
            {
                FXFlangerItem *realItem = (FXFlangerItem *)item;
                self->_flangerFX->setWet(realItem.wet);
                self->_flangerFX->setDepth(realItem.depth);
                self->_flangerFX->setLFOBeats(realItem.LFOBeats);
                self->_flangerFX->enable(realItem.enble);
                realItem.dirty = NO;
            }
                break;
            case FX_TYPE_3_BAND_EQ:
            {
                
            }
                break;
            case FX_TYPE_GATE:
            {
                
            }
                break;
            case FX_TYPE_ROLL:
            {
                
            }
                break;
            case FX_TYPE_ECHO:
            {
                FXEchoItem *realItem = (FXEchoItem *)item;
                self->_echoFX->setWet(realItem.wet);
                self->_echoFX->setBpm(realItem.bpm);
                self->_echoFX->setDry(realItem.dry);
                self->_echoFX->setBeats(realItem.beats);
                self->_echoFX->setDecay(realItem.decay);
                self->_echoFX->setMix(realItem.mix);
                self->_echoFX->enable(realItem.enble);
                realItem.dirty = NO;
                
            }
                break;
            case FX_TYPE_WOOSH:
            {
                
            }
                break;
            case FX_TYPE_LIMITER:
            {
                FXLimiterItem *realItem = (FXLimiterItem *)item;
                self->_limiterFX->setCeilingDb(realItem.ceilingDb*-40);
                self->_limiterFX->setReleaseSec(realItem.releaseSec*-40);
                self->_limiterFX->setThresholdDb(realItem.thresholdDb*(1.6-0.1) + 0.1);
                self->_limiterFX->enable(realItem.enble);
                realItem.dirty = NO;
            }
                break;
            default:
                break;
        }
    }
}


@end
