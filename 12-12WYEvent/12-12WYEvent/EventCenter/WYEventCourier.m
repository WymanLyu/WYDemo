//
//  WYEventCourier.m
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "WYEventCourier.h"


typedef id (^WeakReference)(void);

WeakReference makeWeakReference(id object) {
    __weak id weakref = object;
    return ^{
//        __strong id ref = weakref;
        return weakref;
    };
}

id weakReferenceNonretainedObjectValue(WeakReference ref) {
    return ref ? ref() : nil;
}

@interface WYEvent : NSObject

@property (nonatomic, copy) void(^eventHandle)(id noti, id *res);
@property (nonatomic, copy) void(^eventBeforeHandle)(id noti, id *res);
@property (nonatomic, copy) void(^eventAfterHandle)(id noti, id *res);

@property (nonatomic, copy) void(^finish)(id *res);
@property (nonatomic, strong) id noti;

/** 监听者 */
@property (nonatomic, strong) WeakReference target;

@end

@interface WYEventCourier ()

/** 存储执行block */
@property (nonatomic, strong) NSMutableDictionary <NSString *, WYEvent *> *wy_map;


@end

@implementation WYEventCourier

static WYEventCourier *shareCourier = nil;
+ (instancetype)shareCourier {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCourier = [[self alloc] init];
    });
    return shareCourier;
}


// 执行
- (void)handleEventForMarking:(NSString *)marking {
    
    WYEvent *event = [self.wy_map objectForKey:marking];
    __block id res = nil;
    // 校验监听者是否移除了
    id target = weakReferenceNonretainedObjectValue(event.target);
    if (!target) {
        [self removerMarking:marking];
        goto Finish;
    }
    if (event.eventBeforeHandle) {
        event.eventBeforeHandle(event.noti, &res);
    }
    if (event.eventHandle) {
        event.eventHandle(event.noti, &res);
    }
    if (event.eventAfterHandle) {
        event.eventAfterHandle(event.noti, &res);
    }
Finish:
    if (event.finish) {
        event.finish(&res);
    }
}


// 保存
- (void)keepEventHandle:(void (^)(id, id *))handle forMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [WYEvent new];
    }
    event.eventHandle = handle;
    // 弱引用target
    event.target = makeWeakReference(self);
    [self.wy_map setObject:event forKey:marking];
}

- (void)keepFinishHandle:(void (^)(id *))handle forMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [WYEvent new];
    }
    event.finish = handle;
    // 弱引用target -- 发事件方无需监听者
//    event.target = makeWeakReference(self);
    [self.wy_map setObject:event forKey:marking];
}

- (void)keepEventArg:(id)arg forMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [WYEvent new];
    }
    event.noti = arg;
    // 弱引用target -- 发事件方无需监听者
//    event.target = makeWeakReference(self);
    [self.wy_map setObject:event forKey:marking];
}

// 有监听者
- (void)keepEventHandle:(void (^)(id, id *))handle withTarget:(id)target forMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [WYEvent new];
    }
    event.eventHandle = handle;
    // 弱引用target
    event.target = makeWeakReference(target);
    [self.wy_map setObject:event forKey:marking];
}

/** 移除事件回调 */
- (void)removerMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) return;
    [self.wy_map removeObjectForKey:marking];
}


- (NSMutableDictionary *)wy_map {
    if (!_wy_map) {
        _wy_map = [NSMutableDictionary dictionary];
    }
    return _wy_map;
}

@end



@implementation WYEvent : NSObject

@end










