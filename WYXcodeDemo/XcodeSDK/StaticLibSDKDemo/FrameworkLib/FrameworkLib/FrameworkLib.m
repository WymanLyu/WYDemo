//
//  FrameworkLib.m
//  FrameworkLib
//
//  Created by wyman on 2017/7/24.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FrameworkLib.h"
#import <UIKit/UIKit.h>

@implementation FrameworkLib

- (void)lib_log {
    // 这样做是需要 Demo工程讲Bundle放在mainbundle下 使用绝对路径 否则URL=nil 而crash
//    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"FrameworkLibBundle" withExtension:@"Bundle"];
//    NSBundle *bundle= [NSBundle bundleWithURL:bundleURL];
    
    // lib工程 在build phase中添加对bundle的依赖，前提是加了个bundle的target 但是前提是
    NSBundle *bundle= [NSBundle bundleForClass:[self class]];
    
    UIImage *i = [UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil];
    NSLog(@"%@-%@", self.class, i);
}



@end
