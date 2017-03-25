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
#import "NSObject+WYKVO.h"

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

#pragma mark - 系统通知方式
/** 发送事件 */
- (void)wy_postNotificationName:(NSString *const)notiName userInfo:(NSDictionary *)aUserInfo finishHandle:(void (^)())finishCallBack {
    [WYEventCenter wy_postNotificationName:notiName withSender:self userInfo:aUserInfo finishHandle:finishCallBack];
}

/** 发送通知 */
- (void)wy_observeNotificationName:(NSString *const)notiName fromSender:(id)sender handle:(void(^)(NSNotification *noti))handle {
    [WYEventCenter wy_observeNotificationName:notiName fromSender:sender withObserve:self handle:handle];
}

#pragma mark - KVO方式

/** 监听某个属性 */
- (void)wy_observePath:(NSString *)path target:(NSObject *)target options:(NSKeyValueObservingOptions)options change:(void(^)(NSDictionary<NSKeyValueChangeKey,id> * change))handle {
    [WYEventCenter wy_observePath:path observe:[self wy_kvoObserver] target:target options:options change:handle];
}

@end
