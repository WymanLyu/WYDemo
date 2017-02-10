//
//  WYNotificationCourier.m
//  12-12WYNotificationEvent
//
//  Created by wyman on 2017/2/9.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "WYNotificationCourier.h"
#import "WYNotificationEvent.h"

@interface WYNotificationCourier ()

/** 存储执行block */
@property (nonatomic, strong) NSMutableDictionary <NSString *, WYNotificationEvent *> *wy_map;

/** 已经注册的通知 */
@property (nonatomic, strong) NSMutableArray *notiArrM;

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
    
    // 只监听一次就好了
    if ([self.notiArrM containsObject:notiName]) return;
    [self.notiArrM addObject:notiName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiHandleFunction:) name:notiName object:nil];
}

- (void)notiHandleFunction:(NSNotification *)noti {
    
    // 取出发送者
    id sender = noti.object;
    NSString *notiName = noti.name;
    
    // marking 由 notiName 和 sender 共同决定, 取出对应的事件发送给所有监听者
    NSString *marking = [NSString stringWithFormat:@"%@+%zd", notiName, [sender hash]];
    // 取出事件对象
    WYNotificationEvent *event = [self.wy_map objectForKey:marking];
    if (!event) return;
    [self handleEventForMarking:marking withNoti:noti];
    
    // marking 由 notiName 和 sender 共同决定 ,执行监听nil的所有监听者的回调
    NSString *marking2 = [NSString stringWithFormat:@"%@+0", notiName];
    // 取出事件对象
    WYNotificationEvent *event2 = [self.wy_map objectForKey:marking2];
    if (!event2) {
        goto Finish;
    };
    [self handleEventForMarking:marking2 withNoti:noti];
    
    // 执行结束的回调
Finish:
    if (event.finishHandle) {
        event.finishHandle();
    }
}

#pragma mark - 事件信息保存
/** 保存接受者和回调 */
- (void)keepEventObserve:(id)observe forMarking:(NSString *)marking eventHandle:(void(^)(id noti))handle {
    WYNotificationEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [[WYNotificationEvent alloc] init];
        [self.wy_map setObject:event forKey:marking];
    }
    WeakReference weakObserve  = makeWeakReference(self);
    if (observe) {
      weakObserve  = makeWeakReference(observe);
    }
    [event.observeDictM setObject:handle forKey:weakObserve];
}

/** 保存发送者 */
- (void)keepEventSender:(id)sender forMarking:(NSString *)marking finishHandle:(void(^)())finishHandle {
    WYNotificationEvent *event = [self.wy_map objectForKey:marking];
    if (!event) {
        event = [[WYNotificationEvent alloc] init];
        [self.wy_map setObject:event forKey:marking];
    }
    if (sender) {
        event.sender = makeWeakReference(sender);
    } else {
        event.sender = makeWeakReference(self);
    }
    event.finishHandle = finishHandle;
}

#pragma mark - 事件回调执行
// 执行
- (void)handleEventForMarking:(NSString *)marking withNoti:(NSNotification *)noti {
    
    WYNotificationEvent *event = [self.wy_map objectForKey:marking];
    
    __block NSMutableArray *deleteArr = [NSMutableArray array];
    
    // 执行所有监听者的回调
    [event.observeDictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        WeakReference observe = weakReferenceNonretainedObjectValue(key);
        void(^handle)(id noti) = (void(^)(id noti))obj;
        if (observe) { // 监听者还在则执行回调
            if (handle) {
                handle(noti);
            }
        } else {
            [deleteArr addObject:key];
        }
    }];
    
    // 删除监听者挂了的block
    for (WeakReference key in deleteArr) {
        [event.observeDictM removeObjectForKey:key];
    }
    
}

#pragma mark - 事件删除
/** 移除事件回调 */
- (void)removerMarking:(NSString *)marking {
    WYNotificationEvent *event = [self.wy_map objectForKey:marking];
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

- (NSMutableArray *)notiArrM {
    if (!_notiArrM) {
        _notiArrM = [NSMutableArray array];
    }
    return _notiArrM;
}


@end
