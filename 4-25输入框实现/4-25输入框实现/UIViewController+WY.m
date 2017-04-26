//
//  UIViewController+WY.m
//  4-21评论界面
//
//  Created by wyman on 2017/4/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIViewController+WY.h"

@implementation UIViewController (WY)

+ (instancetype)wy_currentDisplayViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [rootVC wy_lastPresentedViewController];
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

@end
