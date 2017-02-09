//
//  NSObject+WYEvent.m
//  12-12WYEvent
//
//  Created by wyman on 2016/12/22.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "NSObject+WYEvent.h"
#import "WYEventCenter.h"
#import <objc/runtime.h>

static void *WYCustomObjectEventMarkingArrMKey = &WYCustomObjectEventMarkingArrMKey;

@implementation NSObject (WYEvent)

/** 发送事件 */
- (void)wy_sendEvent:(NSString *const)marking something:(id)something callBack:(void(^)(id *res))result {
    [WYEventCenter wy_sendEvent:marking withSender:self something:something callBack:result];
}

/** 监听事件 */
- (void)wy_observeHandingEvent:(NSString *const)marking handle:(void(^)(id noti, id *res))handle {
    [self.eventMarkingArrM addObject:marking];
    [WYEventCenter wy_observeHandingEvent:marking withTarget:self handle:handle];
}

/** 释放监听事件 */
- (void)wy_removeHandingEvent:(NSString *const)marking {
    [self.eventMarkingArrM removeObject:marking];
    [WYEventCenter wy_removeHandingEvent:marking];
}

- (void)wy_removeAllEvent {
    [self.eventMarkingArrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [WYEventCenter wy_removeHandingEvent:(NSString *)obj];
    }];
    [self.eventMarkingArrM removeAllObjects];
    self.eventMarkingArrM = nil;
}

- (NSMutableArray *)eventMarkingArrM {
    NSMutableArray *eventMarkingArrM = (NSMutableArray *)objc_getAssociatedObject(self,WYCustomObjectEventMarkingArrMKey);
    if (!eventMarkingArrM) {
        eventMarkingArrM = [NSMutableArray array];
    }
    return eventMarkingArrM;
}

- (void)setEventMarkingArrM:(NSMutableArray *)eventMarkingArrM {
    [self willChangeValueForKey:@"tempObject"];
    objc_setAssociatedObject(self, WYCustomObjectEventMarkingArrMKey, eventMarkingArrM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"tempObject"];
}

@end
