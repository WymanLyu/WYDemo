//
//  ViewController.m
//  WYCoreLocationDemo
//
//  Created by sialice on 16/5/29.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "WYLocationManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *locationTextView;


@end

@implementation ViewController

#pragma mark - 懒加载

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)currentBtnClick:(id)sender {
    [[WYLocationManager shareManager] getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        if (error) {
            NSLog(error);
        }else {
            self.locationTextView.text = placeMark.name;
        }
    }];
}





















@end







































