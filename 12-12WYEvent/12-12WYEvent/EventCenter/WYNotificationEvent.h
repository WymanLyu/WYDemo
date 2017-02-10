//
//  WYNotificationEvent.h
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "WYEvent.h"
#import "WYWeakObject.h"

@interface WYNotificationEvent : NSObject

/** 发起者 */
@property (nonatomic, strong) WeakReference sender;

/** 通知d的 key:监听者-objc:回调 */
@property (nonatomic, strong) NSMutableDictionary *observeDictM;

/** 结束回调 */
@property (nonatomic, copy) void(^finishHandle)();

@end
