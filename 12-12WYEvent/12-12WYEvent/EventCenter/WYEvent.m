//
//  WYEvent.m
//  12-12WYEvent
//
//  Created by wyman on 2017/2/9.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "WYEvent.h"

extern WeakReference makeWeakReference(id object) {
    __weak id weakref = object;
    return ^{
        //        __strong id ref = weakref;
        return weakref;
    };
}

extern id weakReferenceNonretainedObjectValue(WeakReference ref) {
    return ref ? ref() : nil;
}

@implementation WYEvent

@end
