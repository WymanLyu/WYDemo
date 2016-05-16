//
//  CTDisplayView.m
//  WYCoreTextDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "CTDisplayView.h"

@implementation CTDisplayView

- (void)drawRect:(CGRect)rect
{
//    [super drawRect:rect];
    // 1.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2.设置坐标反转
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 3.绘制文本
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
}

@end
