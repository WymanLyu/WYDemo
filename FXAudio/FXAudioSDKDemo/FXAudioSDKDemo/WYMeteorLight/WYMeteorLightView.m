//
//  WYMeteorLightView.m
//  FXAudioDemo
//
//  Created by wyman on 2017/6/20.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYMeteorLightView.h"

@interface WYMeteorLightView ()

@property (nonatomic, strong) CALayer *meteorLightLayer;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation WYMeteorLightView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSub];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
         [self initSub];
    }
    return self;
}

- (void)initSub {
    CALayer *meteorLightLayer = [CALayer layer];
    [self.layer addSublayer:meteorLightLayer];
    _meteorLightLayer = meteorLightLayer;
    _meteorLightLayer.anchorPoint = CGPointMake(0.0, 0.0);
    _meteorLightLayer.bounds = self.bounds;
    
    self.meteorLightColor = [UIColor whiteColor];
    self.meteorLightWidth = 20;
    self.direction = MeteorLightDirectionTop;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _meteorLightLayer.anchorPoint = CGPointMake(0.0, 0.0);
    _meteorLightLayer.bounds = self.bounds;
    [self stop];
}

#pragma mark - 懒加载

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        
        UIColor *transparentColor1 = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        UIColor *transparentColor2 = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        UIColor *opaqueColor1 = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        UIColor *opaqueColor2 = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        _gradientLayer.colors = @[(__bridge id)transparentColor1.CGColor, (__bridge id)opaqueColor1.CGColor, (__bridge id)opaqueColor2.CGColor, (__bridge id)transparentColor2.CGColor];
        CGFloat widthScale = 0;
        switch (self.direction) {
            case MeteorLightDirectionLeft:
            {
                widthScale = self.meteorLightWidth /  self.frame.size.width;
                _gradientLayer.locations = @[@(0.0), @(widthScale), @(widthScale+widthScale*0.15), @(widthScale+widthScale*0.5)];
                _gradientLayer.startPoint = CGPointMake(0, 0);
                _gradientLayer.endPoint = CGPointMake(1, 0);
            }
                break;
            case MeteorLightDirectionRight:
            {
                widthScale = self.meteorLightWidth /  self.frame.size.width;
                _gradientLayer.locations = @[@(1.0-widthScale*1.65), @(1.0-widthScale*1.15), @(1-widthScale), @(1.0)];
                _gradientLayer.startPoint = CGPointMake(0, 0);
                _gradientLayer.endPoint = CGPointMake(1, 0);
            }
                break;
            case MeteorLightDirectionTop:
            {
                widthScale = self.meteorLightWidth /  self.frame.size.height;
                _gradientLayer.locations = @[@(0.0), @(widthScale), @(widthScale+widthScale*0.15), @(widthScale+widthScale*0.5)];
                _gradientLayer.startPoint = CGPointMake(0, 0);
                _gradientLayer.endPoint = CGPointMake(0, 1);
            }
                break;
            case MeteorLightDirectionBottom:
            {
                widthScale = self.meteorLightWidth /  self.frame.size.height;
                _gradientLayer.locations =  @[@(1.0-widthScale*1.65), @(1.0-widthScale*1.15), @(1-widthScale), @(1.0)];
                _gradientLayer.startPoint = CGPointMake(0, 0);
                _gradientLayer.endPoint = CGPointMake(0, 1);
            }
                break;
            default:
                break;
        }
        self.meteorLightLayer.mask = _gradientLayer;
    }
    return _gradientLayer;
}

#pragma mark - 属性

- (void)setMeteorLightColor:(UIColor *)meteorLightColor {
    _meteorLightColor = meteorLightColor;
    self.meteorLightLayer.backgroundColor = _meteorLightColor.CGColor;
}

#pragma mark - 控制

- (void)start {
    self.gradientLayer.hidden = NO;
    
    CABasicAnimation *colorLocationAni = [CABasicAnimation animationWithKeyPath:@"locations"];
    CGFloat widthScale = 0;
    switch (self.direction) {
        case MeteorLightDirectionLeft:
        {
            widthScale = self.meteorLightWidth /  self.frame.size.width;
            colorLocationAni.fromValue = @[@(0.0), @(widthScale), @(widthScale+widthScale*0.15), @(widthScale+widthScale*0.5)];
            colorLocationAni.toValue = @[@(1.0), @(1.0+widthScale), @(1.0+widthScale+widthScale*0.15), @(1.0+widthScale+widthScale*0.5)];
        }
            break;
        case MeteorLightDirectionRight:
        {
            widthScale = self.meteorLightWidth /  self.frame.size.width;
            colorLocationAni.fromValue =  @[@(1.0-widthScale*1.65), @(1.0-widthScale*1.15), @(1-widthScale), @(1.0)];
            colorLocationAni.toValue = @[@(-widthScale*1.65), @(-widthScale*1.15), @(-widthScale), @(0.0)];
        }
            break;
        case MeteorLightDirectionTop:
        {
            widthScale = self.meteorLightWidth /  self.frame.size.height;
            colorLocationAni.fromValue = @[@(0.0), @(widthScale), @(widthScale+widthScale*0.15), @(widthScale+widthScale*0.5)];
            colorLocationAni.toValue = @[@(1.0), @(1.0+widthScale), @(1.0+widthScale+widthScale*0.15), @(1.0+widthScale+widthScale*0.5)];
        }
            break;
        case MeteorLightDirectionBottom:
        {
            widthScale = self.meteorLightWidth /  self.frame.size.height;
            colorLocationAni.fromValue =  @[@(1.0-widthScale*1.65), @(1.0-widthScale*1.15), @(1-widthScale), @(1.0)];
            colorLocationAni.toValue = @[@(-widthScale*1.65), @(-widthScale*1.15), @(-widthScale), @(0.0)];
        }
            break;

        default:
            break;
    }
    colorLocationAni.repeatCount = MAXFLOAT;
    colorLocationAni.duration = 0.75;
    [self.gradientLayer addAnimation:colorLocationAni forKey:@"GradientLayer_Locations_Animation"];
}

- (void)stop {
    self.gradientLayer.hidden = YES;
    [self.meteorLightLayer removeAllAnimations];
}














@end
