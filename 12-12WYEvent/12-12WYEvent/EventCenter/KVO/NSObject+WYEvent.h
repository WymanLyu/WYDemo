//
//  NSObject+WYEvent.h
//  12-12WYEvent
//
//  Created by wyman on 2016/12/22.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WYEvent)

@property (nonatomic, strong) NSMutableArray *eventMarkingArrM;

#pragma mark - 自定义通讯方式
/** 
 * 发送事件
 * something : 发送方通过该值传递
 * res       : 监听方通过该值传值
 */
- (void)wy_sendEvent:(NSString *const)marking something:(id)something callBack:(void(^)(id *res))result;

/** 
 * 监听事件
 * noti : 发送方传递来的信息
 * res  : 监听方通过该值传值
 */
- (void)wy_observeHandingEvent:(NSString *const)marking handle:(void(^)(id noti, id *res))handle;


//////////////// ------------------------------
/** 释放监听事件 -- 可选（其实没必要执行） */
- (void)wy_removeAllEvent;
- (void)wy_removeHandingEvent:(NSString *const)marking;


#pragma mark - 系统通知方式
/** 发送事件 */
- (void)wy_postNotificationName:(NSString *const)notiName userInfo:(NSDictionary *)aUserInfo finishHandle:(void (^)())finishCallBack;

/** 发送通知 */
- (void)wy_observeNotificationName:(NSString *const)notiName fromSender:(id)sender handle:(void(^)(NSNotification *noti))handle;

#pragma mark - 系统KVO - 还需要移除观察者才行，怎么这么蛋疼呢！- 待深入研究一下
/** 监听某个属性 */
- (void)wy_observePath:(NSString *)path target:(NSObject *)target options:(NSKeyValueObservingOptions)options change:(void(^)(NSDictionary<NSKeyValueChangeKey,id> *change))handle;




@end
