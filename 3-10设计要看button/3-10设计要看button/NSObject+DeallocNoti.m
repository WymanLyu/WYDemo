//
//  NSObject+DeallocNoti.m
//  3-10设计要看button
//
//  Created by wyman on 2017/9/29.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "NSObject+DeallocNoti.h"
#import <objc/runtime.h>

@implementation NSObject (DeallocNoti)

static void *deallocNotiObjValueKey = &deallocNotiObjValueKey;
- (DeallocNotiObj *)deallocNotiObj {
    DeallocNotiObj *deallocNotiObj = objc_getAssociatedObject(self, deallocNotiObjValueKey);
    if (!deallocNotiObj) {
        deallocNotiObj = [[DeallocNotiObj alloc] init];
        objc_setAssociatedObject(self, deallocNotiObjValueKey, deallocNotiObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return deallocNotiObj;
}

@end
