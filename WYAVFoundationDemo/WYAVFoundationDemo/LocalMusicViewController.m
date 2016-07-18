//
//  LocalMusicViewController.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/15.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "LocalMusicViewController.h"
#import "WYAVTool.h"

@implementation LocalMusicViewController

- (IBAction)playeMusci:(UIButton *)sender {
    [WYAVTool wy_playMusicWithName:@"1201111234.mp3"];
}

- (IBAction)pauseMusic:(UIButton *)sender {
    [WYAVTool wy_pauseMusicWithName:@"1201111234.mp3"];
}

- (IBAction)stopMusic:(UIButton *)sender {
    [WYAVTool wy_stopMusicWithName:@"1201111234.mp3"];
}

@end
