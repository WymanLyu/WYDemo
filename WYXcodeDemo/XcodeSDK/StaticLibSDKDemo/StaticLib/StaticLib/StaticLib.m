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
    [[NSBundle mainBundle] URLForResource:@"back" withExtension:@"png"];
//    [NSBundle bundleForClass:<#(nonnull Class)#>]
//    [UIImage imageNamed::@"back" inBundle:<#(nullable NSBundle *)#> compatibleWithTraitCollection:nil];
    NSLog(@"%@-%@", self.class, [UIImage imageNamed:@"back"]);
}

@end
