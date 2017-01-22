//
//  ViewController.m
//  12-13DefaultProtocol
//
//  Created by wyman on 2016/12/13.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "ViewController.h"
#import "YSDefaultImp.h"

@interface ViewController ()<YSDefaultImp>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self call];
}


@end
