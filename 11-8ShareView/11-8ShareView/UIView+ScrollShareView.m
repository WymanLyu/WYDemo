//
//  UIView+ScrollShareView.m
//  11-8ShareView
//
//  Created by wyman on 2017/11/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIView+ScrollShareView.h"

@implementation UIView (ScrollShareView)

- (UIImage *)wy_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)wy_contentImage{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)self.layer.contents];
}

- (void)setWy_contentImage:(UIImage *)contentImage{
    self.layer.contents = (__bridge id)contentImage.CGImage;;
}

@end
