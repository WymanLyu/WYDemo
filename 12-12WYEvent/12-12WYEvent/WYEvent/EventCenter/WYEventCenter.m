//
//  WYEventCenter.m
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "WYEventCenter.h"
#import "WYEventCourier.h"
#import "WYNotificationCourier.h"
#import "WYKVOCourier.h"

@implementation WYEventCenter

#pragma mark - 自定义通讯方式
/** 发送事件 */
+ (void)wy_sendEvent:(NSString *const)marking withSender:(id)sender something:(id)something callBack:(void (^)(__autoreleasing id *))resultCallBack {
    
    if (sender) {
        [[WYEventCourier shareCourier] keepEventSender:sender forMarking:marking];
    } else {
        [[WYEventCourier shareCourier] keepEventSender:[WYEventCourier shareCourier] forMarking:marking];
    }
    [[WYEventCourier shareCourier] keepEventArg:something forMarking:marking];
    [[WYEventCourier shareCourier] keepFinishHandle:resultCallBack forMarking:marking];
    [[WYEventCourier shareCourier] handleEventForMarking:marking];
}

/** 监听事件 */
+ (void)wy_observeHandingEvent:(NSString *const)marking withTarget:(id)target handle:(void(^)(id noti, id *res))handle {
    if (target) {
        [[WYEventCourier shareCourier] keepEventTarget:target forMarking:marking];
    } else {
        [[WYEventCourier shareCourier] keepEventTarget:[WYEventCourier shareCourier] forMarking:marking];
    }
    [[WYEventCourier shareCourier] keepEventHandle:handle forMarking:marking];
}

/** 释放监听事件 */
+ (void)wy_removeHandingEvent:(NSString *const)marking {
    [[WYEventCourier shareCourier] removerMarking:marking];
}

#pragma mark - 系统通知方式
/** 发送事件 */
+ (void)wy_postNotificationName:(NSString *const)notiName withSender:(id)sender userInfo:(NSDictionary *)aUserInfo finishHandle:(void (^)())finishCallBack {
    
    // marking 由 notiName 和 sender 共同决定
    NSString *marking = [NSString stringWithFormat:@"%@+%zd", notiName, [sender hash]];
    
    // 保存信息
    [[WYNotificationCourier shareCourier] keepEventSender:sender forMarking:marking finishHandle:finishCallBack];
    [[WYNotificationCourier shareCourier] registeNotificationName:notiName];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:sender userInfo:aUserInfo];
}

/** 发送通知 */
+ (void)wy_observeNotificationName:(NSString *const)notiName fromSender:(id)sender withObserve:(id)observe handle:(void(^)(NSNotification *noti))handle{
    
    // marking 由 notiName 和 sender 共同决定
    NSString *marking = [NSString stringWithFormat:@"%@+%zd", notiName, [sender hash]];
    [[WYNotificationCourier shareCourier] keepEventObserve:observe forMarking:marking eventHandle:handle];
    [[NSNotificationCenter defaultCenter] addObserver:observe selector:@selector(wy_removeHandingEvent:) name:notiName object:sender];
}

#pragma mark - KVO方式
/** 监听某个属性 */
+ (void)wy_observePath:(NSString *)path observe:(id)observe target:(id)target options:(NSKeyValueObservingOptions)options change:(void(^)(NSDictionary<NSKeyValueChangeKey,id> *))handle {
    [[WYKVOCourier shareCourier] keepKVOObserve:observe target:target forPath:path options:options eventHandle:handle];
}

@end
