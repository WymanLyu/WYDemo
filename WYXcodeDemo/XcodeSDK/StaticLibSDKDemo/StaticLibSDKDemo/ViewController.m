//
//  ViewController.m
//  StaticLibSDKDemo
//
//  Created by wyman on 2017/7/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
//#import <StaticLib.h>
//#import "StaticLib/StaticLib.h"
# import <FrameworkLib/FrameworkLib.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [[StaticLib new] lib_log];
    [[FrameworkLib new] print_x86];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
