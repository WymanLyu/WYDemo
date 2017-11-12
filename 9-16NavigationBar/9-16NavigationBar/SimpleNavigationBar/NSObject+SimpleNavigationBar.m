//
//  NSObject+SimpleNavigationBar.m
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "NSObject+SimpleNavigationBar.h"

@implementation NSObject (SimpleNavigationBar)

- (BOOL)sn_isKindOfClassString:(NSString *)classString {
    return [NSStringFromClass([self class]) isEqualToString:classString];
}

@end
