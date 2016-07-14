//
//  ViewController.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/14.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "ViewController.h"
#import "WYAVTool.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - 事件处理
// 录音
- (IBAction)recorder:(id)sender {
    [WYAVTool wy_recorderStart];
}

// 暂停开始
- (IBAction)stopOrStar:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) { // 选中(暂停状态)
        [WYAVTool wy_recorderPause];
    }else { // 未选中(播放状态)
        [WYAVTool wy_recorderStart];
    }
}

// 结束
- (IBAction)end:(id)sender {
    [WYAVTool wy_recorderEnd];
}

// 播放
- (IBAction)play:(id)sender {
    
}



@end
