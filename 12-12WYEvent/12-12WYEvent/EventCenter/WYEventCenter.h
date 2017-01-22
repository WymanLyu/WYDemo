//
//  WYEventCenter.h
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYEventCenter : NSObject

/** 发送事件 -- 默认监听者是nil*/
+ (void)wy_sendEvent:(NSString *const)marking something:(id)something callBack:(void(^)(id *res))resultCallBack;
// 这个传入监听者
+ (void)wy_sendEvent:(NSString *const)marking withTarget:(id)target something:(id)something callBack:(void(^)(id *res))resultCallBack;

/** 监听事件 -- 默认监听者是WYEventCenter */
+ (void)wy_observeHandingEvent:(NSString *const)marking handle:(void(^)(id noti, id *re))handle;
// 这个传入监听者
+ (void)wy_observeHandingEvent:(NSString *const)marking withTarget:(id)target handle:(void(^)(id noti, id *res))handle;

/** 释放监听事件 */
+ (void)wy_removeHandingEvent:(NSString *const)marking;

//+ (void)wy_observeBeforeHandleEvent:(NSString *const)marking handle:(void(^)(id noti, id res))something;
//+ (void)wy_observeAfterHandleEvent:(NSString *const)marking handle:(void(^)(id noti, id re))something;

@end
