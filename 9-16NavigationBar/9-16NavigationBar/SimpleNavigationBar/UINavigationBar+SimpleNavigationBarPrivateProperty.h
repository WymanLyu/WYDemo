//
//  UINavigationBar+SimpleNavigationBarPrivateProperty.h
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (SimpleNavigationBarPrivateProperty)

#pragma mark - 私有视图
/** 背景视图 */
- (UIView *)_sn_UIBarBackground;
/** 底部分割线 */
- (UIView *)_sn_UIImageViewBottomLine;
/** 模糊层 */
- (UIView *)_sn_UIVisualEffectView;

/** titleItemView */
- (UIView *)_sn_UINavigationItemView;
/** 左侧文本ItemView */
- (UIView *)_sn_UINavigationItemButtonView;
/** 左侧返回视图 */
- (UIView *)_sn_UINavigationBarBackIndicatorView;


@end
