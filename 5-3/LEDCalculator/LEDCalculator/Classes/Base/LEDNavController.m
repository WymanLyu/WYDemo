//
//  LEDNavController.m
//  LEDCalculator
//
//  Created by wyman on 2017/4/13.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "LEDNavController.h"

@interface LEDNavController ()

@end

@implementation LEDNavController

+ (void)initialize {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage wy_imageWithUIColor:[UIColor colorWithRed:47.0/255.0 green:49.0/255.0 blue:57.0/255.0 alpha:1] andFrame:CGRectMake(0, 0, kScreenWidth, 44)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
