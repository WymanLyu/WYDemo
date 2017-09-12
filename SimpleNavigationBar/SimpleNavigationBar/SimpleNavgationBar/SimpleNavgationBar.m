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

static char overlayKey;
static char alphaKey;
- (UIView *)overlay {
    UIView *overlay = objc_getAssociatedObject(self, &overlayKey);
    if (!overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        overlay.userInteractionEnabled = NO;
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [self setOverlay:overlay];
        [[self.subviews firstObject] insertSubview:overlay atIndex:0];
    }
    [[self.subviews firstObject] insertSubview:overlay atIndex:0];
    return overlay;
}

- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sn_setBackgroundColor:(UIColor *)backgroundColor {
    self.overlay.backgroundColor = backgroundColor;
}

- (void)sn_setTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)sn_reset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    [self sn_setBottomLineHidden:NO];
}

- (void)sn_setBottomLineHidden:(BOOL)hidden {
    UIImage *shadowImg = nil;
    if (hidden) shadowImg=[[UIImage alloc] init];
    self.shadowImage = shadowImg;
}

- (CGFloat)sn_alpha {
    NSNumber *alphaNumber = (NSNumber *)objc_getAssociatedObject(self, &alphaKey);
    return [alphaNumber floatValue];
}

- (void)setSn_alpha:(CGFloat)sn_alpha {
    objc_setAssociatedObject(self, &alphaKey, @(sn_alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.overlay.alpha = sn_alpha;
}

@end

@implementation UIViewController (SimpleNavgationBar)

// 透明度
- (void)setSn_navBarAlpha:(CGFloat)sn_navBarAlpha {
    [self.navigationController.navigationBar setSn_alpha:sn_navBarAlpha];
}
- (CGFloat)sn_navBarAlpha {
    return self.navigationController.navigationBar.sn_alpha;
}

// 背景色
- (void)setSn_navBarBackgroundColor:(UIColor *)sn_navBarBackgroundColor {
    [self.navigationController.navigationBar sn_setBackgroundColor:sn_navBarBackgroundColor];
}
- (UIColor *)sn_navBarBackgroundColor {
    return self.navigationController.navigationBar.overlay.backgroundColor;
}

// 底部条
- (void)setSn_navBarBottomLineHidden:(BOOL)sn_navBarBottomLineHidden {
    [self.navigationController.navigationBar sn_setBottomLineHidden:sn_navBarBottomLineHidden];
}
- (BOOL)sn_navBarBottomLineHidden {
    return self.navigationController.sn_navBarBottomLineHidden;
}

- (void)sn_reset {
    [self.navigationController.navigationBar sn_reset];
}


@end
