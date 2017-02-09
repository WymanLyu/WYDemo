//
//  WYNotificationCourier.h
//  12-12WYEvent
//
//  Created by wyman on 2017/2/9.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYNotificationCourier : NSObject

+ (instancetype)shareCourier;

////////////////// 注册监听
- (void)registeNotificationName:(NSString *const)notiName;

////////////////// 保存信息
// 保存对象
/** 保存监听者 */
- (void)keepEventTarget:(id)target forMarking:(NSString *)marking;
/** 保存发送者 */
- (void)keepEventSender:(id)sender forMarking:(NSString *)marking;
/** 保存参数 */
- (void)keepEventArg:(id)arg forMarking:(NSString *)marking;
// 保存回调
/** 保存事件完毕后的block */
- (void)keepFinishHandle:(void(^)(id *res))handle forMarking:(NSString *)marking;
/** 保存事件执行block */
- (void)keepEventHandle:(void(^)(id noti, id *res))handle forMarking:(NSString *)marking;
/** 待开发 */
//- (void)keepBeforeEventHandle:(void(^)(id noti, id res))handle forMarking:(NSString *)marking;
//- (void)keepAfterEventHandle:(void(^)(id noti, id res))handle forMarking:(NSString *)marking;


/////////////// 执行回调
/** 执行所有注册事件的block */
- (void)handleEventForMarking:(NSString *)marking;

/////////////// 移除事件
/** 移除事件回调 */
- (void)removerMarking:(NSString *)marking;

@end
