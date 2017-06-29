//
//  ViewController.m
//  6-23IOTest
//
//  Created by wyman on 2017/6/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "SuperpoweredIOSAudioIO.h"

@interface ViewController ()<SuperpoweredIOSAudioIODelegate>

@property (nonatomic, strong) SuperpoweredIOSAudioIO *IO;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _IO = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:self preferredBufferSize:9 preferredMinimumSamplerate:48000 audioSessionCategory:AVAudioSessionCategoryPlayAndRecord channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
    [_IO start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static bool audioProcessing (void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
    
    NSLog(@"---numberOfSamples:%zd---samplerate:%zd---inputChannels:%zd---preferredIOBufferDuration:%f---IOBufferDuration:%f", numberOfSamples, samplerate,  inputChannels, [[AVAudioSession sharedInstance] preferredIOBufferDuration], [[AVAudioSession sharedInstance] IOBufferDuration]);
    return NO;
}

- (void)interruptionStarted {}
- (void)recordPermissionRefused {}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {}
- (void)interruptionEnded {}


@end
