//
//  SoundViewController.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/14.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "SoundViewController.h"
#import "WYAVManager.h"

@implementation SoundViewController

- (IBAction)playSound:(UIButton *)sender {
    [WYAVManager wy_playSoundsWithName:@"lose.aac"];
}

@end
