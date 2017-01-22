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
+ (void)wy_sendEvent:(NSString *const)marking something:(id)something callBack:(void(^)(id *res))resultCallBack {

    [[WYEventCourier shareCourier] keepEventArg:something forMarking:marking];
    [[WYEventCourier shareCourier] keepFinishHandle:resultCallBack forMarking:marking];
    [[WYEventCourier shareCourier] handleEventForMarking:marking];
}

+ (void)wy_sendEvent:(NSString *const)marking withTarget:(id)target something:(id)something callBack:(void(^)(id *res))resultCallBack {
    [[WYEventCourier shareCourier] keepEventArg:something forMarking:marking];
    [[WYEventCourier shareCourier] keepFinishHandle:resultCallBack forMarking:marking];
    [[WYEventCourier shareCourier] handleEventForMarking:marking];
}

/** 监听事件 */
+ (void)wy_observeHandingEvent:(NSString *const)marking handle:(void(^)(id noti, id *res))handle {
    [[WYEventCourier shareCourier] keepEventHandle:handle forMarking:marking];
}

/** 释放监听事件 */
+ (void)wy_removeHandingEvent:(NSString *const)marking {
    [[WYEventCourier shareCourier] removerMarking:marking];
}


/** 有监听者的监听事件 */
+ (void)wy_observeHandingEvent:(NSString *const)marking withTarget:(id)target handle:(void(^)(id noti, id *res))handle {
    [[WYEventCourier shareCourier] keepEventHandle:handle withTarget:target forMarking:marking];
}

@end
