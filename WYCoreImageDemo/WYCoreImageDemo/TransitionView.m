//
//  TransitionView.m
//  WYCoreImageDemo
//
//  Created by yunyao on 16/9/10.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "TransitionView.h"

@implementation TransitionView
{
    NSTimer *_timer;
    CIContext *_context;
    CIImage *_inputImage;
    CIImage *_transionImage;
    CIFilter *_transitionFilter;
    double _timeInterval;
    CIVector *_vetor;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 2.获取图片url
        NSURL *fileUrl1 =[[NSBundle mainBundle] URLForResource:@"1.jpg" withExtension:nil];
//        [NSURL fileURLWithPath:@"/Users/yunyao/Desktop/1.jpg"];
        NSURL *fileUrl2 = [[NSBundle mainBundle] URLForResource:@"1副本.jpg" withExtension:nil];
//                           [NSURL fileURLWithPath:@"/Users/yunyao/Desktop/1副本.jpg"]]
//        [[NSBundle mainBundle] pathForResource:@"1副本.jpg" ofType:nil];
//        [NSURL fileURLWithPath:@"/Users/yunyao/Desktop/1副本.jpg"];
        
        // 3.core image 的上下文
        _context = [CIContext contextWithOptions:nil];
        
        // 4.创建输入图片
        _inputImage = [CIImage imageWithContentsOfURL:fileUrl1];
        // 5.创建转场图片
        _transionImage = [CIImage imageWithContentsOfURL:fileUrl2];
        
        // 6.创建转场滤镜
        _transitionFilter  = [CIFilter filterWithName: @"CICopyMachineTransition"];
        NSLog(@"%@", _transitionFilter.attributes);
        // 设置
        [_transitionFilter setDefaults];
        // 矢量对象
        _vetor = [CIVector vectorWithX:0 Y:0 Z:frame.size.width W:frame.size.height];
        [_transitionFilter setValue:_vetor forKey:kCIInputExtentKey];
        
        // 7.定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(transition) userInfo:nil repeats:YES];
        
        // 记录参照时间
        _timeInterval = [NSDate timeIntervalSinceReferenceDate];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)transition {
    
    // 1.设置转场滤镜的进度 (10s为周期)
    CGFloat t = ([NSDate timeIntervalSinceReferenceDate] - _timeInterval)*0.1;
    NSLog(@"---%f", t);
    if (t >= 1.0) {
        [_timer invalidate];
        _timer = nil;
    }

    // 2.转场滤镜 获取混合图片
    [_transitionFilter setValue:_inputImage forKey:kCIInputImageKey];
    [_transitionFilter setValue:_transionImage forKey:kCIInputTargetImageKey];
    // 设置进度
    [_transitionFilter setValue:@(t) forKey:kCIInputTimeKey];
    CIImage *outImg = [_transitionFilter valueForKey:kCIOutputImageKey];
    
    // 3.裁剪滤镜 获取转场中的渲染图片
    CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop"];
//    NSLog(@"%@", cropFilter.attributes);
    [cropFilter setValue:outImg forKey:kCIInputImageKey];
    // 设置裁剪区
    [cropFilter setValue:_vetor forKey:@"inputRectangle"];
    // 获取结果
    CIImage *resultImg = [cropFilter valueForKey:kCIOutputImageKey];
    
    // 4.获取过程的图片渲染
    CGImageRef result = [_context createCGImage:resultImg fromRect:[resultImg extent]];
    if (result) {
        self.layer.contents = (__bridge id _Nullable)(result);
        CGImageRelease(result);
    }

 
}


@end
