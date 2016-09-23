//
//  WYDotView.m
//  WYBezierTool
//
//  Created by yunyao on 16/9/23.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "WYDotView.h"


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
