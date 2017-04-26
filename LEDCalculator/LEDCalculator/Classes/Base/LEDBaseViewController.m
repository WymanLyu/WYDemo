//
//  LEDBaseViewController.m
//  LEDCalculator
//
//  Created by wyman on 2017/4/13.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "LEDBaseViewController.h"

@interface LEDBaseViewController ()

@end

@implementation LEDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"xxx";
    self.navigationItem.titleView = [UILabel new];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
