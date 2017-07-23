//
//  LibTest.m
//  PrivateLib
//
//  Created by wyman on 2017/7/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "LibTest.h"
#import <UIKit/UIKit.h>

@implementation LibTest

- (void)lib_print {
    NSLog(@"%@--%@", self.class, [UIImage imageNamed:@"back"]);
}

@end
