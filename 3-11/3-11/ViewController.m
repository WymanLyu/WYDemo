//
//  ViewController.m
//  3-11
//
//  Created by wyman on 2017/3/11.
//  Copyright © 2017年 wymanDrawmage. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
   
    UIImage *img = [UIImage imageNamed:@"20170310052420_100000003_936c4e051be29a236900437a0c0088c5"];
    
    CGSize ctxSize = CGSizeMake(3480, 3480);
    NSLog(@"----%@", NSStringFromCGSize(ctxSize));
    // 开启图片上下文
    //    UIGraphicsBeginImageContext(ctxSize);
    UIGraphicsBeginImageContextWithOptions(ctxSize, NO, 0);
    CGContextRef ctx = nil;
    @try {
        ctx = UIGraphicsGetCurrentContext();
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
        
    }
    
    
    // 设置裁剪区域
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 3480, 3480));
    CGContextClip(ctx);
    // 上下文绘制图片
    [img drawAtPoint:CGPointZero];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();


}


@end
