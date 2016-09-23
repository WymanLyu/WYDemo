//
//  WYCoordinateView.m
//  WYBezierTool
//
//  Created by yunyao on 16/9/22.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "WYCoordinateView.h"
#import "WYDotView.h"

#define kMargin 25

@interface WYCoordinateView ()

/** 起始点控制坐标系 */
@property (assign) CGPoint beginPoint;

@end

@implementation WYCoordinateView
{
    // 坐标顶点
    CGPoint _pointUpL;
    CGPoint _pointUpR;
    CGPoint _pointBottomL;
    CGPoint _pointBottomR;
    
    // 控制点初始坐标
    CGPoint _controlPoint1;
    CGPoint _controlPoint2;
    
    // 起始点初始坐标
    CGPoint _startDotPoint;
    CGPoint _endDotPoint;
    
    // 坐标点
    WYDotView *_dotUpL;
    WYDotView *_dotUpR;
    WYDotView *_dotBottomL;
    WYDotView *_dotBottomR;

}

// 绑定属性的成员变量
@synthesize beginPoint = _beginPoint;
@synthesize bezierArrM = _bezierArrM;

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
        
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"bezierArrM"];
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
    self.beginPoint = _pointUpL;
    
    // 2.设置默认曲线
    if ([[self mutableArrayValueForKey:@"bezierArrM"] count]) {
        // 清空曲线模型
        [[self mutableArrayValueForKey:@"bezierArrM"] removeAllObjects];
    }
    // 设置默认曲线模型
    WYBezierLineModel *bezierLine0 = [[WYBezierLineModel alloc] init];
    [self bezierArrM];
    [[self mutableArrayValueForKey:@"bezierArrM"] addObject:bezierLine0];
   

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

#pragma mark - 私有方法

// 获取对角点
- (CGPoint)convertPointDiagonally:(CGPoint)point {
    
    if (CGPointEqualToPoint(point, _pointUpL)) {
        return  _pointBottomR;
    } else if (CGPointEqualToPoint(point, _pointUpR)) {
        return _pointBottomL;
    } else if (CGPointEqualToPoint(point, _pointBottomL)) {
        return _pointUpR;
    } else if (CGPointEqualToPoint(point, _pointBottomR)) {
        return _pointUpL;
    } else {
        return point;
    }
}

// 根据起始点获取控制点初始坐标
- (void)setControlPointWithWidth:(CGFloat)width height:(CGFloat)height {
    
    if (CGPointEqualToPoint(_beginPoint, _pointUpL)) {
        
        _controlPoint1 = CGPointMake(kMargin + width*(1.0/3.0), kMargin + height*(2.0/3.0));
        _controlPoint2 = CGPointMake(kMargin + width*(2.0/3.0), kMargin + height*(1.0/3.0));
        
    } else if (CGPointEqualToPoint(_beginPoint, _pointUpR)) {
        
        _controlPoint1 = CGPointMake(kMargin + width*(2.0/3.0), kMargin + height*(2.0/3.0));
        _controlPoint2 = CGPointMake(kMargin + width*(1.0/3.0), kMargin + height*(1.0/3.0));
        
    } else if (CGPointEqualToPoint(_beginPoint, _pointBottomL)) {
        
        _controlPoint1 = CGPointMake(kMargin + width*(1.0/3.0), kMargin + height*(1.0/3.0));
        _controlPoint2 = CGPointMake(kMargin + width*(2.0/3.0), kMargin + height*(2.0/3.0));
        
    } else if (CGPointEqualToPoint(_beginPoint, _pointBottomR)) {
        
        _controlPoint1 = CGPointMake(kMargin + width*(2.0/3.0), kMargin + height*(1.0/3.0));
        _controlPoint2 = CGPointMake(kMargin + width*(1.0/3.0), kMargin + height*(2.0/3.0));
        
    }
    
}


- (void)startAnimation {
    
}

#pragma mark - 属性方法

- (void)setBeginPoint:(CGPoint)beginPoint {
    _beginPoint = beginPoint;
    
    // 设置默认的始点和终点
    _startDotPoint = _beginPoint;
    _endDotPoint = [self convertPointDiagonally:_startDotPoint];
    
    // 设置默认控制点尺寸
    CGFloat width = fabs(_startDotPoint.x - _endDotPoint.x);
    CGFloat height = fabs(_startDotPoint.y - _endDotPoint.y);
    [self setControlPointWithWidth:width height:height];
    [self setNeedsDisplay:YES];
}

- (CGPoint)beginPoint {
    return _beginPoint;
}

static void *NSKeyValueObservingOptionNewContext = &NSKeyValueObservingOptionNewContext;

- (NSMutableArray *)bezierArrM {
    if (!_bezierArrM) {
        _bezierArrM = [NSMutableArray array];
        [self addObserver:self forKeyPath:@"bezierArrM" options:NSKeyValueObservingOptionNew context:NSKeyValueObservingOptionNewContext];
    }
    return _bezierArrM;
}

- (void)setBezierArrM:(NSMutableArray *)bezierArrM {
    _bezierArrM = bezierArrM;
}

#pragma mark - 监听数组的变化

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == NSKeyValueObservingOptionNewContext) {
        if ([keyPath isEqualToString:@"bezierArrM"]) {
            NSLog(@"%@", change);
            
            NSInteger kind = [[change objectForKey:@"kind"] integerValue];
            if (kind == NSKeyValueChangeInsertion) { // 判断是否是插入数据
                NSArray *newObjs = [change objectForKey:@"new"];
                if (newObjs.count) {
                    for (WYBezierLineModel *dotModel in newObjs) { // 遍历新数据
                        
                        // 1.设置其起始点和终点
                        NSLog(@"%@", dotModel);
                        dotModel.beginDotPoint = self.beginPoint;
                        dotModel.endDotPoint = [self convertPointDiagonally:self.beginPoint];
                        
                        // 2.添加相关联的视图
                        [self addSubview:dotModel.beginDot];
                        [self addSubview:dotModel.endDot];
                        [self addSubview:dotModel.controlDot1];
                        [self addSubview:dotModel.controlDot2];
                        CGRect beginDotF = dotModel.beginDot.frame;
                        CGFloat dotWidth = beginDotF.size.width;
                        dotModel.beginDot.frame = CGRectMake(_startDotPoint.x - dotWidth*0.5, _startDotPoint.y - dotWidth*0.5, dotWidth, dotWidth);
                        dotModel.endDot.frame = CGRectMake(_endDotPoint.x - dotWidth*0.5, _endDotPoint.y - dotWidth*0.5, dotWidth, dotWidth);
                        
                        CGRect controlDotF = dotModel.controlDot1.frame;
                        CGFloat controlDotWidth = controlDotF.size.width;
                        dotModel.controlDot1.frame = CGRectMake(_controlPoint1.x - controlDotWidth*0.5, _controlPoint1.y - controlDotWidth*0.5, controlDotWidth, controlDotWidth);
                        dotModel.controlDot2.frame = CGRectMake(_controlPoint2.x - controlDotWidth*0.5, _controlPoint2.y - controlDotWidth*0.5, controlDotWidth, controlDotWidth);
                    }
                }
            } else if (kind == NSKeyValueChangeRemoval) { // 判断是移除数据
                
                
            }
            
            // 设置重新绘制
            [self setNeedsDisplay:YES];
            
        }
    }
}

-(void)insertObject:(id)object inArrayAtIndex:(NSUInteger)index {
    
    [self.bezierArrM insertObject:object atIndex:index];
    
}

-(void)removeObjectFromArrayAtIndex:(NSUInteger)index {
    
    [self.bezierArrM removeObjectAtIndex:index];
    
}


@end















