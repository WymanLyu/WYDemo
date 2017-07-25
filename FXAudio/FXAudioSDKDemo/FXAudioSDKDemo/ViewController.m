//
//  ViewController.m
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

#import <FXAudio/AudioManager.h>
#import <FXAudio/AMRecorderPlayerControl.h>

#import "WYMeteorLightView.h"
#import "VGGradientSwitch.h"

#import <AVFoundation/AVFoundation.h>

#define BLUE_COLOR [UIColor colorWithRed:15/255.0 green:222/255.0 blue:200/255.0 alpha:1]
#define ORIGIN_COLOR [UIColor colorWithRed:237/255.0 green:140/255.0 blue:84/255.0 alpha:1]

@interface ViewController ()

@property (nonatomic, strong) AMRecorderPlayerControl *control;
@property (nonatomic, strong) AudioManager *manager;

#pragma mark - IO
@property (weak, nonatomic) IBOutlet WYMeteorLightView *IOLineView;
@property (weak, nonatomic) IBOutlet UIImageView *micImageView;
@property (weak, nonatomic) IBOutlet UIImageView *speakImageView;
@property (weak, nonatomic) IBOutlet VGGradientSwitch *IOSwitch;
@property (weak, nonatomic) IBOutlet VGGradientSwitch *PreFXSwitch;

#pragma mark - 伴奏
@property (weak, nonatomic) IBOutlet UIImageView *fileImageView;
@property (weak, nonatomic) IBOutlet VGGradientSwitch *filePlayerSwitch;
@property (weak, nonatomic) IBOutlet WYMeteorLightView *fileLineTop1;
@property (weak, nonatomic) IBOutlet WYMeteorLightView *fileLineRight;
@property (weak, nonatomic) IBOutlet WYMeteorLightView *fileLineTop2;
@property (weak, nonatomic) IBOutlet UISlider *volumSlider;

#pragma mark - 返听
@property (weak, nonatomic) IBOutlet VGGradientSwitch *returnVoiceSwitch;
@property (weak, nonatomic) IBOutlet UIView *returnLine;

#pragma mark - 波形
@property (nonatomic, strong) CAGradientLayer *afterFXWaveViewMask;
@property (nonatomic, strong) CAGradientLayer *beforeFXWaveViewMask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1.0f];

    [self audioManage];
    [self setupUI];
    [self setupEvent];
}

#pragma mark - 音频
- (void)audioManage {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"lycka" withExtension:@"mp3"];
    _control = [AMRecorderPlayerControl controlWithRecordFileURL:nil playFileURL:fileURL];
    _manager = [[AudioManager alloc] initWithDelegate:_control];
}

#pragma mark - 界面
- (void)setupUI {
    self.IOLineView.meteorLightColor = BLUE_COLOR;
    self.IOLineView.direction = MeteorLightDirectionBottom;
    self.fileLineTop1.direction = MeteorLightDirectionBottom;
    self.fileLineTop2.direction = MeteorLightDirectionBottom;
    self.fileLineRight.direction = MeteorLightDirectionRight;
    
    UIImageView *micMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"microphone"]];
    micMask.contentMode = UIViewContentModeScaleAspectFit;
    micMask.frame = self.micImageView.bounds;
    self.micImageView.maskView = micMask;
    UIImageView *speakMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speaker"]];
    speakMask.contentMode = UIViewContentModeScaleAspectFit;
    speakMask.frame = self.speakImageView.bounds;
    self.speakImageView.maskView = speakMask;
    UIImageView *fileMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file"]];
    fileMask.contentMode = UIViewContentModeScaleAspectFit;
    fileMask.frame = self.fileImageView.bounds;
    self.fileImageView.maskView = fileMask;
}

#pragma mark - 事件
- (void)setupEvent {
    __weak typeof(self)weakSelf = self;
    self.IOSwitch.action =  ^(BOOL isOn){
        if (isOn) { // 关闭
            [weakSelf.IOLineView stop];
            weakSelf.speakImageView.backgroundColor = BLUE_COLOR;
            weakSelf.micImageView.backgroundColor = BLUE_COLOR;
            weakSelf.IOLineView.backgroundColor = BLUE_COLOR;

            [weakSelf.control stopRecorder];
            [weakSelf.manager closeAudioIO];
            if (!weakSelf.filePlayerSwitch.isOn) { // 播放中
                [weakSelf.filePlayerSwitch setOn:YES animated:YES];
                weakSelf.filePlayerSwitch.action(YES);
            }
            
        } else { // 打开
            [weakSelf.IOLineView start];
            weakSelf.speakImageView.backgroundColor = ORIGIN_COLOR;
            weakSelf.micImageView.backgroundColor = ORIGIN_COLOR;
            weakSelf.IOLineView.backgroundColor = ORIGIN_COLOR;
            
            [weakSelf.manager openAudioIO];
            [weakSelf.control startRecorder];
        }
    };
    self.filePlayerSwitch.action = ^(BOOL isOn){
        if (isOn) { // 关闭
            [weakSelf.fileLineRight stop];
            [weakSelf.fileLineTop1 stop];
            [weakSelf.fileLineTop2 stop];
            [weakSelf.control pausePlayer];
            
            weakSelf.fileImageView.backgroundColor = BLUE_COLOR;
            weakSelf.fileLineRight.backgroundColor = BLUE_COLOR;
            weakSelf.fileLineTop1.backgroundColor = BLUE_COLOR;
            weakSelf.fileLineTop2.backgroundColor = BLUE_COLOR;
            weakSelf.volumSlider.tintColor = BLUE_COLOR;
            
            [weakSelf.control pausePlayer];
            
        } else { // 打开
            
            if (weakSelf.manager.isOpenIO) {
                
                [weakSelf.fileLineRight start];
                [weakSelf.fileLineTop1 start];
                [weakSelf.fileLineTop2 start];
                
                weakSelf.fileImageView.backgroundColor = ORIGIN_COLOR;
                weakSelf.fileLineRight.backgroundColor = ORIGIN_COLOR;
                weakSelf.fileLineTop1.backgroundColor = ORIGIN_COLOR;
                weakSelf.fileLineTop2.backgroundColor = ORIGIN_COLOR;
                weakSelf.volumSlider.tintColor = ORIGIN_COLOR
                ;
                
                [weakSelf.control startPlayer];
            } else {
                NSLog(@"请打开IO");
            }
        }
    };
    
    self.returnVoiceSwitch.action = ^(BOOL isOn){
        if (isOn) { // 关闭
            weakSelf.returnLine.hidden = NO;
            weakSelf.control.openReturnVoice = NO;
        } else { // 打开
            weakSelf.returnLine.hidden = YES;
            weakSelf.control.openReturnVoice = YES
            ;
        }
    };
    
    self.PreFXSwitch.action = ^(BOOL isOn){
        if (isOn) { // 关闭
            weakSelf.manager.openPreFX = NO;
        } else { // 打开
            weakSelf.manager.openPreFX = YES;
        }
    };

}

#pragma mark - 控制

- (IBAction)fileVolum:(UISlider *)sender {
    self.control.volume = sender.value;
}

- (IBAction)agcVolum:(UISlider *)sender {
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



@end



