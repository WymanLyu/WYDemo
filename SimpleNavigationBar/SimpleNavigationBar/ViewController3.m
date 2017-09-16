//
//  ViewController3.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController3.h"
#import "SimpleNavgationBar.h"
#import "ViewController1.h"

@interface ViewController3 ()

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController3";
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FuncLog
    self.sn_navBarBackgroundColor = [UIColor blueColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    FuncLog
    [self sn_reset];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ViewController1 *v = [ViewController1 new];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:n animated:YES completion:nil];
}


@end
