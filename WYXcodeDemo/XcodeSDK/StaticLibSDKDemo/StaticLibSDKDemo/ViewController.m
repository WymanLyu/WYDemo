//
//  ViewController.m
//  StaticLibSDKDemo
//
//  Created by wyman on 2017/7/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import <StaticLib.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[StaticLib new] lib_log];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
