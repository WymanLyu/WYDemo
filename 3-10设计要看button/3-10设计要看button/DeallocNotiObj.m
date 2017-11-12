//
//  DeallocNotiObj.m
//  3-10设计要看button
//
//  Created by wyman on 2017/9/29.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "DeallocNotiObj.h"

NSString * const DeallocNotification = @"DeallocNotification";

@implementation DeallocNotiObj

- (void)dealloc {
    if (self.deallocCallback) {
        self.deallocCallback(self);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DeallocNotification object:self];
}

@end
