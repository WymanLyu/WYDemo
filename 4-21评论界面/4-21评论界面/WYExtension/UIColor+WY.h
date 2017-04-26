//
//  UIColor+Extension.h
//  02-26Qz2D
//
//  Created by sialice on 16/2/27.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WY)

// 随机颜色
+ (instancetype)wy_randomColor;

+ (UIColor *)wy_colorWithHexInt:(NSUInteger)hexInt alpha:(CGFloat)alpha;
+ (UIColor *)wy_colorWithHexInt:(NSUInteger)hexInt;

@end
