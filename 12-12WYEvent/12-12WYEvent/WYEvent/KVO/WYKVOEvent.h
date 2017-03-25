//
//  WYKVOEvent.h
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYWeakObject.h"

@interface WYKVOEvent : NSObject

/** 监听者 */
@property (nonatomic, strong) WeakReference observe;

/** 目标 */
@property (nonatomic, strong) WeakReference target;

/** KVO属性 */
@property (nonatomic, copy) NSString *path;

/** 回调 */
@property (nonatomic, strong) void(^handle)(NSDictionary<NSKeyValueChangeKey,id> *change);

/** 目标对象hash key */
@property (nonatomic, copy) NSString *targetHash;

@end
