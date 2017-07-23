//
//  ViewController.m
//  UseLib
//
//  Created by wyman on 2017/7/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import <PrivateLib/LibTest.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[LibTest new] lib_print];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
