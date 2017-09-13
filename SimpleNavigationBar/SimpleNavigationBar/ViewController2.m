//
//  ViewController2.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController2.h"
#import "SimpleNavgationBar.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController2";
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FuncLog
    self.sn_navBarAlpha = 0.0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    FuncLog
    [self sn_reset];
}


@end
