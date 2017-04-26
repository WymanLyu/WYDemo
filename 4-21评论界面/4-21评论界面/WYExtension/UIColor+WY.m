//
//  UIColor+Extension.m
//  02-26Qz2D
//
//  Created by sialice on 16/2/27.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "UIColor+WY.h"

@implementation UIColor (WY)

+ (instancetype)wy_randomColor
{
    CGFloat r = (arc4random()%255)/255.0;
    CGFloat g = (arc4random()%255)/255.0;
    CGFloat b = (arc4random()%255)/255.0;
    
    return [self colorWithRed:r green:g blue:b alpha:1];
}


+ (UIColor *)wy_colorWithHexInt:(NSUInteger)hexInt alpha:(CGFloat)alpha {
    if (alpha > 1 || alpha < 0) {
        alpha = 1;
    }
    if (hexInt > 0xffffff) {
        hexInt = 0xffffff;
    }
    
    NSUInteger red = hexInt>>16;
    NSUInteger green = hexInt>>8 & 0x00ff;
    NSUInteger blue = hexInt & 0x0000ff;
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)wy_colorWithHexInt:(NSUInteger)hexInt {
    return [UIColor wy_colorWithHexInt:hexInt alpha:1];
}


@end
