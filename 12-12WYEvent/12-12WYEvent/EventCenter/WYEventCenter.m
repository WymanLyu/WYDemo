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
- (void)wy_postNotificationName:(NSString *const)notiName withSender:(id)sender userInfo:(NSDictionary *)aUserInfo finishHandle:(void (^)(__autoreleasing id *))finishCallBack {
    
    // marking 由 notiName 和 sender 共同决定
    NSString *marking = [NSString stringWithFormat:@"%@+%zd", notiName, [sender hash]];
    [[WYNotificationCourier shareCourier] keepEventSender:sender forMarking:marking];
    [[WYNotificationCourier shareCourier] keepEventArg:aUserInfo forMarking:marking];
    [[WYNotificationCourier shareCourier] keepFinishHandle:finishCallBack forMarking:marking];
    [[WYNotificationCourier shareCourier] registeNotificationName:notiName];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:sender userInfo:aUserInfo];
}

/** 发送通知 */
- (void)wy_observeNotificationName:(NSString *const)notiName fromSender:(id)sender withObserve:(id)observe handle:(void(^)(NSNotification *noti))handle{
    
    // marking 由 notiName 和 sender 共同决定
    NSString *marking = [NSString stringWithFormat:@"%@+%zd", notiName, [sender hash]];
    [[WYNotificationCourier shareCourier] keepEventTarget:observe forMarking:marking];
    
    [[NSNotificationCenter defaultCenter] addObserver:observe selector:@selector(wy_removeHandingEvent:) name:notiName object:sender];
}

@end
