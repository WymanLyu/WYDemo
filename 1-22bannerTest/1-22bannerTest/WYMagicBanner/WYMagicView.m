//
//  WYMagicView.m
//  KLParallaxView
//
//  Created by wyman on 2017/1/8.
//  Copyright © 2017年 dara. All rights reserved.
//

#import "WYMagicView.h"

// 初始的偏移
static CGFloat const kInitialParallaxOffsetDuringPick = 15.0;
// 初始阴影不透明度
static CGFloat const kInitialShadowOpacity = 0.8;
// 初始阴影半径
static CGFloat const kInitialShadowRadius = 25.0;
// 按压后的阴影半径
static CGFloat const kFinalShadowRadius = 15.0;

static NSString *const kGlowImageName = @"gloweffect";

@interface WYMagicView ()

/** 容器 */
@property (strong, nonatomic) UIView *contentView;

@property (nonatomic, strong)  NSDate *current;
@property (nonatomic, strong) NSSet *touches;
@property (nonatomic, strong) UIEvent *event;

@end

@implementation WYMagicView

#pragma mark - 生命周期

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 初始值
        _initialShadowRadius = kInitialShadowRadius;
        _finalShadowRadius = kFinalShadowRadius;
        _glows = YES;
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowRadius = _initialShadowRadius;
        self.layer.shadowOpacity = kInitialShadowOpacity;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0, _initialShadowRadius);
        
        // 阴影路径
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:CGPointMake(4, CGRectGetHeight(self.bounds))];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - 4,
                                         CGRectGetHeight(self.bounds))];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - 4, 20)];
        [path addLineToPoint:CGPointMake(4, 20)];
        [path closePath];
        self.layer.shadowPath = path.CGPath;
        
        // 内容视图
        _contentView = [UIView new];
        _contentView.frame = frame;
        _contentView.layer.masksToBounds = YES;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView.translatesAutoresizingMaskIntoConstraints = YES;
        
        // 图片视图
        _imgView = [UIImageView new];
        _imgView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
//        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [_contentView addSubview:_imgView];
        
        [self addSubview:_contentView];

    }
    return self;
}


#pragma mark - 阴影动画

- (void)createShadow {
    CGSize shadowOffset = CGSizeMake(0.0, self.finalShadowRadius);
    [self addGroupAnimationWithShadowOffset:shadowOffset
                               shadowRadius:self.finalShadowRadius
                                   duration:0.1
                                      layer:self.layer];
}

- (void)removeShadow {
    CGSize shadowOffset = CGSizeMake(0.0, self.initialShadowRadius);
    [self addGroupAnimationWithShadowOffset:shadowOffset
                               shadowRadius:self.initialShadowRadius
                                   duration:0.3
                                      layer:self.layer];
}

- (void)addGroupAnimationWithShadowOffset:(CGSize)shadowOffset
                             shadowRadius:(CGFloat)shadowRadius
                                 duration:(NSTimeInterval)duration
                                    layer:(CALayer *)layer {
    if (!CGSizeEqualToSize(layer.shadowOffset, shadowOffset) && layer.shadowRadius != shadowRadius) {
        CALayer *presentationLayer = (CALayer *)layer.presentationLayer;
        CABasicAnimation *offsetAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOffset"];
        offsetAnimation.fromValue = [NSValue valueWithCGSize:presentationLayer.shadowOffset];
        offsetAnimation.toValue = [NSValue valueWithCGSize:shadowOffset];
        
        CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
        radiusAnimation.fromValue = [NSNumber numberWithFloat:presentationLayer.shadowRadius];
        radiusAnimation.toValue = [NSNumber numberWithFloat:shadowRadius];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup new];
        animationGroup.duration = duration;
        animationGroup.animations = @[ offsetAnimation, radiusAnimation ];
        
        [layer addAnimation:animationGroup forKey:@"shadowRadius"];
        layer.shadowRadius = shadowRadius;
        layer.shadowOffset = shadowOffset;
    }
}

#pragma mark - 按压动画效果

// 根据点实现按压效果
- (void)parallaxEffectAtPoint:(CGPoint)point {
    UIView *superview = self.superview;
    CGFloat offsetX = (0.5 - point.x / superview.bounds.size.width) * -1;
    CGFloat offsetY = (0.5 - point.y / superview.bounds.size.height) * -1;
    // 这里控制放大比例
    CATransform3D transform = CATransform3DMakeScale(1, 1, 1);
    transform.m34 = 1.0/-500;
    
    CGFloat radiansPerDegree = M_PI / 180.0;
    
    CGFloat xAngle = (offsetX * kInitialParallaxOffsetDuringPick) * radiansPerDegree;
    CGFloat yAngle = (offsetY * kInitialParallaxOffsetDuringPick) * radiansPerDegree;
    
    // - / + 凹入凸出效果
    transform = CATransform3DRotate(transform, xAngle, 0, (0.5 - offsetY), 0);
    transform = CATransform3DRotate(transform, yAngle, -(0.5 - offsetY) * 2, 0, 0);

    self.layer.transform = transform;

}

// 移除按压效果
- (void)removeParallaxEffect {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CALayer *presentationLayer = (CALayer *)self.layer.presentationLayer;
    CATransform3D transform = CATransform3DIdentity;
    animation.fromValue = [NSValue valueWithCATransform3D:presentationLayer.transform];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = 0.25;
    [self.layer addAnimation:animation forKey:@"transform"];
    self.layer.transform = transform;
    
    for (UIView *subview in self.contentView.subviews) {
        presentationLayer = (CALayer *)subview.layer.presentationLayer;
        animation.fromValue = [NSValue valueWithCATransform3D:presentationLayer.transform];
        [subview.layer addAnimation:animation forKey:@"transform"];
        subview.layer.transform = transform;
    }
}


#pragma mark - 动画开关

- (void)startAnimationsWithTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.superview];
    [self createShadow];
    [self parallaxEffectAtPoint:point];
}

- (void)endAnimations {
    [self removeShadow];
    [self removeParallaxEffect];
}

#pragma mark - 手势控制

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [super touchesBegan:touches withEvent:event];
    
    self.current = [NSDate date];
    
    [self startAnimationsWithTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self startAnimationsWithTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endAnimations];
    [super touchesEnded:touches withEvent:event];
}


#pragma mark - backgroundColor accessors

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.contentView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return self.contentView.backgroundColor;
}

#pragma mark - 边角

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.contentView.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.contentView.layer.cornerRadius;
}

#pragma mark - 阴影透明

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

#pragma mark - 阴影颜色

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}



@end
