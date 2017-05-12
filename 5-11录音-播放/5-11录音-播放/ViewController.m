//
//  ViewController.m
//  5-11录音-播放
//
//  Created by wyman on 2017/5/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "WYAVManager.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@end

@implementation ViewController
{

    NSURL *recorderUrl;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self SetRecordPlayAtSameTime_Func];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//     [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    
    UIButton *startBtn = [UIButton new];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn setTitle:@"停止" forState:UIControlStateSelected];
    startBtn.frame = CGRectMake(0, 80, 200, 88);
    [startBtn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:startBtn];
    [startBtn addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *playRecord = [UIButton new];
    [playRecord setTitle:@"播放录音" forState:UIControlStateNormal];
     [playRecord setBackgroundColor:[UIColor greenColor]];
    playRecord.frame = CGRectMake(0, 180, 200, 88);
    [self.view addSubview:playRecord];
    [playRecord addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.isSelected) { // 开始
        NSURL *songURL = [[NSBundle mainBundle] URLForResource:@"hbx" withExtension:@"mp3"];
        [[WYAVManager shareManager] wy_createItemWithUrl:songURL];
        [[WYAVManager shareManager] wy_startPlay];
        
        recorderUrl = [WYAVManager wy_recorderStart];
    } else { // 停止
        [[WYAVManager shareManager] wy_stopPlay];
        [WYAVManager wy_recorderEnd];
    }
    
}


- (void)playRecord {
    if (recorderUrl) {
        [[WYAVManager shareManager] wy_createItemWithUrl:recorderUrl];
        [[WYAVManager shareManager] wy_startPlay];
    }
}

- (void)upload {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
