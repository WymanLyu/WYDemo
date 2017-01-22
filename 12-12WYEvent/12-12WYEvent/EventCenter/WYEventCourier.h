//
//  WYEventCourier.h
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYEventCourier : NSObject

+ (instancetype)shareCourier;

/** 执行所有注册事件的block */
- (void)handleEventForMarking:(NSString *)marking;

/** 保存参数 */
- (void)keepEventArg:(id)arg forMarking:(NSString *)marking;

/** 保存事件完毕后的block */
- (void)keepFinishHandle:(void(^)(id *res))handle forMarking:(NSString *)marking;

/** 保存事件执行block */
- (void)keepEventHandle:(void(^)(id noti, id *res))handle forMarking:(NSString *)marking;
- (void)keepEventHandle:(void (^)(id, id *))handle withTarget:(id)target forMarking:(NSString *)marking;

/** 移除事件回调 */
- (void)removerMarking:(NSString *)marking;

//- (void)keepBeforeEventHandle:(void(^)(id noti, id res))handle forMarking:(NSString *)marking;
//- (void)keepAfterEventHandle:(void(^)(id noti, id res))handle forMarking:(NSString *)marking;

@end
