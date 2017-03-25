//
//  ViewController.m
//  3-10设计要看button
//
//  Created by wyman on 2017/3/10.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *hahah;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.hahah.layer.borderColor = [UIColor redColor].CGColor;
    self.hahah.layer.borderWidth = 5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
