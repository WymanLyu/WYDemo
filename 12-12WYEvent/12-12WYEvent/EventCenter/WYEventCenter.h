//
//  WYEventCenter.h
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

////////////////////*------*------*/////////////////////////////////
/// WYEventCenter 事件中心对象，该结构提供了如下作用：
///
/// 1.自定义通信方式：
///     + 发送事件，传入发送者和发送完毕后的回调
///     + 监听事件, 传入监听者和接收事件后的回调
///
/// 2.通知通信方式：
///     + 发起通知，传入通知发送者
///     + 监听通知，传入通知监听者和接收通知的回调
///
/// 3.KVO:
///     + 监听kvo,传入kvo的监听者和被监听者，以及触发的回调
///
/// 最后，该事件中心强引用事件携带者【事件携带者使用Map强引用保存事件对象(包含了事件的回调)】，所以不要强引用此对象！！！！！！！！！
///////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface WYEventCenter : NSObject

/** 发送事件 -- 默认发送者是WYEventCourier*/
+ (void)wy_sendEvent:(NSString *const)marking withSender:(id)sender something:(id)something callBack:(void(^)(id *res))resultCallBack;

/** 监听事件 -- 默认监听者是WYEventCourier */
+ (void)wy_observeHandingEvent:(NSString *const)marking withTarget:(id)target handle:(void(^)(id noti, id *res))handle;

/** 释放监听事件 */
+ (void)wy_removeHandingEvent:(NSString *const)marking;

//+ (void)wy_observeBeforeHandleEvent:(NSString *const)marking handle:(void(^)(id noti, id res))something;
//+ (void)wy_observeAfterHandleEvent:(NSString *const)marking handle:(void(^)(id noti, id re))something;

@end
