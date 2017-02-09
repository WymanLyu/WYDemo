//
//  WYNotificationCourier.m
//  12-12WYEvent
//
//  Created by wyman on 2017/2/9.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "WYNotificationCourier.h"
#import "WYEvent.h"

@interface WYNotificationCourier ()

/** 存储执行block */
@property (nonatomic, strong) NSMutableDictionary <NSString *, WYEvent *> *wy_map;

@end

@implementation WYNotificationCourier

static WYNotificationCourier *shareCourier = nil;
+ (instancetype)shareCourier {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCourier = [[self alloc] init];
    });
    return shareCourier;
}

#pragma mark - 注册通知
- (void)registeNotificationName:(NSString *const)notiName {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiHandleFunction:) name:notiName object:nil];
}

- (void)notiHandleFunction:(NSNotification *)noti {
 
    // 取出发送者
    id sender = noti.object;
    NSString *notiName = noti.name;
    // marking 由 notiName 和 sender 共同决定
    NSString *marking = [NSString stringWithFormat:@"%@+%zd", notiName, [sender hash]];
    
    // 取出事件对象
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) return;
    [self handleEventForMarking:marking];
}

#pragma mark - 事件回调执行
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

#pragma mark - 事件保存
- (void)keepEventHandle:(void (^)(id, id *))handle forMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [WYEvent new];
        [self.wy_map setObject:event forKey:marking];
    }
    event.eventHandle = handle;
    // 弱引用target
    event.target = makeWeakReference(self);
}

- (void)keepFinishHandle:(void (^)(id *))handle forMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [WYEvent new];
        [self.wy_map setObject:event forKey:marking];
    }
    event.finish = handle;
    [self.wy_map setObject:event forKey:marking];
}

- (void)keepEventArg:(id)arg forMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [WYEvent new];
        [self.wy_map setObject:event forKey:marking];
    }
    event.noti = arg;
    [self.wy_map setObject:event forKey:marking];
}

- (void)keepEventTarget:(id)target forMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [WYEvent new];
        [self.wy_map setObject:event forKey:marking];
    }
    if (target) {
        event.target = makeWeakReference(target);
    } else {
        event.target = makeWeakReference(self);
    }
}

- (void)keepEventSender:(id)sender forMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [WYEvent new];
        [self.wy_map setObject:event forKey:marking];
    }
    if (sender) {
        event.sender = makeWeakReference(sender);
    } else {
        event.sender = makeWeakReference(self);
    }
}


#pragma mark - 事件删除
/** 移除事件回调 */
- (void)removerMarking:(NSString *)marking {
    WYEvent *event = [self.wy_map objectForKey:marking];
    if (!event) return;
    [self.wy_map removeObjectForKey:marking];
    event = nil;
}

#pragma mark - 存储事件的Map
- (NSMutableDictionary *)wy_map {
    if (!_wy_map) {
        _wy_map = [NSMutableDictionary dictionary];
    }
    return _wy_map;
}


@end
