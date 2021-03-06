//
//  WYKVOCourier.h
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYKVOEvent.h"

@interface WYKVOCourier : NSObject

/** 存储执行block */
@property (nonatomic, strong) NSMutableDictionary <NSString *, WYKVOEvent *> *wy_map;

+ (instancetype)shareCourier;

/** 保存接受者和回调 */
- (void)keepKVOObserve:(_Nonnull id)observe target:(id)target forPath:(NSString *)path options:(NSKeyValueObservingOptions)options eventHandle:(void(^)(NSDictionary<NSKeyValueChangeKey,id> *))handle;


@end
