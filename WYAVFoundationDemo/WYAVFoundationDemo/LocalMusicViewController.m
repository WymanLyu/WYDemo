//
//  LocalMusicViewController.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/15.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "LocalMusicViewController.h"
#import "WYAVManager.h"

@implementation LocalMusicViewController

- (IBAction)playeMusci:(UIButton *)sender {
    [WYAVManager wy_playMusicWithName:@"1201111234.mp3"];
}

- (IBAction)pauseMusic:(UIButton *)sender {
    [WYAVManager wy_pauseMusicWithName:@"1201111234.mp3"];
}

- (IBAction)stopMusic:(UIButton *)sender {
    [WYAVManager wy_stopMusicWithName:@"1201111234.mp3"];
}

@end
