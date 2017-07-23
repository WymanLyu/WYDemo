//
//  StaticLib.m
//  StaticLib
//
//  Created by wyman on 2017/7/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "StaticLib.h"
#include <UIKit/UIKit.h>

@implementation StaticLib

- (void)lib_log {
    // 这样做事需要 Demo工程讲Bundle放在mainbundle下
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"StaticLibBundle" withExtension:@"Bundle"];
    NSBundle *bundle= [NSBundle bundleWithURL:bundleURL];
    UIImage *i = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    NSLog(@"%@-%@", self.class, i);
}

@end
