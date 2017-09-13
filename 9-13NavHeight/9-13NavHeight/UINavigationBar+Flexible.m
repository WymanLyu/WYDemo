//
//  UINavigationBar+Flexible.m
//  9-13NavHeight
//
//  Created by wyman on 2017/9/13.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UINavigationBar+Flexible.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Flexible)
//
//static char translationYKey;
//// 垂直尺寸
//- (void)setFn_translationY:(float)fn_translationY {
//    //    self.transform = CGAffineTransformMakeTranslation(0, fn_translationY); 1
//    
//    objc_setAssociatedObject(self, &translationYKey, @(fn_translationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    CGRect f = self.frame;
//    f.size.height = 44+fn_translationY;
//    self.frame = f;
//    
//}
//- (float)fn_translationY {
//    return [objc_getAssociatedObject(self, &translationYKey) floatValue];
//    
//    //    return self.transform.ty;
//}
//
//
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGSize newSize = CGSizeMake(self.frame.size.width,self.fn_translationY+44);
//    NSLog(@"%@", NSStringFromCGSize(newSize));
//    return newSize;
//}

@end
