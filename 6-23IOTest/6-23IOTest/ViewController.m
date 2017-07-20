//
//  ViewController.m
//  6-23IOTest
//
//  Created by wyman on 2017/6/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "SuperpoweredIOSAudioIO.h"
#import "WYAudioIO.h"

@interface ViewController ()<SuperpoweredIOSAudioIODelegate>

@property (nonatomic, strong) SuperpoweredIOSAudioIO *IO;
@property (nonatomic, strong) SuperpoweredIOSAudioIO *IO2;


@property (nonatomic, strong) WYAudioIO *wy_IO;

@end

@implementation ViewController

void *sss = &sss;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _IO = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:self preferredBufferSize:11 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryPlayAndRecord channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
    _IO2 = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:self preferredBufferSize:11 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryPlayAndRecord channels:2 audioProcessingCallback:audioProcessing clientdata:sss];
    
//    _wy_IO = [[WYAudioIO alloc] initWithDelegate:self preferredIOBufferDuration:10 preferredSampleRate:48000 audioSessionCategory:AVAudioSessionCategoryPlayAndRecord channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
    
//    NSError *err = nil;
//    
//    NSLog(@"\n====\n---category:%@\n---categoryOptions:%zd\n---mode:%@\n====\n\n", [[AVAudioSession sharedInstance] category], [[AVAudioSession sharedInstance] categoryOptions], [[AVAudioSession sharedInstance] mode]);
//    NSLog(@"\n====\n---preferredSampleRate:%zd\n---sampleRate:%zd\n---preferredIOBufferDuration:%f\n---IOBufferDuration:%f\n====\n\n",   [[AVAudioSession sharedInstance] preferredSampleRate],  [[AVAudioSession sharedInstance] sampleRate], [[AVAudioSession sharedInstance] preferredIOBufferDuration], [[AVAudioSession sharedInstance] IOBufferDuration]);
//    
//     [[AVAudioSession sharedInstance] setActive:NO error:nil];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:0 error:nil];
//    
//    [[AVAudioSession sharedInstance] setPreferredSampleRate:44100 error:&err];
//    if (err) {
//        NSLog(@"PreferredSampleRate错误--%@", err);
//    }
//    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:0.001 error:&err];
//    if (err) {
//        NSLog(@"PreferredIOBufferDuration错误--%@", err);
//    }
//
//    [[AVAudioSession sharedInstance] setActive:YES error:&err];
//    if (err) {
//        NSLog(@"setActive错误--%@", err);
//    }
//
//    
//    
//    NSLog(@"\n====\n---category:%@\n---categoryOptions:%zd\n---mode:%@\n====\n\n", [[AVAudioSession sharedInstance] category], [[AVAudioSession sharedInstance] categoryOptions], [[AVAudioSession sharedInstance] mode]);
//    NSLog(@"\n====\n---preferredSampleRate:%zd\n---sampleRate:%zd\n---preferredIOBufferDuration:%f\n---IOBufferDuration:%f\n====\n\n",   [[AVAudioSession sharedInstance] preferredSampleRate],  [[AVAudioSession sharedInstance] sampleRate], [[AVAudioSession sharedInstance] preferredIOBufferDuration], [[AVAudioSession sharedInstance] IOBufferDuration]);
    
    
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"start:%@",[NSThread mainThread]);
    [_IO start];
    [_IO2 start];
//    [_wy_IO start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static bool audioProcessing (void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
    
    NSString *type = @"IO1";
    if (clientdata == sss) {
        type = @"IO2";
    }
    
    NSLog(@"%@---numberOfSamples:%zd---samplerate:%zd---inputChannels:%zd---preferredIOBufferDuration:%f---IOBufferDuration:%f---firstNumber:%f",type, numberOfSamples, samplerate,  inputChannels, [[AVAudioSession sharedInstance] preferredIOBufferDuration], [[AVAudioSession sharedInstance] IOBufferDuration], buffers[0][1]);
    NSLog(@"%@", [NSThread mainThread]);
    return NO;
}

- (void)interruptionStarted {}
- (void)recordPermissionRefused {}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {}
- (void)interruptionEnded {}


@end
