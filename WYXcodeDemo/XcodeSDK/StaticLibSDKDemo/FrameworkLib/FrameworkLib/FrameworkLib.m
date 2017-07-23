//
//  FrameworkLib.m
//  FrameworkLib
//
//  Created by wyman on 2017/7/24.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FrameworkLib.h"

@implementation FrameworkLib

- (void)print_x86
{
    
    // 这样做事需要 Demo工程讲Bundle放在mainbundle下
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"StaticLibBundle" withExtension:@"Bundle"];
    NSBundle *bundle= [NSBundle bundleWithURL:bundleURL];
    UIImage *i = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    NSLog(@"%@-%@", self.class);
}


@end
