//
//  ViewController1.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController1.h"
#import "SimpleNavgationBar.h"
#import <objc/runtime.h>

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController1";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//     class_addMethod([self class], @selector(sn_handleGesture), (IMP)sn_handleGesture, "v");
//    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sn_handleGesture)];
//    [pan addTarget:self action:@selector(pan2:)];
//    [self.view addGestureRecognizer:pan];
}

//void sn_handleGesture() {
//    NSLog(@"----");
//}

//- (void)pan:(UIPanGestureRecognizer *)pan {
//    NSLog(@"---------");
//}
//
//- (void)pan2:(UIPanGestureRecognizer *)pan {
//    NSLog(@"=============");
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FuncLog
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    FuncLog
}

@end
