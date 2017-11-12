//
//  UINavigationController+TYMediaCenter.m
//  3-10设计要看button
//
//  Created by wyman on 2017/9/29.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UINavigationController+TYMediaCenter.h"
#import "UIViewController+TYMediaCenter.h"
#import "NSObject+DeallocNoti.h"
#import <objc/runtime.h>

@interface UINavigationController ()

@property (nonatomic, strong) NSMutableArray *visibleList;

@end

@implementation UINavigationController (TYMediaCenter)

static void *bottomPlayContainViewValueKey = &bottomPlayContainViewValueKey;
- (UIView *)bottomPlayContainView {
    UIView *bottomPlayContainView = objc_getAssociatedObject(self, bottomPlayContainViewValueKey);
    if (!bottomPlayContainView) {
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        CGFloat w = 44;
        CGFloat margin = 20;
        bottomPlayContainView = [[UIView alloc] initWithFrame:CGRectMake(screenW-w-margin, screenH-64-margin, w, w)];
        objc_setAssociatedObject(self, bottomPlayContainViewValueKey, bottomPlayContainView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.view addSubview:bottomPlayContainView];
        bottomPlayContainView.backgroundColor = [UIColor clearColor];
    }
    return bottomPlayContainView;
}

static void *visibleListValueKey = &visibleListValueKey;
- (NSMutableArray *)visibleList {
    NSMutableArray *visibleList = objc_getAssociatedObject(self, visibleListValueKey);
    if (!visibleList) {
        visibleList = [NSMutableArray array];
        objc_setAssociatedObject(self, visibleListValueKey, visibleList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return visibleList;
}

- (void)afterCallSuperPush:(UIViewController *)viewController {
    // 隐藏控制器栈底的悬浮【本来显示着的隐藏】
    for (UIView *bottomSubView in self.bottomPlayContainView.subviews) {
        if (!bottomSubView.hidden) {
            bottomSubView.hidden = YES;
            [self.visibleList addObject:bottomSubView];
        }
    }
    // 加载栈顶的悬浮按钮
    [self.bottomPlayContainView bringSubviewToFront:viewController.bottomPlayView];
    // 监听栈顶控制器的移除
    __weak typeof(self)weakSelf = self;
    viewController.deallocNotiObj.deallocCallback = ^(DeallocNotiObj *deallocObj) {
        [weakSelf afterCallSuperPop];
    };
    // 设置事件响应
    self.bottomPlayContainView.userInteractionEnabled = !self.bottomPlayContainView.subviews.lastObject.hidden;
}

- (void)afterCallSuperPop {
    // 移除现有的
    [self.bottomPlayContainView.subviews.lastObject removeFromSuperview];
    // 显示栈顶下面的悬浮按钮【被隐藏了的显示出来】
    if ([self.visibleList containsObject:self.bottomPlayContainView.subviews.lastObject]) {
        [self.bottomPlayContainView.subviews.lastObject setHidden:NO];
    }
    // 设置事件响应
    self.bottomPlayContainView.userInteractionEnabled = !self.bottomPlayContainView.subviews.lastObject.hidden;
}

@end
