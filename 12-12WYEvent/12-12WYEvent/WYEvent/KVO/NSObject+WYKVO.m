//
//  NSObject+WYKVO.m
//  12-12WYEvent
//
//  Created by wyman on 2017/3/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "NSObject+WYKVO.h"
#import <objc/runtime.h>

@implementation NSObject (WYKVO)

static void *WYKVOObserverKey = &WYKVOObserverKey;
static void *WYKVOTargetKey = &WYKVOTargetKey;

- (WYKVOObserver *)wy_kvoObserver {
    WYKVOObserver *_wy_kvoObserver = objc_getAssociatedObject(self, WYKVOObserverKey);
    if (!_wy_kvoObserver) {
        _wy_kvoObserver = [WYKVOObserver new];
        objc_setAssociatedObject(self, WYKVOObserverKey, _wy_kvoObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _wy_kvoObserver;
}

- (void)setWy_kvoObserver:(WYKVOObserver *)wy_kvoObserver {
    if (!wy_kvoObserver) return;
    objc_setAssociatedObject(self, WYKVOObserverKey, wy_kvoObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WYKVOTarget *)wy_kvoTarget {
    WYKVOTarget *_wy_kvoTarget = objc_getAssociatedObject(self, WYKVOTargetKey);
    if (!_wy_kvoTarget) {
        _wy_kvoTarget = [WYKVOTarget new];
         _wy_kvoTarget.wy_owner = self;
        objc_setAssociatedObject(self, WYKVOTargetKey, _wy_kvoTarget, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _wy_kvoTarget;
}

- (void)setWy_kvoTarget:(WYKVOTarget *)wy_kvoTarget {
    if (!wy_kvoTarget) return;
    objc_setAssociatedObject(self, WYKVOTargetKey, wy_kvoTarget, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
