//
//  SimpleNavgationBar.m
//  HeiPa
//
//  Created by wyman on 2017/9/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "SimpleNavgationBar.h"
#import <objc/runtime.h>

@implementation UINavigationBar (SimpleNavgationBar)

- (void)sn_reset {
    // 重置前记录
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    self.sn_bottomLineHidden = NO;
}

#pragma mark - 属性

static char overlayKey;

// 自定义view
- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)overlay {
    UIView *overlay = objc_getAssociatedObject(self, &overlayKey);
    if (!overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        overlay.userInteractionEnabled = NO;
        overlay.backgroundColor = [UIColor clearColor];
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [self setOverlay:overlay];
        [[self.subviews firstObject] insertSubview:overlay atIndex:0];
    }
    [[self.subviews firstObject] insertSubview:overlay atIndex:0];
    return overlay;
}

// 透明度
- (void)setSn_alpha:(CGFloat)sn_alpha {
    self.overlay.alpha = sn_alpha;
}
- (CGFloat)sn_alpha {
    return self.overlay.alpha;
}

// 下划线
- (void)setSn_bottomLineHidden:(BOOL)sn_bottomLineHidden {
    UIImage *shadowImg = nil;
    if (sn_bottomLineHidden) shadowImg=[[UIImage alloc] init];
    self.shadowImage = shadowImg;
}
- (BOOL)sn_bottomLineHidden {
    return (self.shadowImage) ? YES : NO;
}


#pragma mark - 方法

- (void)sn_setBackgroundColor:(UIColor *)backgroundColor {
    self.overlay.backgroundColor = backgroundColor;
}

- (void)sn_setTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

@end

@implementation UIViewController (SimpleNavgationBar)

- (BOOL)canUpdateNavigationBar {
    if (self.navigationController && CGRectEqualToRect(self.view.frame, [UIScreen mainScreen].bounds)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)sn_reset {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
//    id<UIViewControllerTransitionCoordinator> coor = [nav.topViewController transitionCoordinator];
    
    if (!nav.sn_dontKeepSNState) {
        self.sn_keepBackgroundColor = self.sn_navBarBackgroundColor;
        self.sn_keepAlpha = self.sn_navBarAlpha;
        NSLog(@"%@保存之前颜色：%@, 保存之前的透明度%f--%zd",self, self.sn_keepBackgroundColor, self.sn_navBarAlpha, nav.interactivePopGestureRecognizer.state);
    }
    nav.sn_dontKeepSNState = NO; // 置为需要记录状态，因为不需要记录状态仅当手势动画被取消
    
//    if ([coor initiallyInteractive] != YES) { // 仅在非转场中，记录
//        self.sn_keepBackgroundColor = self.sn_navBarBackgroundColor;
//        self.sn_keepAlpha = self.sn_navBarAlpha;
//        NSLog(@"保存之前颜色：%@, 保存之前的透明度%f", self.sn_keepBackgroundColor, self.sn_navBarAlpha);
//    }

//    self.sn_keepBackgroundColor = self.sn_navBarBackgroundColor;
//    self.sn_keepAlpha = self.sn_navBarAlpha;
    
    [self.navigationController.navigationBar sn_reset];
}

static char keepBackgroundColorKey;
static char keepAlphaKey;

#pragma mark - 属性
// 保存的背景色
- (void)setSn_keepBackgroundColor:(UIColor *)sn_keepBackgroundColor {
    objc_setAssociatedObject(self, &keepBackgroundColorKey, sn_keepBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)sn_keepBackgroundColor {
    return (UIColor *)objc_getAssociatedObject(self, &keepBackgroundColorKey);
}

// 保存的透明度
- (void)setSn_keepAlpha:(CGFloat )sn_keepAlpha {
    objc_setAssociatedObject(self, &keepAlphaKey, @(sn_keepAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)sn_keepAlpha {
    NSNumber *alpha = (NSNumber *)objc_getAssociatedObject(self, &keepAlphaKey);
    return alpha.floatValue;
}

// 透明度
- (void)setSn_navBarAlpha:(CGFloat)sn_navBarAlpha {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.navigationBar setSn_alpha:sn_navBarAlpha];
}
- (CGFloat)sn_navBarAlpha {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.sn_alpha;
}

// 背景色
- (void)setSn_navBarBackgroundColor:(UIColor *)sn_navBarBackgroundColor {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.navigationBar sn_setBackgroundColor:sn_navBarBackgroundColor];
}
- (UIColor *)sn_navBarBackgroundColor {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.overlay.backgroundColor;
}

// 底部条
- (void)setSn_navBarBottomLineHidden:(BOOL)sn_navBarBottomLineHidden {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    nav.navigationBar.sn_bottomLineHidden = sn_navBarBottomLineHidden;
}
- (BOOL)sn_navBarBottomLineHidden {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.sn_bottomLineHidden;
}

#pragma mark - 方法
// 更新颜色
- (void)sn_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress {
    UIColor *fromBarColor = fromVC.sn_keepBackgroundColor;
    UIColor *toBarColor = toVC.sn_keepBackgroundColor;
    if (!fromBarColor || !toBarColor) {
        return;
    }
    UIColor *newBarTintColor = [UIColor middleColor:fromBarColor toColor:toBarColor percent:progress];
    toVC.sn_navBarBackgroundColor = newBarTintColor; // 这里因为苹果默认的转场时的bar是取toVC的进行模糊
    
    CGFloat fromBarAlpha = fromVC.sn_keepAlpha;
    CGFloat toBarAlpha = toVC.sn_keepAlpha;
    CGFloat newBarAlpha = fromBarAlpha + (toBarAlpha-fromBarAlpha)*progress;
    NSLog(@"%f--%f--new:%f - color:%@",fromBarAlpha,toBarAlpha,newBarAlpha,newBarTintColor);
    toVC.sn_navBarAlpha = newBarAlpha; // 这里因为苹果默认的转场时的bar是取toVC的进行模糊
    
}



@end

@implementation UINavigationController (SimpleNavgationBar)

static char sn_dontKeepSNStateKey;

- (void)setSn_dontKeepSNState:(BOOL)sn_dontKeepSNState {
    objc_setAssociatedObject(self, &sn_dontKeepSNStateKey, @(sn_dontKeepSNState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sn_dontKeepSNState {
   return [(NSNumber *)objc_getAssociatedObject(self, &sn_dontKeepSNStateKey) boolValue];
}

@end


@implementation UIColor (SimpleNavgationBar)
+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

@end



