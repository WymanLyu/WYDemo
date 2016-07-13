//
//  ViewController.m
//  WYPushDemo
//
//  Created by yunyao on 16/7/12.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 发送本地通知
- (IBAction)sendLocalNoti {
    // 1.创建通知
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    
    // 2.设置内容
    localNoti.alertBody = @"这是一个本地通知";
    
    // 2.1.绑定操作
    localNoti.category = @"categoryID";
    localNoti.hasAction = NO; // 控制alertAction文字显不显示
    localNoti.alertAction = @"这是啥子"; // 提示内容下面滑条文字
    localNoti.alertTitle = @"zzzz"; // 在通知栏中显示的名字
    
    // 3.设置发送时间
    localNoti.fireDate = [NSDate dateWithTimeIntervalSinceNow:4];
    
    // 4.发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
