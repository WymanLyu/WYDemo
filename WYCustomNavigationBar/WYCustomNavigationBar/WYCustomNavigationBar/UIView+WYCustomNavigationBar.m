//
//  UIView+WYCustomNavigationBar.m
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIView+WYCustomNavigationBar.h"
#import <objc/runtime.h>

static const void *kWYAddSubViewsFinishCallBackKey = &kWYAddSubViewsFinishCallBackKey;

@implementation UIView (WYCustomNavigationBar)

+ (void)load {
    
    // runtime加载类时hook 原有的adddSubViews，在结束时回调block
    Method oldViewDidLoadMethod = class_getInstanceMethod([self class], @selector(addSubview:));
    Method newViewDidLoadMethod = class_getInstanceMethod([self class], @selector(wy_WYCustomNavigationBar_addSubview:));
    method_exchangeImplementations(oldViewDidLoadMethod, newViewDidLoadMethod);
    
}

#pragma mark - 关联回调block，setter/getter方法

- (void)setWy_addSubViewsFinishCallBack:(void (^)())wy_addSubViewsFinishCallBack {
    objc_setAssociatedObject(self, kWYAddSubViewsFinishCallBackKey, wy_addSubViewsFinishCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())wy_addSubViewsFinishCallBack {
    return objc_getAssociatedObject(self, kWYAddSubViewsFinishCallBackKey);
}

#pragma mark - hook方法中处理回调

- (void)wy_WYCustomNavigationBar_addSubview:(UIView *)subView {
    
    // 1.添加子控件
    [self wy_WYCustomNavigationBar_addSubview:subView];
    
    // 2.回调
    if (self.wy_addSubViewsFinishCallBack) {
        self.wy_addSubViewsFinishCallBack();
    }
}


@end
