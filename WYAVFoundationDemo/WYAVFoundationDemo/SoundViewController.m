//
//  SoundViewController.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/14.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "SoundViewController.h"
#import "WYAVTool.h"

@implementation SoundViewController

- (IBAction)playSound:(UIButton *)sender {
    [WYAVTool wy_playSoundsWithName:@"lose.aac"];
}

@end
