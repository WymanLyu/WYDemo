//
//  WYCustomNavgationBar.h
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYCustomNavgationBar : UIView

/** 返回按钮点击 */
@property (nonatomic, strong) void(^customNavgationBackClick)();

/** 返回按钮 */
@property (nonatomic, readonly, weak) UIButton *backBtn;

/** 模糊层 */
@property (nonatomic, readonly, weak) UIVisualEffectView *blurView;

/** 下边界线 */
@property (nonatomic, readonly, weak) UIView *lineView;

/** 标题 */
@property (nonatomic, weak) UILabel *titleLbl;

@end

#pragma mark - 统一导航样式配置类
typedef void(^CustomBarSettingBlock)(UIViewController *currentVc);

@interface WYCustomNavgationBarAppearance : NSObject

// 获取配置customBarSetting，key是classString，也可能是@"ALL"，value是block：void(^)(UIViewController *currentVc)
+ (NSMutableDictionary *)appearanceDict;

// 配置viewControllerClass的导航类型控制器的，自定义导航样式，会在viewdidload之前调用customBarSetting
+ (void)appearanceWithClass:(Class)viewControllerClass customBar:(void(^)(UIViewController *currentVc))customBarSetting;

@end
