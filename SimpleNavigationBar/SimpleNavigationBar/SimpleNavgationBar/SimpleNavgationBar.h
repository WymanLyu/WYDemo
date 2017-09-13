//
//  SimpleNavgationBar.h
//  HeiPa
//
//  Created by wyman on 2017/9/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UINavigationBar (SimpleNavgationBar)

- (void)sn_setBackgroundColor:(UIColor *)backgroundColor;
//- (void)sn_setBottomLineHidden:(BOOL)hidden;
- (void)sn_reset;

@property (nonatomic, assign) CGFloat sn_alpha;
@property (nonatomic, assign) BOOL sn_bottomLineHidden;

@end


@interface UIViewController (SimpleNavgationBar)

@property (nonatomic, assign) CGFloat sn_navBarAlpha;
@property (nonatomic, strong) UIColor *sn_navBarBackgroundColor;
@property (nonatomic, assign) BOOL sn_navBarBottomLineHidden;
@property (nonatomic, strong) UIColor *sn_keepBackgroundColor; // 保存的背景色
@property (nonatomic, assign) CGFloat sn_keepAlpha;            // 保存的透明度

- (void)sn_reset;

- (void)sn_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress;

@end

@interface UINavigationController (SimpleNavgationBar)

@property (nonatomic, assign) BOOL sn_dontKeepSNState; // YES标示不要记录bar状态

@end


@interface UIColor (SimpleNavgationBar)
+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent;
@end


