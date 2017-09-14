//
//  ViewController6.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/14.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController6.h"
#import "SimpleNavgationBar.h"
#import "ViewController3.h"

@interface ViewController6 ()

@property (nonatomic, strong) UIView *bar;

@end

@implementation ViewController6

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController6";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn2 = [UIButton new];
    [btn2 setTitle:@"原生push到蓝色" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn2];
    
    btn2.frame = CGRectMake(100, 220, 155, 66);
    
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor greenColor];
    [v addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    self.bar = v;
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    l.backgroundColor = [UIColor yellowColor];
    l.text = @"这是个自定义的bar...";
    [self.bar addSubview:l];
    
}

- (void)click2 {
    ViewController3 *v = [ViewController3 new];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FuncLog
    self.sn_translationY = 55;
    self.sn_customBar = self.bar;
    self.sn_smoothTransitionToCustomBar = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    FuncLog
    [self sn_reset];
}

@end

