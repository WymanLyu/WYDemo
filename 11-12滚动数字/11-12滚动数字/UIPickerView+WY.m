//
//  UIPickerView+WY.m
//  11-12滚动数字
//
//  Created by wyman on 2017/11/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIPickerView+WY.h"

@implementation UIPickerView (WY)

- (void)wy_clearSpearatorLine {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height < 1)
        {
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
}

- (UIView *)wy_getCacheView {
    return nil;
}

- (void)wy_saveCacheView:(UIView *)view {
    
}

@end
