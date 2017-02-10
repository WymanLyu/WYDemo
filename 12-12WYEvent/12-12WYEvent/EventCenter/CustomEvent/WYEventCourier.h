//
//  WYEventCourier.h
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

////////////////////*------*------*/////////////////////////////////
/// WYEventCourier 自定义事件的携带者，该结构提供了如下作用：
///
/// 1.根据Key-Value的Map结构保存事件信息：
///     + 回调信息
///     + 监听事件, 传入监听者和接收事件后的回调
///
/// 2.执行事件:
///     + 触发事件的各种回调（对监听者进行解包判断是否安全调用）
///
/// 3.移除事件：
///     + 根据Key移除事件
///     + 移除所有事件
///
/// 最后，该事件中心的监听对象在不存在时则用自身充当！！！！！！！！！！！
///////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface WYEventCourier : NSObject

+ (instancetype)shareCourier;

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
