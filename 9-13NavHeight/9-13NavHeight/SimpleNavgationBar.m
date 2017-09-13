//
//  SimpleNavgationBar.m
//  HeiPa
//
//  Created by wyman on 2017/9/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "SimpleNavgationBar.h"
#import <objc/runtime.h>

@interface UINavigationBar (SimpleNavgationBar)

- (void)sn_setBackgroundColor:(UIColor *)backgroundColor;
- (void)sn_reset;

@property (nonatomic, assign) CGFloat sn_alpha;
@property (nonatomic, assign) BOOL sn_bottomLineHidden;

@end

@interface UINavigationController (SimpleNavgationBar)

@property (nonatomic, assign) NSInteger sn_dontKeepSNState; // YES标示不要记录bar状态
- (void)sn_updateInteractiveTransition:(UIPanGestureRecognizer *)panGesture;

@end


@interface UIColor (SimpleNavgationBar)
+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent;
@end

@interface UIViewController (_SimpleNavgationBar)
@property (nonatomic, strong) UIColor *sn_keepBackgroundColor; // 保存的背景色
@property (nonatomic, assign) CGFloat sn_keepAlpha;            // 保存的透明度
- (void)sn_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress;
@end

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

@implementation UIViewController (_SimpleNavgationBar)
@dynamic sn_keepBackgroundColor, sn_keepAlpha;
static char keepBackgroundColorKey;
static char keepAlphaKey;
static char barStyleKey;

- (void)sn_addGuestTarget {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.interactivePopGestureRecognizer addTarget:nav action:@selector(sn_updateInteractiveTransition:)]; // 增加手势方法,处理转场
}

#pragma mark - 属性
// 保存的透明度
- (void)setSn_keepAlpha:(CGFloat )sn_keepAlpha {
    [self sn_addGuestTarget];
    objc_setAssociatedObject(self, &keepAlphaKey, @(sn_keepAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)sn_keepAlpha {
    NSNumber *alpha = (NSNumber *)objc_getAssociatedObject(self, &keepAlphaKey);
    return alpha.floatValue;
}

// 保存的背景色
- (void)setSn_keepBackgroundColor:(UIColor *)sn_keepBackgroundColor {
    [self sn_addGuestTarget];
    objc_setAssociatedObject(self, &keepBackgroundColorKey, sn_keepBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)sn_keepBackgroundColor {
    return (UIColor *)objc_getAssociatedObject(self, &keepBackgroundColorKey);
}

#pragma mark - 方法
// 更新颜色
- (void)sn_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress {
    UIColor *fromBarColor = fromVC.sn_keepBackgroundColor;
    UIColor *toBarColor = toVC.sn_keepBackgroundColor;
    if (!toBarColor) {
        toBarColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if (!fromBarColor || !toBarColor) {
        return;
    }
    UIColor *newBarTintColor = [UIColor middleColor:fromBarColor toColor:toBarColor percent:progress];
    toVC.sn_navBarBackgroundColor = newBarTintColor; // 这里因为苹果默认的转场时的bar是取toVC的进行模糊
    CGFloat fromBarAlpha = fromVC.sn_keepAlpha;
    CGFloat toBarAlpha = toVC.sn_keepAlpha;
    CGFloat newBarAlpha = fromBarAlpha + (toBarAlpha-fromBarAlpha)*progress;
    toVC.sn_navBarAlpha = newBarAlpha; // 这里因为苹果默认的转场时的bar是取toVC的进行模糊
}

@end

@implementation UIViewController (SimpleNavgationBar)

- (void)sn_reset {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    // 动画中途取消调用viewWillDisappear时，获取的bar不是自身所需的...
    if (!nav.sn_dontKeepSNState) { // 只有在非中断状态记录
        self.sn_keepBackgroundColor = self.sn_navBarBackgroundColor;
        self.sn_keepAlpha = self.sn_navBarAlpha;
    }
    self.sn_barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar sn_reset];
}

// 导航栏样式
- (void)setSn_barStyle:(UIBarStyle)sn_barStyle {
    [self sn_addGuestTarget];
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    nav.navigationBar.barStyle = sn_barStyle;
    objc_setAssociatedObject(self, &barStyleKey, @(sn_barStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIBarStyle)sn_barStyle {
    NSNumber *barStyle = (NSNumber *)objc_getAssociatedObject(self, &barStyleKey);
    return barStyle.integerValue;
}

// 透明度
- (void)setSn_navBarAlpha:(CGFloat)sn_navBarAlpha {
    [self sn_addGuestTarget];
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.navigationBar setSn_alpha:sn_navBarAlpha];
}
- (CGFloat)sn_navBarAlpha {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.sn_alpha;
}

// 背景色
- (void)setSn_navBarBackgroundColor:(UIColor *)sn_navBarBackgroundColor {
    [self sn_addGuestTarget];
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.navigationBar sn_setBackgroundColor:sn_navBarBackgroundColor];
}
- (UIColor *)sn_navBarBackgroundColor {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.overlay.backgroundColor;
}

// 底部条
- (void)setSn_navBarBottomLineHidden:(BOOL)sn_navBarBottomLineHidden {
    [self sn_addGuestTarget];
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    nav.navigationBar.sn_bottomLineHidden = sn_navBarBottomLineHidden;
}
- (BOOL)sn_navBarBottomLineHidden {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.sn_bottomLineHidden;
}

@end

@implementation UINavigationController (SimpleNavgationBar)

static char sn_dontKeepSNStateKey;

- (void)setSn_dontKeepSNState:(NSInteger)sn_dontKeepSNState {
    objc_setAssociatedObject(self, &sn_dontKeepSNStateKey, @(sn_dontKeepSNState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)sn_dontKeepSNState {
   return [(NSNumber *)objc_getAssociatedObject(self, &sn_dontKeepSNStateKey) integerValue];
}

#pragma mark - 处理手势返回
- (void)sn_updateInteractiveTransition:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            CGFloat persent = transitionX / panGesture.view.frame.size.width;
            UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
//            if (persent < 0.01) { // 刚开始时不要触发渐变【等viewWillAppear调用后再进行】
//                return;
//            }
            [self sn_updateNavigationBarWithFromVC:fromVC toVC:toVC progress:persent];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
        }
        case UIGestureRecognizerStateEnded:{
        }
            break;
        default:
            
            break;
    }
}

#pragma mark - 处理中断
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __weak typeof (self) weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    if ([coor initiallyInteractive] == YES) {
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        // 状态回调都在控制器will生命周期前触发
        if ([sysVersion floatValue] >= 10) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        } else {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    if (popToVC.sn_keepBackgroundColor) { // pop到自定义的,在此触发干掉原导航模糊层
        [self sn_navBarBackgroundColor];
    } else {  // pop到原生的,需要对原生vc进行reset
        self.sn_dontKeepSNState++;
        [popToVC sn_reset];
        self.sn_dontKeepSNState--;
    }
    [self popToViewController:popToVC animated:YES];
    return YES;
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key){
        UIColor *curColor = [[context viewControllerForKey:key] sn_keepBackgroundColor];
        CGFloat curAlpha = [[context viewControllerForKey:key] sn_keepAlpha];
        UIViewController *targetVc = [context viewControllerForKey:key];
        targetVc.sn_navBarAlpha = curAlpha;
        targetVc.sn_navBarBackgroundColor = curColor;
    };
    if ([context isCancelled] == YES) { // 回到fromVc状态
        double cancelDuration = [context transitionDuration] * [context percentComplete];
        __weak typeof(self)weakSelf = self;
        weakSelf.sn_dontKeepSNState++; // 加锁
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.sn_dontKeepSNState--; // 解锁
            });
        }];
    } else { // 完成toVc剩下的动画
        __weak typeof(self)weakSelf = self;
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        } completion:^(BOOL finished) {
            UIColor *curColor = [[context viewControllerForKey:UITransitionContextToViewControllerKey] sn_keepBackgroundColor];
            CGFloat curAlpha = [[context viewControllerForKey:UITransitionContextToViewControllerKey] sn_keepAlpha];
            UIViewController *targetVc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
            weakSelf.sn_navBarAlpha = curAlpha;
            weakSelf.sn_navBarBackgroundColor = curColor;
            if (![targetVc sn_keepBackgroundColor]) { // pop到系统的要reset一下
                weakSelf.sn_dontKeepSNState++;
                [targetVc sn_reset];
                weakSelf.sn_dontKeepSNState--;
            }
        }];
    }
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



