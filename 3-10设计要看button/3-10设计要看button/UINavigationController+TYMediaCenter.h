//
//  UINavigationController+TYMediaCenter.h
//  3-10设计要看button
//
//  Created by wyman on 2017/9/29.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TYMediaCenter)

@property (nonatomic, strong, readonly) UIView *bottomPlayContainView;

- (void)afterCallSuperPush:(UIViewController *)viewController;

@end
