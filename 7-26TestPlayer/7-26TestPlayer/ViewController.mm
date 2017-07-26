//
//  ViewController.m
//  7-26TestPlayer
//
//  Created by wyman on 2017/7/26.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "SuperpoweredIOSAudioIO.h"
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredSimple.h"

@interface ViewController ()

@end

@implementation ViewController
{
    SuperpoweredIOSAudioIO *IO;
    SuperpoweredAdvancedAudioPlayer *player;
    float *stereoBuffer;
    
}

- (void)dealloc {
    delete player;
    free(stereoBuffer);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (posix_memalign((void **)&stereoBuffer, 16, 4096 + 128) != 0) abort(); // Allocating memory, aligned to 16.
    IO = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:(id<SuperpoweredIOSAudioIODelegate>)self preferredBufferSize:12 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryPlayback channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
    self->player = new  SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackA, 44100, 0);
    self->player->open([[[NSBundle mainBundle] pathForResource:@"lycka" ofType:@"mp3"] fileSystemRepresentation]);
//    self->player->open([[[NSBundle mainBundle] pathForResource:@"welcome" ofType:@"mp3"] fileSystemRepresentation]);
     self->player->play(false);
     [IO start];
    
}

static bool a = true;
static bool change = false;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    change = true;
//    self->player->pause();
    
//    self->player->togglePlayback();
//    self->player->setPosition(0.0, true, false);
//    self->player->open([[[NSBundle mainBundle] pathForResource:@"welcome" ofType:@"mp3"] fileSystemRepresentation]);
//    self->player->play(false);
    
//    self->player->togglePlayback();
    
    a = !a;
    if (a) {
        self->player->open([[[NSBundle mainBundle] pathForResource:@"lycka" ofType:@"mp3"] fileSystemRepresentation]);
        self->player->play(false);
    } else {
        self->player->open([[[NSBundle mainBundle] pathForResource:@"nuyorica" ofType:@"m4a"] fileSystemRepresentation]);
        self->player->play(false);
    }

    
}

static bool audioProcessing(void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
    ViewController *self = (__bridge ViewController *)clientdata;
     bool silence = !self->player->process(self->stereoBuffer, false, numberOfSamples, 1.0, 0.0, -1.0);
    if (!silence) SuperpoweredDeInterleave(self->stereoBuffer, buffers[0], buffers[1], numberOfSamples);
    return !silence;
}

void playerEventCallbackA(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
    ViewController *self = (__bridge ViewController *)clientData;
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
//            if (change) {
//                self->player->play(false);
//                change = false;
//            }
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_LoopEnd:
                        NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_LoopEnd");
        default:
            break;
    }

//    if (change) {
//        ViewController *self = (__bridge ViewController *)clientData;
//        a = !a;
//        if (a) {
//            self->player->open([[[NSBundle mainBundle] pathForResource:@"lycka" ofType:@"mp3"] fileSystemRepresentation]);
//            self->player->play(false);
//        } else {
//            self->player->open([[[NSBundle mainBundle] pathForResource:@"nuyorica" ofType:@"m4a"] fileSystemRepresentation]);
//            self->player->play(false);
//        }
//        change = false;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)interruptionStarted {}
- (void)recordPermissionRefused {}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {}
- (void)interruptionEnded {}


@end
