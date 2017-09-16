//
//  ViewController7.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/14.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController7.h"
#import "ViewController3.h"
#import "SimpleNavgationBar.h"

@interface ViewController7 ()

@end

@implementation ViewController7

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController7";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn2 = [UIButton new];
    [btn2 setTitle:@"原生push到蓝色" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn2];
    
    btn2.frame = CGRectMake(100, 220, 155, 66);
    
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)click2 {
    ViewController3 *v = [ViewController3 new];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sn_openScreenPop];
    [self sn_navBarHidden:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self sn_navBarShow:animated];
    [self sn_reset];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
