//
//  Father.m
//  11-9TestOverrideFunc
//
//  Created by wyman on 2017/11/9.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "Father.h"
#import <objc/runtime.h>

@implementation Father

void *eat_imp = nil;
+ (void)initialize {
    if ([NSStringFromClass(self) isEqualToString:@"Father"]) {
        IMP imp = class_getMethodImplementation(self, @selector(eat));
        eat_imp = imp;
    }
}

- (void)eat {
    IMP imp = class_getMethodImplementation([self class], @selector(eat));
    NSAssert((imp!=eat_imp), @"子类必须重写该方法");
}


@end
