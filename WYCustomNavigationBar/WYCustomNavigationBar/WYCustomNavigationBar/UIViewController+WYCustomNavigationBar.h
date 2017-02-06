//
//  UIViewController+WYCustomNavigationBar.h
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCustomNavgationBar.h"

@interface UIViewController (WYCustomNavigationBar)

/** 自定义导航栏 */
@property (nonatomic, weak) WYCustomNavgationBar *wy_navgationBar;

/** 全屏侧滑开关 */
@property (nonatomic, assign) BOOL wy_fullScreenPopGestureEnabled;

@end
