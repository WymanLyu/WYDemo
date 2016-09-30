//
//  WYBezierLineModel.m
//  WYBezierTool
//
//  Created by yunyao on 16/9/23.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "WYBezierLineModel.h"

@implementation WYBezierLineModel

- (instancetype)init {
    if (self = [super init]) {
        
        // 1.初始化坐标
        self.beginDotPoint = CGPointZero;
        self.endDotPoint = CGPointZero;
        self.controlPoint1 = CGPointZero;
        self.controlPoint2 = CGPointZero;
        
        // 2.初始化视图
        CGFloat dotW = 7;
        self.beginDot = [[WYDotView alloc] initWithFrame:CGRectMake(0, 0, dotW, dotW)];
        self.endDot = [[WYDotView alloc] initWithFrame:CGRectMake(0, 0, dotW, dotW)];
        CGFloat controlDotW = 10;
        self.controlDot1 = [[WYDotView alloc] initWithFrame:CGRectMake(0, 0, controlDotW, controlDotW)];
        self.controlDot2 = [[WYDotView alloc] initWithFrame:CGRectMake(0, 0, controlDotW, controlDotW)];
        self.controlDot1.backgroundColor = [NSColor blueColor];
        self.controlDot2.backgroundColor = [NSColor blueColor];
        
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    self.beginDot.index = _index;
    self.endDot.index = _index;
    self.controlDot1.index = _index;
    self.controlDot2.index = _index;
    
}

@end
