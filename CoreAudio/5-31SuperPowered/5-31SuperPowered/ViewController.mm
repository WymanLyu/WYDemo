//
//  ViewController.m
//  5-31SuperPowered
//
//  Created by wyman on 2017/5/31.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "SuperpoweredRecorder.h"
#import "SuperpoweredIOSAudioIO.h"
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredSimple.h"

#import "SuperpoweredLimiter.h"

//#import "gain_control.h"

#import "WYSoundWaveView.h"
#import "WYSoundWaveRenderBufferQueue.h"

#define FS 44100// 48000

#define BUFFER_SIZE 12 // 2的次幂

#define WEBRTC_AGC_BUFFER_SIZE (FS*0.01)

@interface ViewController ()<SuperpoweredIOSAudioIODelegate, WYSoundWaveRenderBufferQueueDelegate>

@property (nonatomic, assign) BOOL isMix;

@property (nonatomic, assign) float volume;

@property (nonatomic, strong) WYSoundWaveView *waveView;
@property (nonatomic, strong) WYSoundWaveRenderBufferQueue *renderBufferQueue;

@end

@implementation ViewController
{
    SuperpoweredRecorder *_recorder;
    
    SuperpoweredAdvancedAudioPlayer *_player;
    
    SuperpoweredIOSAudioIO *_output;
    
    float *_audioFileBuffer;
    
    float *recoreder_buffer;
    float *recoreder_buffer_mono;

    SuperpoweredLimiter *_limiter;
    
//    WebRtcAgc_config_t _webConfig;
    
     void *_agc;
    
    short *int16Samples; // recoreder_buffer float to short
}


void *playerContext = &playerContext;

- (void)viewDidLoad {
    [super viewDidLoad];

    recoreder_buffer = NULL;
    _volume = 0.5;
    
    _waveView = [WYSoundWaveView new];
    _waveView.frame = self.waveBgView.bounds;
    [self.waveBgView addSubview:_waveView];
    
    self.renderBufferQueue = [[WYSoundWaveRenderBufferQueue alloc] initQueueWithObserver:self inputBufferSize:pow(2, BUFFER_SIZE) outputBufferSize:5*8 callBackFrequency:1.0/20.0 enqueueBufferFrequency:((pow(2, BUFFER_SIZE)*1.0)/FS)];
    
    // 配置
//    _webConfig.limiterEnable = kAgcTrue;
//    _webConfig.compressionGaindB = 9.0;
//    _webConfig.targetLevelDbfs = 3.0;
//    // webRTC的自定增益
//    WebRtcAgc_Create(&_agc);
//    // 初始化
//    int theRrr = WebRtcAgc_Init(_agc, 0, 255, kAgcModeAdaptiveDigital, FS);
//    if (0 == theRrr) {
//        NSLog(@"OK");
//    }
//    // 设置配置
//    WebRtcAgc_set_config(_agc, _webConfig);
    
    
    // 录音机
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *recorderPath= [NSString stringWithFormat:@"%@/tttt.wav", path];
    const char *p = [recorderPath cStringUsingEncoding:NSUTF8StringEncoding];
    _recorder = new SuperpoweredRecorder(p, FS, 1);
//    _recorder = new SuperpoweredRecorder("/Users/wyman/Desktop/SuperpoweredTest/xxoo.wav", FS, 1);
    
    // 播放器
    if (posix_memalign((void **)&_audioFileBuffer, 16, 4096 + 128) != 0) {
        //  32-bit interleaved stereo input/output buffer. Should be numberOfSamples * 8 + 64 bytes big
        abort();
    };
    _player = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallback, FS, 0);
    _player->open([[[NSBundle mainBundle] pathForResource:@"KakiImp" ofType:@"mp3"] fileSystemRepresentation]);
    
    // limiter
    _limiter = new SuperpoweredLimiter(FS);
    _limiter->ceilingDb = -0.3;
    _limiter->thresholdDb = -40.0;
    
    
    // 初始化IO回调
    _output = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:self preferredBufferSize:BUFFER_SIZE preferredMinimumSamplerate:FS audioSessionCategory:AVAudioSessionCategoryPlayAndRecord channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
     [_output start];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _waveView.frame = self.waveBgView.bounds;
}

#pragma mark - 处理渲染波形回调
- (void)renderBufferQueueOutCallback:(SInt16 *)reSamples reSampleCount:(int)reSampleCount {
//    NSLog(@"%s", __func__);
    [self->_waveView drawSaveWithSamples:reSamples sampleCount:reSampleCount];
}

#pragma mark - IO回调

static bool audioProcessing (void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
    
    
//    NSLog(@"inputChannels:%zd -- outputChannels:%zd -- numberOfSamples:%zd",inputChannels, outputChannels, numberOfSamples);
    
    // 0.回调上下文对象
    __unsafe_unretained ViewController *self = (__bridge ViewController *)clientdata;
    
    // 1.获取数据PCM / 写入文件
    self->_recorder->process(buffers[0], buffers[1], numberOfSamples);
    
    // 2.读取文件
    bool silence = !self->_player->process(self->_audioFileBuffer, false, numberOfSamples, 1.0, 0.0, -1.0);
    silence = NO;
    
    // 2.1.画人声波形
    if (!silence) {
        @autoreleasepool {
            if (NULL == self->int16Samples) {
                self->int16Samples = (short *)malloc(sizeof(SInt16)*numberOfSamples + 32);
            }
            if (NULL == self->recoreder_buffer) {
                self->recoreder_buffer = (float *)malloc(sizeof(float)*numberOfSamples*2 + 64);
            }
            if (NULL == self->recoreder_buffer_mono) {
                self->recoreder_buffer_mono = (float *)malloc(sizeof(float)*numberOfSamples+32);
            }
            //
            SuperpoweredInterleave(buffers[0], buffers[1], self->recoreder_buffer, numberOfSamples);
            // 入列
            SuperpoweredStereoToMono(self->recoreder_buffer, self->recoreder_buffer_mono, 0.5, 0.5, 0.5, 0.5, numberOfSamples);
            SuperpoweredFloatToShortInt(self->recoreder_buffer_mono, self->int16Samples, (unsigned  int)numberOfSamples);
            
            int index = 0;
            while (index < numberOfSamples) {
               
                NSLog(@"ooooooooooooooo->%hd", self->int16Samples[index]);
                index++;
            }
            
            [self.renderBufferQueue enqueueBuffer:self->int16Samples sampleCount:numberOfSamples];
        }
    }
    
    
//    short *webRTC_agc_output = new short(WEBRTC_AGC_BUFFER_SIZE);
//    SuperpoweredFloatToShortInt(buffers[0], webRTC_agc_output, (unsigned  int)WEBRTC_AGC_BUFFER_SIZE);
//    // 估计响度
//    WebRtcAgc_AddFarend(self->_agc, webRTC_agc_output, FS*0.01);
//    
//    short *outGain = NULL;
//    
//    static int outMicLevel = 0;
//    int inMicLevel  = outMicLevel;
//
//    uint8_t saturationWarning;
//    int nAgcRet = WebRtcAgc_Process(self->_agc, webRTC_agc_output, NULL, WEBRTC_AGC_BUFFER_SIZE, outGain, NULL, inMicLevel, &outMicLevel, 0, &saturationWarning);
//    if (nAgcRet != 0) {
//        printf("failed in WebRtcAgc_Process\n");
//    }
//    NSLog(@"===%zd", outMicLevel);
    
    
    
    // 3.混音返听
    if (!silence) {
        if (self->_isMix && [self isHeadSetPlugging]) {
            if (NULL == self->recoreder_buffer) {
                self->recoreder_buffer = (float *)malloc(32*numberOfSamples*2 + 64);
            }
            // 合成交错buffer
            SuperpoweredInterleave(buffers[0], buffers[1], self->recoreder_buffer, numberOfSamples);
            // 过limiter
            self->_limiter->process(self->recoreder_buffer, self->recoreder_buffer, numberOfSamples);
            // mix
//             SuperpoweredAdd1(self->_audioFileBuffer, self->recoreder_buffer, numberOfSamples);
            SuperpoweredVolumeAdd(self->_audioFileBuffer, self->recoreder_buffer, self.volume, self.volume, numberOfSamples);
            // 拆成双数组进行播放[前提是outputChannels是双通道]
            SuperpoweredDeInterleave(self->recoreder_buffer, buffers[0], buffers[1], numberOfSamples);
            
        } else {
            SuperpoweredDeInterleave(self->_audioFileBuffer, buffers[0], buffers[1], numberOfSamples);
//            SuperpoweredStereoToMono(self->_audioFileBuffer, buffers[0], 0.5, 0.5, 0.5, 0.5, numberOfSamples);
            
        }
    }

    return !silence;
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


#pragma mark - IO代理

- (void)interruptionStarted {}
- (void)recordPermissionRefused {}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {}
- (void)interruptionEnded {}

#pragma mark - 控制
- (IBAction)beginOrPause:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) { // 暂停->开始
//        _recorder->start("/Users/wyman/Desktop/SuperpoweredTest/xxoo22");
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *recorderPath= [NSString stringWithFormat:@"%@/ttttq.wav", path];
        const char *p = [recorderPath cStringUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"---%s", p);
        _recorder->start(p);
        
        
//        _player->play(false);
    } else { // 开始->暂停
        _recorder->stop();
        _player->pause();
    }
}

- (IBAction)stop:(UIButton *)sender {
    _recorder->stop();
    
}

- (IBAction)mixRecordFile2Play:(UISwitch *)sender {
    self.isMix = sender.isOn;
}

- (IBAction)sliderV:(UISlider *)sender {
    self.volume = sender.value;
}


- (IBAction)gainChange:(UISlider *)sender {
    NSError* error;
    [AVAudioSession sharedInstance];
    if ([AVAudioSession sharedInstance].isInputGainSettable) {
        BOOL success = [[AVAudioSession sharedInstance] setInputGain:sender.value
                                                               error:&error];
        if (!success){
            NSLog(@"set input gain - error");
        }
    } else {
        NSLog(@"ios6 - cannot set input gain");
    }
}

- (IBAction)limiteChange:(UISlider *)sender {
    self->_limiter->thresholdDb = sender.value * -40.0;
    self->_limiter->reset();
}

#pragma mark - 耳机

- (BOOL)isHeadSetPlugging {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}




@end
