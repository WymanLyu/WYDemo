//
//  UIPickerView+WY.h
//  11-12滚动数字
//
//  Created by wyman on 2017/11/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPickerView (WY)

- (void)wy_clearSpearatorLine;

- (UIView *)wy_getCacheView;
- (void)wy_saveCacheView:(UIView *)view;

@end
