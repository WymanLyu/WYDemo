//
//  WYCoordinateView.m
//  WYBezierTool
//
//  Created by yunyao on 16/9/22.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "WYCoordinateView.h"

#define kMargin 25

@interface WYCoordinateView ()

@property (assign) CGPoint beginPoint;

@end

@implementation WYCoordinateView
{
    // 坐标
    CGPoint _pointUpL;
    CGPoint _pointUpR;
    CGPoint _pointBottomL;
    CGPoint _pointBottomR;
    
    // 坐标点
    WYDotView *_dotUpL;
    WYDotView *_dotUpR;
    WYDotView *_dotBottomL;
    WYDotView *_dotBottomR;
    
    // 起始点
    WYDotView *_beginDot;
    WYDotView *_endDot;
    
    // 控制点
    WYDotView *_controlDot1;
    WYDotView *_controlDot2;
    
    
    CGPoint _beginPoint;
}

@synthesize beginPoint = _beginPoint;

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        
        // 四个坐标点
        _dotUpL = [[WYDotView alloc] init];
        _dotUpR = [[WYDotView alloc] init];
        _dotBottomL = [[WYDotView alloc] init];
        _dotBottomR = [[WYDotView alloc] init];
        [self addSubview:_dotUpL];
        [self addSubview:_dotUpR];
        [self addSubview:_dotBottomL];
        [self addSubview:_dotBottomR];
        _dotUpL.backgroundColor = [NSColor orangeColor];
        _dotUpR.backgroundColor = [NSColor orangeColor];
        _dotBottomL.backgroundColor = [NSColor orangeColor];
        _dotBottomR.backgroundColor = [NSColor orangeColor];
        
        // 起始点
        _beginDot = [[WYDotView alloc] init];
        _endDot = [[WYDotView alloc] init];
        [self addSubview:_beginDot];
        [self addSubview:_endDot];
        
        // 控制点
        _controlDot1 = [[WYDotView alloc] init];
        _controlDot2 = [[WYDotView alloc] init];
        _controlDot1.backgroundColor = [NSColor greenColor];
        _controlDot2.backgroundColor = [NSColor greenColor];
        [self addSubview:_controlDot1];
        [self addSubview:_controlDot2];

        
        
    }
    return self;
}

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    
    // 0. 记录四顶点
    _pointUpL = CGPointMake(kMargin, frame.size.height - kMargin);
    _pointUpR = CGPointMake(frame.size.width - kMargin, frame.size.height - kMargin);
    _pointBottomL = CGPointMake(kMargin, kMargin);
    _pointBottomR = CGPointMake(frame.size.width - kMargin, kMargin);
    
    // 1. 设置子控件尺寸
    CGFloat dotW = 10;
    _dotUpL.frame = CGRectMake(_pointUpL.x - dotW*0.5, _pointUpL.y - dotW*0.5, dotW, dotW);
    _dotUpR.frame = CGRectMake(_pointUpR.x - dotW*0.5, _pointUpR.y - dotW*0.5, dotW, dotW);
    _dotBottomL.frame = CGRectMake(_pointBottomL.x - dotW*0.5, _pointBottomL.y - dotW*0.5, dotW, dotW);
    _dotBottomR.frame = CGRectMake(_pointBottomR.x - dotW*0.5, _pointBottomR.y - dotW*0.5, dotW, dotW);
    
    self.beginPoint = _pointBottomR;

}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // 1.绘制坐标系
    // 设置起始点
//    CGPoint beginPoint = _pointUpL;
    
    // 1.0. 获取上下文
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];
    // 1.1. x轴
    CGContextMoveToPoint(ctx.CGContext, self.beginPoint.x, self.beginPoint.y);
    CGContextAddLineToPoint(ctx.CGContext, dirtyRect.size.width - self.beginPoint.x, self.beginPoint.y);
    // 1.2. y轴
    CGContextMoveToPoint(ctx.CGContext, self.beginPoint.x, self.beginPoint.y);
    CGContextAddLineToPoint(ctx.CGContext, self.beginPoint.x, dirtyRect.size.height - self.beginPoint.y );
    
    CGContextSetLineWidth(ctx.CGContext, 2);
    [[NSColor grayColor] set];
    CGContextStrokePath(ctx.CGContext);
    
}

- (void)setBeginPoint:(CGPoint)beginPoint {
    _beginPoint = beginPoint;
    
    // 设置始点和终点
    CGFloat dotW = 7;
    _beginDot.frame = CGRectMake(_beginPoint.x - dotW*0.5, _beginPoint.y - dotW*0.5, dotW, dotW);
    CGPoint endPoint = CGPointZero;
    if (CGPointEqualToPoint(_beginPoint, _pointUpL)) {
        endPoint = _pointBottomR;
    } else if (CGPointEqualToPoint(_beginPoint, _pointUpR)) {
        endPoint = _pointBottomL;
    } else if (CGPointEqualToPoint(_beginPoint, _pointBottomL)) {
        endPoint = _pointUpR;
    } else if (CGPointEqualToPoint(_beginPoint, _pointBottomR)) {
        endPoint = _pointUpL;
    } else {
        
    }
    _endDot.frame = CGRectMake(endPoint.x- dotW*0.5, endPoint.y - dotW*0.5, dotW, dotW);
    
    // 设置控制点
    CGFloat controlDotW = 13;
    
    [self setNeedsDisplay:YES];
}

- (CGPoint)beginPoint {
    return _beginPoint;
}

- (void)startAnimation {
    
    // 2.开启动画
//    CALayer *mask = [CALayer layer];
//    mask.frame = _dotUpL.bounds;
//    mask.cornerRadius = mask.frame.size.width * 0.5;
//    mask.backgroundColor = [NSColor blackColor].CGColor;
//    _dotUpL.layer.mask = mask;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _dotUpL.bounds;
    gradientLayer.cornerRadius = gradientLayer.frame.size.width * 0.5;
    gradientLayer.colors = @[[NSColor blueColor], [NSColor grayColor]];
    gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [_dotUpL.layer addSublayer:gradientLayer];
    
//    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
//    baseAnimation.keyPath = @"transform.scale";
//    baseAnimation.fromValue = @(0.5);
//    baseAnimation.toValue = @(1);
//    baseAnimation.duration = 3.25;
//    baseAnimation.repeatCount = MAXFLOAT;
////    baseAnimation.autoreverses = YES;
//    baseAnimation.timingFunction =  [CAMediaTimingFunction functionWithControlPoints: 0.000000 : 0.650000 : 0.330000 : 0.186667];
//    [_dotUpL.layer addAnimation:baseAnimation forKey:nil];
    
}

@end


@implementation WYDotView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGFloat w = dirtyRect.size.width <= dirtyRect.size.height ? dirtyRect.size.width : dirtyRect.size.height;
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    CGContextAddEllipseInRect(ctx.CGContext, CGRectMake(0, 0, w, w));
    [self.backgroundColor set];
    CGContextFillPath(ctx.CGContext);
    
}

@end













