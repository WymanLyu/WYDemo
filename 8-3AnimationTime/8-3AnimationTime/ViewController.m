//
//  ViewController.m
//  8-3AnimationTime
//
//  Created by wyman on 2017/8/3.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CALayer *superLayer;

@property (nonatomic, strong) CALayer *redLayer;

@property (nonatomic, strong) CALayer *blueLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%@", BASE_URL);
    
    
    NSLog(@"CACurrentMediaTime : %f", CACurrentMediaTime());
    
    self.superLayer = [CALayer layer];
    self.superLayer.position = CGPointMake(8, 30);
    self.superLayer.anchorPoint = CGPointMake(0, 0);
    self.superLayer.bounds = CGRectMake(0, 0, 400, 400);
    self.superLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.view.layer addSublayer:self.superLayer];
    
    self.redLayer = [CALayer layer];
    self.redLayer.position = CGPointMake(50, 50);
    self.redLayer.anchorPoint = CGPointMake(0, 0);
    self.redLayer.bounds = CGRectMake(0, 0, 100, 100);
    self.redLayer.backgroundColor = [UIColor redColor].CGColor;
    self.redLayer.beginTime = CACurrentMediaTime()+3.0;
    [self.view.layer addSublayer:self.redLayer];
    
    
    self.blueLayer = [CALayer layer];
    self.blueLayer.position = CGPointMake(50, 250);
    self.blueLayer.anchorPoint = CGPointMake(0, 0);
    self.blueLayer.bounds = CGRectMake(0, 0, 100, 100);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:self.blueLayer];
    
    NSLog(@"redLayer.beginTime:%f === blueLayer.beginTime:%f", self.redLayer.beginTime, self.blueLayer.beginTime);

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    NSLog(@"  ");
    NSLog(@"CACurrentMediaTime : %f", CACurrentMediaTime());
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
//    [CATransaction setDisableActions:YES];
    
    self.redLayer.position = CGPointMake(150, 50);
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"position.x"];
    fade.fromValue = @(50);
    fade.toValue = @(150);
    fade.duration = 3.0;
    [self.redLayer addAnimation:fade forKey:@"fade"];
    
    
    [CATransaction commit];
    
    NSLog(@"fade.beginTime : %f", fade.beginTime);
    
    
}





@end
