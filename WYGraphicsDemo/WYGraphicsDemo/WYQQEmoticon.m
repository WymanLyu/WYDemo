//
//  WYQQEmoticon.m
//  WYGraphicsDemo
//
//  Created by yunyao on 16/9/21.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "WYQQEmoticon.h"

@implementation WYQQEmoticon

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    drawSmile(rect);
    
}

void drawSmile(CGRect rect)
{
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.拷贝入栈
    CGContextSaveGState(ctx);
    
    // 3.添加脸部背景
    CGFloat radius = rect.size.width * 0.5;
    CGContextAddArc(ctx, radius, radius, radius-0.5, 0, M_PI * 2, NO);
    CGContextSetRGBFillColor(ctx, 254.0 / 255.0, 217.0 / 255.0, 78.8 / 255.0, 1);
    CGContextFillPath(ctx);
    
    // 4.绘制左眉毛
    CGContextRestoreGState(ctx);
    CGContextTranslateCTM(ctx, -20, 0);
    CGFloat margin = 25;
    CGPoint controlPoint = CGPointMake(radius - margin - 10, margin-10);
    CGContextMoveToPoint(ctx, controlPoint.x + margin, controlPoint.y + margin*1.5);
    CGContextAddQuadCurveToPoint(ctx, controlPoint.x, controlPoint.y, controlPoint.x - margin*1.2, controlPoint.y + margin);
    CGContextAddQuadCurveToPoint(ctx, controlPoint.x - 10, controlPoint.y + 10, controlPoint.x + margin, controlPoint.y + margin*1.5);
    // 拷贝左眉毛入栈
    CGContextSaveGState(ctx);
    CGContextFillPath(ctx);
    
    // 5.旋转上下文绘制右侧眉毛
    // 1.平移坐标
    CGContextTranslateCTM(ctx, rect.size.width+40, 0);
    // 2.翻转x轴
    CGContextScaleCTM(ctx, -1.0, 1.0);
    CGContextMoveToPoint(ctx, controlPoint.x + margin, controlPoint.y + margin*1.5);
    CGContextAddQuadCurveToPoint(ctx, controlPoint.x, controlPoint.y, controlPoint.x - margin*1.2, controlPoint.y + margin);
    CGContextAddQuadCurveToPoint(ctx, controlPoint.x - 10, controlPoint.y + 10, controlPoint.x + margin, controlPoint.y + margin*1.5);
    CGContextFillPath(ctx);
    
    // 6.绘制眼睛
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    CGPoint controlPoint2 = CGPointMake((radius - 40)*0.5, -margin*2.5);
    CGMutablePathRef eyesPath = CGPathCreateMutable();
    CGPathMoveToPoint(eyesPath, NULL, 30, 80);
    CGPathAddCurveToPoint(eyesPath, NULL, controlPoint2.x, controlPoint2.y, controlPoint2.x + (radius - 40)*0.5, controlPoint2.y, radius - 10, 80);
    CGContextAddPath(ctx, eyesPath);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 25);
//    [[UIColor redColor] set];
    CGContextStrokePath(ctx);
    CGPathRelease(eyesPath);
    
    
    
//    CGPoint controlPoint2 = CGPointMake((radius - 40)*0.5, margin*2.5);
//    CGContextMoveToPoint(ctx, 30, 80);
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    CGContextSetLineWidth(ctx, 25);
//    [[UIColor whiteColor] set];
//    CGContextAddCurveToPoint(ctx, controlPoint2.x, controlPoint2.y, controlPoint2.x + (radius - 40)*0.5, controlPoint2.y, radius - 10, 80);
//    CGContextStrokePath(ctx);
//
//    CGContextRestoreGState(ctx);
//    CGContextSaveGState(ctx);
//    CGContextTranslateCTM(ctx, 0, -12);
//    [[UIColor orangeColor] set];
//    CGContextMoveToPoint(ctx, 30, 80);
//    CGContextAddCurveToPoint(ctx, controlPoint2.x, controlPoint2.y, controlPoint2.x + (radius - 40)*0.5, controlPoint2.y, radius - 10, 80);
//    CGContextStrokePath(ctx);
    
//    CGPoint controlPoint22 = CGPointMake((radius - 40)*0.5, margin*2.5 + 20);
//    CGContextAddCurveToPoint(ctx, controlPoint22.x, controlPoint22.y, controlPoint22.x + (radius - 40)*0.5, controlPoint22.y, 30, 80);
    
//    CGContextAddQuadCurveToPoint(ctx, controlPoint2.x, controlPoint2.y, radius - 10, 80);
    
    
    
}




@end
