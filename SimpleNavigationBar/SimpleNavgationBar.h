//
//  SimpleNavgationBar.h
//  HeiPa
//
//  Created by wyman on 2017/9/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (SimpleNavgationBar)

@property (nonatomic, assign) CGFloat sn_navBarAlpha;
@property (nonatomic, strong) UIColor *sn_navBarBackgroundColor;
@property (nonatomic, assign) BOOL sn_navBarBottomLineHidden;
@property (nonatomic , assign) UIBarStyle sn_barStyle;

@property (nonatomic, assign) float sn_translationY; // 有问题，待解决

@property (nonatomic, assign) UIStatusBarStyle sn_statusBarStyle;
@property (nonatomic, assign) BOOL sn_statusBarHidden;
@property (nonatomic, strong) UIColor *sn_statusBarBackgroundColor;

- (void)sn_reset;

@end




