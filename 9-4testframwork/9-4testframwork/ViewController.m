//
//  ViewController.m
//  9-4testframwork
//
//  Created by wyman on 2017/9/4.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import <FXAudio/AudioManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [AudioManager new];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
