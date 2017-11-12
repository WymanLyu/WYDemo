//
//  UIViewController+TYMediaCenter.m
//  3-10设计要看button
//
//  Created by wyman on 2017/9/29.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIViewController+TYMediaCenter.h"
#import <objc/runtime.h>
#import "UINavigationController+TYMediaCenter.h"

@implementation UIViewController (TYMediaCenter)

static void *bottomPlayViewValueKey = &bottomPlayViewValueKey;
- (TYBottomPlayView *)bottomPlayView {
    TYBottomPlayView *bottomPlayView = objc_getAssociatedObject(self, bottomPlayViewValueKey);
    if (!bottomPlayView) {
        CGFloat w = 34;
        CGFloat margin = 5;
        bottomPlayView = [[TYBottomPlayView alloc] initWithFrame:CGRectMake(margin, margin, w, w)];
        bottomPlayView.hidden = YES;
        objc_setAssociatedObject(self, bottomPlayViewValueKey, bottomPlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.navigationController.bottomPlayContainView addSubview:bottomPlayView];
        [self.navigationController.bottomPlayContainView bringSubviewToFront:bottomPlayView];
    }
    return bottomPlayView;
}


@end
