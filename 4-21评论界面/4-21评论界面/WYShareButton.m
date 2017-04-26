//
//  WYShareButton.m
//  4-16分享动效
//
//  Created by wyman on 2017/4/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYShareButton.h"
#import "UIImage+WY.h"
#import "UIColor+WY.h"

@interface WYShareButton ()

/** 斜线/的路径 */
@property (nonatomic, strong) UIBezierPath *lineLayerPath1Normal;   // 普通
@property (nonatomic, strong) UIBezierPath *lineLayerPath1Selected; // 选中

/** 斜线\的路径 */
@property (nonatomic, strong) UIBezierPath *lineLayerPath2Normal;   // 普通
@property (nonatomic, strong) UIBezierPath *lineLayerPath2Selected; // 选中

/** 颜色 */
@property (nonatomic, strong) UIColor *lineLayerColor;
/** 宽度 */
@property (nonatomic, assign) CGFloat lineLayerWidth;

/** 小点layer */
@property (nonatomic, assign) CGFloat midLayerW;


@end

@implementation WYShareButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.shareSelected = NO;
        // 初始化
        [self initPropertyWithFrame:frame];
        // 设置layer
        [self initSubLayerWithFrame:frame];
    }
    return self;
}

#pragma mark - 初始化属性

- (void)initPropertyWithFrame:(CGRect)frame {
    // 动画
    self.animateTime = 0.30;
    // 颜色
//    self.lineLayerColor = [UIColor ys_colorWithHexInt:0x999999];
    self.lineLayerWidth = 1.5;
    // 小点
    self.midLayerW = 4;
    // 斜线/path
    CGFloat margin = 3;
    CGFloat endScale = 1.2;
    CGPoint beginP1 = CGPointMake(margin, frame.size.height*0.5);
    CGPoint endP1 = CGPointMake(frame.size.width-margin, margin);
    self.lineLayerPath1Normal = [self createPathWithBeginPoint:beginP1 endPoint:endP1];
    self.lineLayerPath1Selected = [self createPathWithBeginPoint:CGPointMake(margin*endScale, frame.size.height-margin*endScale) endPoint:CGPointMake(frame.size.width-margin*endScale, margin*endScale)];
    // 斜线\path
    CGPoint beginP2 = CGPointMake(margin, frame.size.height*0.5);
    CGPoint endP2 = CGPointMake(frame.size.width-margin, frame.size.width-margin);
    self.lineLayerPath2Normal = [self createPathWithBeginPoint:beginP2 endPoint:endP2];
    self.lineLayerPath2Selected = [self createPathWithBeginPoint:CGPointMake(margin*endScale, margin*endScale) endPoint:CGPointMake(frame.size.width-margin*endScale, frame.size.width-margin*endScale)];
    // 小点
    self.midP1 = beginP1;
    self.midP2 = endP1;
    self.midP3 = endP2;
    self.midLayer1 = [self createCenterLayerWithCenterPoint:beginP1];
    self.midLayer2 = [self createCenterLayerWithCenterPoint:endP1];
    self.midLayer3 = [self createCenterLayerWithCenterPoint:endP2];
    self.midBounds1= self.midLayer1.bounds;
    self.midBounds2 = self.midLayer2.bounds;
    self.midBounds3 = self.midLayer3.bounds;
    self.midContents1 = self.midLayer1.contents;
    self.midContents2 = self.midLayer2.contents;
    self.midContents3 = self.midLayer3.contents;
}

- (void)initSubLayerWithFrame:(CGRect)frame {
    
    // 斜线/layer
    self.lineLayer1 = [CAShapeLayer layer];
    self.lineLayer1.path = self.lineLayerPath1Normal.CGPath;
    self.lineLayer1.strokeColor = self.lineLayerColor.CGColor;
    self.lineLayer1.lineWidth = self.lineLayerWidth;
    self.lineLayer1.lineCap = @"round";
    [self.layer addSublayer:self.lineLayer1];
    
    // 斜线\layer
    self.lineLayer2 = [CAShapeLayer layer];
    self.lineLayer2.path = self.lineLayerPath2Normal.CGPath;
    self.lineLayer2.strokeColor = self.lineLayerColor.CGColor;
    self.lineLayer2.lineWidth = self.lineLayerWidth;
    self.lineLayer2.lineCap = @"round";
    [self.layer addSublayer:self.lineLayer2];
 
    // 左边中间*
    [self.layer addSublayer:self.midLayer1];
    // 右上角*
    [self.layer addSublayer:self.midLayer2];
    // 右下角*
    [self.layer addSublayer:self.midLayer3];
}

- (void)forceLayout {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    // 初始化
    [self initPropertyWithFrame:self.frame];
    // 设置layer
    [self initSubLayerWithFrame:self.frame];
}

#pragma mark - 点击

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isShareSelected) { // normal -> selecte
        [self select];
    } else {
        [self disSelect];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect convertRect = [self.superview convertRect:self.hitTestRect toView:self];
    if (CGRectContainsPoint(convertRect, point)) {
        return self;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

#pragma mark - 动画
static bool animating = NO;
- (void)select {
    if (self.isShareSelected || animating) {
        return;
    }
    
    self.shareSelected = !self.isShareSelected;
    self.userInteractionEnabled = NO;
    animating = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animateTime*1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        animating = NO;
    });
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    
    // 获取目标数据
    WYShareButtonAnimateTargetData *data1 = nil;
    WYShareButtonAnimateTargetData *data2 = nil;
    WYShareButtonAnimateTargetData *data3 = nil;
    if ([self.delegate respondsToSelector:@selector(shareButtonFirstMidLayerTargetData:)]) {
        data1 = [self.delegate shareButtonFirstMidLayerTargetData:self];
    }
    if ([self.delegate respondsToSelector:@selector(shareButtonSecondMidLayerTargetData:)]) {
        data2 = [self.delegate shareButtonSecondMidLayerTargetData:self];
    }
    if ([self.delegate respondsToSelector:@selector(shareButtonThirstMidLayerTargetData:)]) {
        data3 = [self.delegate shareButtonThirstMidLayerTargetData:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(shareButtonStateNormal2SelecteAnimateBegin:)]) {
        [self.delegate shareButtonStateNormal2SelecteAnimateBegin:self];
    }
    
    // 线条变换
    CABasicAnimation *ani1 = [CABasicAnimation animationWithKeyPath:@"path"];
    ani1.toValue = (__bridge id _Nullable)(self.lineLayerPath1Selected.CGPath);
    ani1.duration = self.animateTime;
    ani1.fillMode = kCAFillModeForwards;
    ani1.removedOnCompletion = NO;
    [self.lineLayer1 addAnimation:ani1 forKey:@"lineLayer1_normal_2_selected"];
    
    CABasicAnimation *ani2 = [CABasicAnimation animationWithKeyPath:@"path"];
    ani2.toValue = (__bridge id _Nullable)(self.lineLayerPath2Selected.CGPath);
    ani2.duration = self.animateTime;
    ani2.fillMode = kCAFillModeForwards;
    ani2.removedOnCompletion = NO;
    [self.lineLayer2 addAnimation:ani2 forKey:@"lineLayer2_normal_2_selected"];
    
    // 坐标平移
    CABasicAnimation *anip1 = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint p1 = self.midP1;
    if (data1) {
        p1 = data1.targetCenterPoint;
        p1 = [[UIApplication sharedApplication].keyWindow convertPoint:p1 toView:self];
    }
    anip1.toValue = [NSValue valueWithCGPoint:p1];
    anip1.duration = self.animateTime;
    anip1.fillMode = kCAFillModeForwards;
    anip1.removedOnCompletion = NO;
    if (data1.targetImg) {
        [self.midLayer1 addAnimation:anip1 forKey:@"midLayer1_position_2_selected"];
    }
    
    CABasicAnimation *anip2 = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint p2 = self.midP2;
    if (data2.targetImg) {
        p2 = data2.targetCenterPoint;
        p2 = [[UIApplication sharedApplication].keyWindow convertPoint:p2 toView:self];
    }
    anip2.toValue = [NSValue valueWithCGPoint:p2];
    anip2.duration = self.animateTime;
    anip2.fillMode = kCAFillModeForwards;
    anip2.removedOnCompletion = NO;
    if (data2.targetImg) {
         [self.midLayer2 addAnimation:anip2 forKey:@"midLayer2_position_2_selected"];
    }
    
    CABasicAnimation *anip3 = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint p3 = self.midP3;
    if (data3) {
        p3 = data3.targetCenterPoint;
        p3 = [[UIApplication sharedApplication].keyWindow convertPoint:p3 toView:self];
    }
    anip3.toValue = [NSValue valueWithCGPoint:p3];
    anip3.duration = self.animateTime;
    anip3.fillMode = kCAFillModeForwards;
    anip3.removedOnCompletion = NO;
    if (data3.targetImg) {
        [self.midLayer3 addAnimation:anip3 forKey:@"midLayer3_position_2_selected"];
    }
 
    
    // 放大
    CABasicAnimation *aniScale1 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    CGRect bounds1 = self.midBounds1;
    if (data1.targetImg) {
        CGSize size1 = data1.targetSize;
        bounds1 = CGRectMake(0, 0, size1.width, size1.height);
    }
    aniScale1.toValue = [NSValue valueWithCGRect:bounds1];
    aniScale1.duration = self.animateTime;
    aniScale1.fillMode = kCAFillModeForwards;
    aniScale1.removedOnCompletion = NO;
    if (data1.targetImg) { // 有内容时才有动画
        [self.midLayer1 addAnimation:aniScale1 forKey:@"midLayer1_bounds_2_selected"];
    }
    
    CABasicAnimation *aniScale2 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    CGRect bounds2 = self.midBounds2;
    if (data2.targetImg) {
        CGSize size2 = data2.targetSize;
        bounds2 = CGRectMake(0, 0, size2.width, size2.height);
    }
    aniScale2.toValue = [NSValue valueWithCGRect:bounds2];
    aniScale2.duration = self.animateTime;
    aniScale2.fillMode = kCAFillModeForwards;
    aniScale2.removedOnCompletion = NO;
    if (data2.targetImg) {
        [self.midLayer2 addAnimation:aniScale2 forKey:@"midLayer2_bounds_2_selected"];
    }
    
    CABasicAnimation *aniScale3 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    CGRect bounds3 = self.midBounds3;
    if (data3) {
        CGSize size3 = data3.targetSize;
        bounds3 = CGRectMake(0, 0, size3.width, size3.height);
    }
    aniScale3.toValue = [NSValue valueWithCGRect:bounds3];
    aniScale3.duration = self.animateTime;
    aniScale3.fillMode = kCAFillModeForwards;
    aniScale3.removedOnCompletion = NO;
    if (data3.targetImg) {
        [self.midLayer3 addAnimation:aniScale3 forKey:@"midLayer3_bounds_2_selected"];
    }
    
    // 内容
    id fromValue = (id)[UIImage wy_imageWithUIColor:[UIColor wy_colorWithHexInt:0x444444 alpha:1.0] andFrame:CGRectMake(0, 0, 10, 10)].CGImage;
    CABasicAnimation *aniContents1 = [CABasicAnimation animationWithKeyPath:@"contents"];
    id contents1 = self.midContents1;
    if (data1) {
        contents1 = (id)data1.targetImg.CGImage;
    }
    aniContents1.fromValue = fromValue;// self.midContents1;
    aniContents1.toValue = contents1;
    aniContents1.duration = self.animateTime;
    aniContents1.fillMode = kCAFillModeForwards;
    aniContents1.removedOnCompletion = NO;
    if (data1.targetImg) {
//         [self.midLayer1 addAnimation:aniContents1 forKey:@"midLayer1_contents_2_selected"];
    }
    self.midLayer1.contents = contents1;
    
    CABasicAnimation *aniContents2 = [CABasicAnimation animationWithKeyPath:@"contents"];
    id contents2 = self.midContents2;
    if (data2.targetImg) {
        contents2 = (id)data2.targetImg.CGImage;
    }
    aniContents2.fromValue = fromValue;
    aniContents2.toValue = contents2;
    aniContents2.duration = self.animateTime;
    aniContents2.fillMode = kCAFillModeForwards;
    aniContents2.removedOnCompletion = NO;
    if (data2.targetImg) {
        [self.midLayer2 addAnimation:aniContents2 forKey:@"midLayer2_contents_2_selected"];
    }
    
    CABasicAnimation *aniContents3 = [CABasicAnimation animationWithKeyPath:@"contents"];
    id contents3 = self.midContents3;
    if (data3.targetImg) {
        contents3 = (id)data3.targetImg.CGImage;
    }
    aniContents3.fromValue = fromValue;
    aniContents3.toValue = contents3;
    aniContents3.duration = self.animateTime;
    aniContents3.fillMode = kCAFillModeForwards;
    aniContents3.removedOnCompletion = NO;
    if (data3.targetImg) {
        [self.midLayer3 addAnimation:aniContents3 forKey:@"midLayer3_contents_2_selected"];
    }
}

- (void)disSelect {
    if (!self.isShareSelected || animating) {
        return;
    }
    
    self.shareSelected = !self.isShareSelected;
    self.userInteractionEnabled = NO;
    animating = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.animateTime*1.25) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        animating = NO;
    });
    
    if ([self.delegate respondsToSelector:@selector(shareButtonStateSelecte2NormalAnimateBegin:)]) {
        [self.delegate shareButtonStateSelecte2NormalAnimateBegin:self];
    }
    
    // 线条
    CABasicAnimation *ani1 = [CABasicAnimation animationWithKeyPath:@"path"];
    ani1.toValue = (__bridge id _Nullable)(self.lineLayerPath1Normal.CGPath);
    ani1.duration = self.animateTime;
    ani1.fillMode = kCAFillModeForwards;
    ani1.removedOnCompletion = NO;
    [self.lineLayer1 addAnimation:ani1 forKey:@"lineLayer1_selected_2_normal"];
    
    CABasicAnimation *ani2 = [CABasicAnimation animationWithKeyPath:@"path"];
    ani2.toValue = (__bridge id _Nullable)(self.lineLayerPath2Normal.CGPath);
    ani2.duration = self.animateTime;
    ani2.fillMode = kCAFillModeForwards;
    ani2.removedOnCompletion = NO;
    [self.lineLayer2 addAnimation:ani2 forKey:@"lineLayer2_selected_2_normal"];
    
    // 平移
    CABasicAnimation *anip1 = [CABasicAnimation animationWithKeyPath:@"position"];
    anip1.toValue = [NSValue valueWithCGPoint:self.midP1];
    anip1.duration = self.animateTime;
    anip1.fillMode = kCAFillModeForwards;
    anip1.removedOnCompletion = NO;
    [self.midLayer1 addAnimation:anip1 forKey:@"midLayer1_position_2_normal"];
    
    CABasicAnimation *anip2 = [CABasicAnimation animationWithKeyPath:@"position"];
    anip2.toValue = [NSValue valueWithCGPoint:self.midP2];
    anip2.duration = self.animateTime;
    anip2.fillMode = kCAFillModeForwards;
    anip2.removedOnCompletion = NO;
    [self.midLayer2 addAnimation:anip2 forKey:@"midLayer2_position_2_normal"];
    
    CABasicAnimation *anip3 = [CABasicAnimation animationWithKeyPath:@"position"];
    anip3.toValue = [NSValue valueWithCGPoint:self.midP3];
    anip3.duration = self.animateTime;
    anip3.fillMode = kCAFillModeForwards;
    anip3.removedOnCompletion = NO;
    [self.midLayer3 addAnimation:anip3 forKey:@"midLayer3_position_2_normal"];
    
    // 放大
    CABasicAnimation *aniScale1 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    aniScale1.toValue = [NSValue valueWithCGRect:self.midBounds1];
    aniScale1.duration = self.animateTime;
    aniScale1.fillMode = kCAFillModeForwards;
    aniScale1.removedOnCompletion = NO;
    [self.midLayer1 addAnimation:aniScale1 forKey:@"midLayer1_bounds_2_normal"];
    
    CABasicAnimation *aniScale2 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    aniScale2.toValue = [NSValue valueWithCGRect:self.midBounds2];
    aniScale2.duration = self.animateTime;
    aniScale2.fillMode = kCAFillModeForwards;
    aniScale2.removedOnCompletion = NO;
    [self.midLayer2 addAnimation:aniScale2 forKey:@"midLayer2_bounds_2_normal"];
    
    CABasicAnimation *aniScale3 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    aniScale3.toValue = [NSValue valueWithCGRect:self.midBounds3];
    aniScale3.duration = self.animateTime;
    aniScale3.fillMode = kCAFillModeForwards;
    aniScale3.removedOnCompletion = NO;
    [self.midLayer3 addAnimation:aniScale3 forKey:@"midLayer3_bounds_2_normal"];
    
    // 内容
    CABasicAnimation *aniContents1 = [CABasicAnimation animationWithKeyPath:@"contents"];
    aniContents1.toValue = self.midContents1;
    aniContents1.duration = self.animateTime;
    aniContents1.fillMode = kCAFillModeForwards;
    aniContents1.removedOnCompletion = NO;
    [self.midLayer1 addAnimation:aniContents1 forKey:@"midLayer1_contents_2_normal"];
    
    CABasicAnimation *aniContents2 = [CABasicAnimation animationWithKeyPath:@"contents"];
    aniContents2.toValue = self.midContents2;
    aniContents2.duration = self.animateTime;
    aniContents2.fillMode = kCAFillModeForwards;
    aniContents2.removedOnCompletion = NO;
    [self.midLayer2 addAnimation:aniContents2 forKey:@"midLayer2_contents_2_normal"];
    
    CABasicAnimation *aniContents3 = [CABasicAnimation animationWithKeyPath:@"contents"];
    aniContents3.toValue = self.midContents3;
    aniContents3.duration = self.animateTime;
    aniContents3.fillMode = kCAFillModeForwards;
    aniContents3.removedOnCompletion = NO;
    [self.midLayer3 addAnimation:aniContents3 forKey:@"midLayer3_contents_2_normal"];

}


#pragma mark - 私有工具方法

- (UIBezierPath *)createPathWithBeginPoint:(CGPoint)beginP endPoint:(CGPoint)endP {
    UIBezierPath *lineLayerPath = [[UIBezierPath alloc] init];
    [lineLayerPath moveToPoint:beginP];
    [lineLayerPath addLineToPoint:endP];
    lineLayerPath.lineWidth = self.lineLayerWidth;
    lineLayerPath.lineCapStyle = kCGLineCapRound;
    return lineLayerPath;
}


- (CALayer *)createCenterLayerWithCenterPoint:(CGPoint)centerP {
    CALayer *midLayer = [CALayer layer];
    midLayer.anchorPoint = CGPointMake(0.5, 0.5);
    midLayer.bounds = CGRectMake(0, 0, self.midLayerW,  self.midLayerW);
    midLayer.position = centerP;
    midLayer.backgroundColor = self.lineLayerColor.CGColor;
    midLayer.cornerRadius = self.midLayerW*0.5;
    midLayer.masksToBounds = YES;
    midLayer.contents = (__bridge id _Nullable)([UIImage wy_imageWithUIColor: self.lineLayerColor andFrame:midLayer.bounds].CGImage);
    return midLayer;
}


@end


@implementation WYShareButtonAnimateTargetData


@end

