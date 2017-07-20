//
//  ViewController.m
//  7-20AudioPitch
//
//  Created by wyman on 2017/7/20.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "PitchDetector.h"
#import "SuperpoweredIOSAudioIO.h"

#define TWO_M_PI (M_PI*2)

#define SAMPLE_RATE 44100.0
#define DURATION 50

// 正弦波
double _sin(double t, float Frequency, float Phase)
{
    return ((1.0/Frequency)*SHRT_MAX)*sin(Frequency*TWO_M_PI*t + Phase);
}

// 获取音频数据 duration 单位s 基于44100的采样
void audioDigitalData(double sampleCount, float *audioDigitalData)
{
    const float Frequency0 = 48, Frequency1 = 243, Frequency2 = 230;
    const float Phase0 = 1.f/3, Phase1 = .82f, Phase2 = .5f;
    long currentSampleIndex = 0;
    double duration = sampleCount / SAMPLE_RATE;
    while (currentSampleIndex < sampleCount) {
        
        double time = ((currentSampleIndex*1.0) / sampleCount)*duration;
        audioDigitalData[currentSampleIndex] =    _sin(time, Frequency0, Phase0)
        + _sin(time, Frequency1, Phase1)
        + _sin(time, Frequency2, Phase2);
        currentSampleIndex++;
    }
}

@interface ViewController ()<SuperpoweredIOSAudioIODelegate>


{
    @public
    SuperpoweredIOSAudioIO *_IO;
    PitchDetector *_pitchDetector;
}
@property (weak, nonatomic) IBOutlet UILabel *freLbl;
@property (weak, nonatomic) IBOutlet UILabel *pitchLbl;

@end

bool mAudioProcessingCallback(void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
    
    ViewController *vc = (__bridge ViewController *)clientdata;
    Pitch pit = vc->_pitchDetector->process2queue_average(buffers[0], numberOfSamples);
    dispatch_async(dispatch_get_main_queue(), ^{
        vc.freLbl.text = [NSString stringWithFormat:@"%.1f", pit.frequency];
        vc.pitchLbl.text = [NSString stringWithFormat:@"%s", pit.stepString.c_str()];
    });
    
    return false;
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _IO = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:self preferredBufferSize:12 preferredMinimumSamplerate:SAMPLE_RATE audioSessionCategory:AVAudioSessionCategoryPlayAndRecord channels:2 audioProcessingCallback:mAudioProcessingCallback clientdata:(void *)self];
    [_IO stop];
    _pitchDetector = new PitchDetector(512, SAMPLE_RATE);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_IO start];
}


- (void)test {
    // 1.原始数组 三个正弦波叠加 44100采样
    double sampleCount = SAMPLE_RATE * DURATION;
    float *digitalData = (float *)malloc(sizeof(float)*sampleCount);
    audioDigitalData(sampleCount, digitalData);

    // 2.获取1024buffer
    int n = 1024;
    float *originalReal = (float *)malloc(sizeof(float)*n);
    for (int i = 0; i < n; i++) {
        originalReal[i] = digitalData[i];
    }

    // 3.检测音高
    PitchDetector *pitchDetector = new PitchDetector(n, SAMPLE_RATE);
    Pitch pit = pitchDetector->process(originalReal, n);
    NSLog(@"frequency:%f - amplitude:%f - octave:%ld - key:%ld - step:%ld - name :%s ", pit.frequency, pit.amplitude, pit.octave, pit.key, pit.step, pit.stepString.c_str());
}

- (void)interruptionStarted{}

- (void)interruptionEnded{}

- (void)recordPermissionRefused{}

- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs{}

@end
