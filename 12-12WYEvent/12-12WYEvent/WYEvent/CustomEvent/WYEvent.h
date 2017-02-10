//
//  WYEvent.h
//  12-12WYEvent
//
//  Created by wyman on 2017/2/9.
//  Copyright © 2017年 tykj. All rights reserved.
//

////////////////////*------*------*/////////////////////////////////
/// WYEvent 事件对象，该结构包含了如下信息：
///
/// 1.一个装箱（弱引用处理）后的事件监听者
///     + 监听者处理事件的block，传入发起者的参数和结果参数的指针（修改结果）
///
/// 2.一个装箱（弱引用处理）后的事件发起者
///     + 发起者处理事件的blok，传入发起者的参数和结果参数的指针（修改结果）
///
/// 3.事件携带的参数
///////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "WYWeakObject.h"

@interface WYEvent : NSObject

/** 各种回调信息 */
@property (nonatomic, copy) void(^eventHandle)(id noti, id *res);
@property (nonatomic, copy) void(^eventBeforeHandle)(id noti, id *res);
@property (nonatomic, copy) void(^eventAfterHandle)(id noti, id *res);
@property (nonatomic, copy) void(^finish)(id *res);

/** 传参 */
@property (nonatomic, strong) id noti;

/** 监听者 */
@property (nonatomic, strong) WeakReference target;
/** 发起者 */
@property (nonatomic, strong) WeakReference sender;


@end
