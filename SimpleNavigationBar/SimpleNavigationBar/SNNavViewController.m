//
//  SNNavViewController.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "SNNavViewController.h"
#import "SNNavTransition.h"
#import "SimpleNavgationBar.h"
#import <objc/runtime.h>

@interface SNNavViewController ()

@property (nonatomic, strong) SNNavTransition *navTransition;

@end

@implementation SNNavViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
//    NSLog(@"%@", self.interactivePopGestureRecognizer);
//    
//    [self.interactivePopGestureRecognizer addTarget:self action:@selector(sn_updateInteractiveTransition:)]; // 增加系统手势方法
//    [self.interactivePopGestureRecognizer addTarget:self action:@selector(sn_updateInteractiveTransition:)]; // 增加系统手势方法
//    [self.interactivePopGestureRecognizer addTarget:self action:@selector(sn_updateInteractiveTransition:)]; // 增加系统手势方法
//    NSLog(@"%@", self.interactivePopGestureRecognizer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}

@end
