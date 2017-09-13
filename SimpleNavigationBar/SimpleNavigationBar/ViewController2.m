//
//  ViewController2.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController2.h"
#import "SimpleNavgationBar.h"
#import "ViewController3.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController2";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn2 = [UIButton new];
    [btn2 setTitle:@"原生push到蓝色" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn2];

    btn2.frame = CGRectMake(100, 220, 155, 66);
}

- (void)click2 {
    ViewController3 *v = [ViewController3 new];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FuncLog
    self.sn_navBarAlpha = 0.0;
//    self.sn_translationY = 33.2;
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    FuncLog
    [self sn_reset];
}




@end
