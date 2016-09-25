//
//  WYDotView.m
//  WYBezierTool
//
//  Created by yunyao on 16/9/23.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "WYDotView.h"

NSString *const kDotViewMouseDownNotification = @"DotViewMouseDownNotification";
NSString *const kDotViewMouseUpNotification = @"DotViewMouseUpNotification";
NSString *const kDotViewMouseMoveNotification = @"DotViewMouseMoveNotification";


@implementation WYDotView

- (id)initWithFrame:(NSRect)frameRect {

    if (self = [super initWithFrame:frameRect]) {
        [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:YES];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGFloat w = dirtyRect.size.width <= dirtyRect.size.height ? dirtyRect.size.width : dirtyRect.size.height;
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    CGContextAddEllipseInRect(ctx.CGContext, CGRectMake(0, 0, w, w));
    [self.backgroundColor set];
    CGContextFillPath(ctx.CGContext);
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.borderColor = [NSColor yellowColor].CGColor;
    _isDragged = YES;
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kDotViewMouseDownNotification object:self userInfo:nil];
}

- (void)mouseDragged:(NSEvent *)theEvent {

        // 1.获取点
        NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        
        // 2.包装参数
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        dictM[@"mousePointInTouchView"] = [NSValue valueWithPoint:point];
        
        // 3.发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kDotViewMouseMoveNotification object:self userInfo:dictM];

}

- (void)mouseUp:(NSEvent *)theEvent {
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.borderColor = [NSColor clearColor].CGColor;
    _isDragged = NO;

    // 发送通知
    if (self.noDrag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDotViewMouseUpNotification object:self userInfo:nil];
    }
}



@end
