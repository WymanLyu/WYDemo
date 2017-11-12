//
//  UINavigationBar+SimpleNavigationBar.h
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (SimpleNavigationBar)

#pragma mark - 拓展属性
/** 自定义背景视图 */
@property (nonatomic, strong) UIView *sn_customBarView;
/** 颜色 */
@property (nonatomic, strong) UIColor *sn_backgroundColor;
/** 透明度 */
@property (nonatomic, assign) CGFloat sn_alpha;
/** 模糊层是否隐藏 */
@property (nonatomic, assign) BOOL sn_visualEffectHidden;
///** 分割线是否隐藏 */
//@property (nonatomic, assign) BOOL sn_bottomLineHidden;
///** 增加高度 */
//@property (nonatomic, assign) float sn_translationY;

@property (nonatomic, copy) NSString *sn_ss;

#pragma mark - 操作
/** 自定义bar */
- (void)sn_setCustomBarView:(UIView *)customBar;
/** 重置操作 */
- (void)sn_reset;

@end
