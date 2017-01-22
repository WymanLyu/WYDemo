//
//  ViewController.m
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "ViewController.h"
#import "View0.h"
#import "TestController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    View0 *view =[[View0 alloc] initWithFrame:CGRectMake(120, 220, 262, 492)];
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(30, 30, 34, 44);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(sss) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)sss {
//    []
    TestController *vc = [TestController new];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
