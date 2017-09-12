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
- (void)sn_setBottomLineHidden:(BOOL)hidden;
- (void)sn_reset;

@property (nonatomic, assign) CGFloat sn_alpha;

@end


@interface UIViewController (SimpleNavgationBar)

@property (nonatomic, assign) CGFloat sn_navBarAlpha;
@property (nonatomic, strong) UIColor *sn_navBarBackgroundColor;
@property (nonatomic, assign) BOOL sn_navBarBottomLineHidden;
- (void)sn_reset;

@end
