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

NSString *const kDotViewCoordinateNotification = @"kDotViewCoordinateNotification";

@interface WYCoordinateView ()

/** 起始点控制坐标系 */
@property (assign) CGPoint beginPoint;

/** 结果方程信息 */
@property (strong) NSMutableArray *equationArrM;

/** 最后一个模型 */
@property (strong) WYBezierLineModel *lastModel;

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
        _dotUpL.noDrag = YES;
        _dotUpR.noDrag = YES;
        _dotBottomL.noDrag = YES;
        _dotBottomR.noDrag = YES;
        [self addSubview:_dotUpL];
        [self addSubview:_dotUpR];
        [self addSubview:_dotBottomL];
        [self addSubview:_dotBottomR];
        _dotUpL.backgroundColor = [NSColor orangeColor];
        _dotUpR.backgroundColor = [NSColor orangeColor];
        _dotBottomL.backgroundColor = [NSColor orangeColor];
        _dotBottomR.backgroundColor = [NSColor orangeColor];
        
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mouseMoveNoti:) name:kDotViewMouseMoveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mouseUpNoti:) name:kDotViewMouseUpNotification object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"bezierArrM"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
  
    [self bezierArrM];

}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // 1.绘制坐标系
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
    
    // 2.绘制贝塞尔曲线
    if (!self.bezierArrM.count) return;
    for (WYBezierLineModel *model in self.bezierArrM) {
        // 出栈
        [ctx restoreGraphicsState];
        // 入栈
        [ctx saveGraphicsState];

        // 绘制控制线
        CGContextMoveToPoint(ctx.CGContext, model.beginDotPoint.x, model.beginDotPoint.y);
        CGContextAddLineToPoint(ctx.CGContext, model.controlPoint1.x, model.controlPoint1.y);
        CGContextMoveToPoint(ctx.CGContext, model.endDotPoint.x, model.endDotPoint.y);
        CGContextAddLineToPoint(ctx.CGContext, model.controlPoint2.x, model.controlPoint2.y);
        CGContextSetLineWidth(ctx.CGContext, 1.5);
        CGContextStrokePath(ctx.CGContext);
        
        // 创建贝塞尔曲线
        // 出栈
        [ctx restoreGraphicsState];
        // 入栈
        [ctx saveGraphicsState];
        CGContextMoveToPoint(ctx.CGContext, model.beginDotPoint.x, model.beginDotPoint.y);
        CGContextAddCurveToPoint(ctx.CGContext, model.controlPoint1.x, model.controlPoint1.y, model.controlPoint2.x, model.controlPoint2.y, model.endDotPoint.x, model.endDotPoint.y);
        CGContextSetLineWidth(ctx.CGContext, 3);
        [[NSColor blueColor] set];
        
        CGContextStrokePath(ctx.CGContext);
        
    }
    
}

#pragma mark - 通知处理

- (void)mouseMoveNoti:(NSNotification *)noti {
    
    NSPoint draggedCenter = [[noti.userInfo objectForKey:@"mousePointInTouchView"] pointValue];
    WYDotView *draggedView = noti.object;
    
    if ([draggedView noDrag]) return; // 坐标顶点
    if ([draggedView isDragged]) { // 是否被拖拽的视图
    
        if ([self.subviews containsObject:draggedView]) { // 在视图中
    
            // 1.转换坐标至本视图
            CGFloat width = draggedView.frame.size.width;
            NSPoint center = [self convertPoint:draggedCenter fromView:draggedView];
            
            // 2.修改模型数据
            WYBezierLineModel *model = [self.bezierArrM objectAtIndex:draggedView.index];
            if (draggedView == model.beginDot) { // 开始点
                
                model.beginDotPoint = CGPointMake(center.x , center.y );
                
            } else if (draggedView == model.endDot) { // 结束点
                
                model.endDotPoint = CGPointMake(center.x, center.y);
                
            } else if (draggedView == model.controlDot1) { // 控制点1
                
                model.controlPoint1 = CGPointMake(center.x, center.y);
                
            } else if (draggedView == model.controlDot2) { // 控制点2
                
                model.controlPoint2 = CGPointMake(center.x, center.y);
            }
            
            // 3.处理越界情况
    
            // 4.移动视图
            [draggedView setFrameOrigin:CGPointMake(center.x- width*0.5, center.y- width*0.5)];
            
            // 5.移动关联视图
            
            // 6.重绘贝塞尔
            [self setNeedsDisplay:YES];
            
            // 7.更新结果方程
            [self getResultEquationWithDotView:draggedView];
            
            // 8.发送通知
            [self sendNoti];
        }
    
    }
   
}

- (void)mouseUpNoti:(NSNotification *)noti {
    
    WYDotView *dotView = noti.object;
    CGPoint center = CGPointMake(dotView.frame.size.width*0.5 + dotView.frame.origin.x, dotView.frame.size.width*0.5 + dotView.frame.origin.y);
    self.beginPoint = center;
    
}

#pragma mark - 发出结果通知

- (void)sendNoti {
    
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    infoDict[@"BezierEquation"] = self.equationArrM;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDotViewCoordinateNotification object:self userInfo:infoDict];
}

#pragma mark - 计算结果方程

- (void)getResultEquationWithDotView:(WYDotView *)dotView {
    
    if (!self.equationArrM) { // 懒加载
        self.equationArrM = [NSMutableArray array];
    }
    
    // 0.获取原有信息
    @try {
        [self.equationArrM objectAtIndex:dotView.index];
    }
    @catch (NSException *exception) {
        NSString *info  = @"";
        [self.equationArrM insertObject:info atIndex:dotView.index];
    }
    NSString *info = [self.equationArrM objectAtIndex:dotView.index];
    
    // 1.根据索引获取对应的贝塞尔模型
    WYBezierLineModel *model = [self.bezierArrM objectAtIndex:dotView.index];
    CGPoint beginP = model.beginDotPoint;
    CGPoint endP = model.endDotPoint;
    CGPoint controlP1 = model.controlPoint1;
    CGPoint controlP2 = model.controlPoint2;
    
    CGFloat width = self.frame.size.width - 2*kMargin;
    CGFloat height = self.frame.size.height - 2*kMargin;

    // 2.针对所有点进行坐标转换
    if (CGPointEqualToPoint(self.beginPoint, _pointUpL)) { // 左上坐标系
        
        beginP = CGPointMake((beginP.x - kMargin)/width, (self.frame.size.height - beginP.y - kMargin)/height);
        endP = CGPointMake((endP.x - kMargin)/width, (self.frame.size.height - endP.y - kMargin)/height);
        controlP1 = CGPointMake((controlP1.x - kMargin)/width, (self.frame.size.height - controlP1.y - kMargin)/height);
        controlP2 = CGPointMake((controlP2.x - kMargin)/width, (self.frame.size.height - controlP2.y - kMargin)/height);
        
    } else if (CGPointEqualToPoint(self.beginPoint, _pointUpR)) { // 右上坐标系
        
        
    } else if (CGPointEqualToPoint(self.beginPoint, _pointBottomL)) { // 左下坐标系
        
        beginP = CGPointMake((beginP.x - kMargin)/width, (beginP.y - kMargin)/height);
        endP = CGPointMake((endP.x - kMargin)/width, (endP.y - kMargin)/height);
        controlP1 = CGPointMake((controlP1.x - kMargin)/width, (controlP1.y - kMargin)/height);
        controlP2 = CGPointMake((controlP2.x - kMargin)/width, (controlP2.y - kMargin)/height);
        
    } else if (CGPointEqualToPoint(self.beginPoint, _pointBottomR)) { // 左右坐标系
        
        
    } else {
        
        
    }

    // 3.更新信息
    info = [NSString stringWithFormat:@"UIBezierPath *path%zd = [UIBezierPath bezierPath];\n[path%zd moveToPoint:CGPointMake(%.2f, %.2f)];\n[path%zd addCurveToPoint:CGPointMake(%.2f, %.2f) controlPoint1: CGPointMake(%.2f, %.2f) controlPoint2: CGPointMake(%.2f, %.2f)];",dotView.index, dotView.index, beginP.x, beginP.y, dotView.index, endP.x, endP.y, controlP1.x, controlP1.y, controlP2.x, controlP2.y];
    
    [self.equationArrM replaceObjectAtIndex:dotView.index withObject:info];
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
    [self displayIfNeeded];
    // 设置新的结果
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.bezierArrM.count) {
            for (WYBezierLineModel *model in self.bezierArrM) {
                
                // 更新方程坐标系
                [self getResultEquationWithDotView:model.beginDot];
            }
            [self sendNoti];
        }

//    });

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
//            NSLog(@"%@", change);
            
            NSInteger kind = [[change objectForKey:@"kind"] integerValue];
            if (kind == NSKeyValueChangeInsertion) { // 判断是否是插入数据
                NSArray *newObjs = [change objectForKey:@"new"];
                if (newObjs.count) {
                    for (WYBezierLineModel *dotModel in newObjs) { // 遍历新数据
                        
                        // 1.设置其起始点和终点
//                        NSLog(@"%@", dotModel);
                        dotModel.beginDotPoint = self.beginPoint;
                        dotModel.endDotPoint = [self convertPointDiagonally:self.beginPoint];
                        dotModel.controlPoint1 = _controlPoint1;
                        dotModel.controlPoint2 = _controlPoint2;
                        
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
                        
                        // 3.绑定索引
                        NSIndexSet *indexSet = change[@"indexes"];
                        dotModel.index = [indexSet lastIndex];
                        
                        // 4.发送方程通知
                        [self getResultEquationWithDotView:dotModel.beginDot];
                        [self sendNoti];
                        
                        // 5.保存最后的一个模型（因为监听不了移除前）
                        WYBezierLineModel *lastModel = [self.bezierArrM lastObject];
                        self.lastModel = lastModel;

                    }
                }
            } else if (kind == NSKeyValueChangeRemoval) { // 判断是移除数据
                
                 NSLog(@"%@", change);
                if (!self.lastModel)return;
                [self.lastModel.beginDot removeFromSuperview];
                [self.lastModel.endDot removeFromSuperview];
                [self.lastModel.controlDot1 removeFromSuperview];
                [self.lastModel.controlDot2 removeFromSuperview];
                [self.equationArrM removeLastObject];
                [self sendNoti];
                
                // 保存最后的一个模型（因为监听不了移除前）
                WYBezierLineModel *lastModel = [self.bezierArrM lastObject];
                self.lastModel = lastModel;
                
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















