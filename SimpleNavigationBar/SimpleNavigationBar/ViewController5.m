//
//  ViewController5.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/14.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController5.h"
#import "SimpleNavgationBar.h"

@interface ViewController5 ()

@end

@implementation ViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController5";
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sn_statusBarHidden = YES;
    self.sn_navBarBackgroundColor = [UIColor orangeColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self sn_reset];
}


@end
