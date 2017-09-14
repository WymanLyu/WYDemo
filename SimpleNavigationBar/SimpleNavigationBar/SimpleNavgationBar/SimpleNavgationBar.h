//
//  SimpleNavgationBar.h
//  HeiPa
//
//  Created by wyman on 2017/9/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SimpleNavgationBar)

@property (nonatomic, assign) CGFloat sn_navBarAlpha;
@property (nonatomic, strong) UIColor *sn_navBarBackgroundColor;
@property (nonatomic, assign) BOOL sn_navBarBottomLineHidden;
@property (nonatomic , assign) UIBarStyle sn_barStyle;
@property (nonatomic, assign) float sn_translationY;

@property (nonatomic, assign) UIStatusBarStyle sn_statusBarStyle;
@property (nonatomic, assign) BOOL sn_statusBarHidden;
@property (nonatomic, strong) UIColor *sn_statusBarBackgroundColor;

@property (nonatomic, strong) UIView *sn_customBar;
@property (nonatomic, assign) BOOL sn_smoothTransitionToCustomBar;// 侧滑有bug，慎用

- (void)sn_navBarHidden:(BOOL)animated;
- (void)sn_navBarShow:(BOOL)animated;
- (void)sn_openScreenPop; // 开启侧滑

- (void)sn_reset;

@end




