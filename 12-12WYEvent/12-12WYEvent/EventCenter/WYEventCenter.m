//
//  WYEventCenter.m
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "WYEventCenter.h"
#import "WYEventCourier.h"


@implementation WYEventCenter

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

@end
