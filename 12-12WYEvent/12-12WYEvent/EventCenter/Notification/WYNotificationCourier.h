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
/** 保存接受者和回调 */
- (void)keepEventObserve:(id)observe forMarking:(NSString *)marking eventHandle:(void(^)(id noti))handle;
/** 保存发送者 */
- (void)keepEventSender:(id)sender forMarking:(NSString *)marking finishHandle:(void(^)())finishHandle;

/////////////// 执行回调
/** 执行所有注册事件的block */
- (void)handleEventForMarking:(NSString *)marking withNoti:(NSNotification *)noti;

/////////////// 移除事件
/** 移除事件回调 */
- (void)removerMarking:(NSString *)marking;

@end
