//
//  UIViewController+WY.m
//  HeiPa
//
//  Created by wyman on 2017/8/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIViewController+WY.h"
#import "UIView+WY.h"

@implementation UIViewController (WY)

+ (instancetype)wy_currentDisplayViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [rootVC wy_lastPresentedViewController];
}

+ (instancetype)wy_currentDisplayViewControllerContainChildVc {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [rootVC wy_lastPresentedViewControllerContainChildVc];
}

- (UIViewController *)wy_lastPresentedViewController {
    if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)self;
        return [tabBarVC.selectedViewController wy_lastPresentedViewController];
    } else if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)self;
        UIViewController *lastVC = navVC.viewControllers.lastObject;
        return [lastVC wy_lastPresentedViewController];
    } else {
        if (self.presentedViewController) {
            return [self.presentedViewController wy_lastPresentedViewController];
        } else {
            return self;
        }
    }
}

- (UIViewController *)wy_lastPresentedViewControllerContainChildVc {
    if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)self;
        return [tabBarVC.selectedViewController wy_lastPresentedViewControllerContainChildVc];
    } else if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)self;
        UIViewController *lastVC = navVC.viewControllers.lastObject;
        return [lastVC wy_lastPresentedViewControllerContainChildVc];
    } else {
        if (self.presentedViewController) {
            return [self.presentedViewController wy_lastPresentedViewControllerContainChildVc];
        } else {
            if (self.childViewControllers.count) {
                for (UIViewController *vc in self.childViewControllers) {
                    // 假设vc有动画移动，未结束时调用次方法可能获取到之前的vc
                    // eg : vc1 -> vc2 的时刻调用，会获取到vc1， 开始vc1是布满window
                    //
                    //    => 这个是screen window
                    //   ||
                    // ---------------
                    // |      |      |
                    // |      |      |
                    // |      |      |
                    // |      |      |
                    // | vc1  | vc2  |
                    // |      |      |
                    // |      |      |
                    // |      |      |
                    // |      |      |
                    // --------------
                    
                    
                    if ([vc.view wy_isDisplayInScreen]) {
                        return [vc wy_lastPresentedViewControllerContainChildVc];
                    } else {
                        continue;
                    }
                }
                return self;
            } else {
                return self;
            }
        }
    }
}

@end
