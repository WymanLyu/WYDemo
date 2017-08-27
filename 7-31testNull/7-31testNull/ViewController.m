//
//  ViewController.m
//  7-31testNull
//
//  Created by wyman on 2017/7/31.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import <WYNullView/WYNullView.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view wy_nullViewAddTarget:self.view action:@selector(wy_hideNullView)];
}

- (IBAction)showNullView:(UISwitch *)sender {
    sender.isOn ? [self.view wy_showNullView] : [self.view wy_hideNullView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
