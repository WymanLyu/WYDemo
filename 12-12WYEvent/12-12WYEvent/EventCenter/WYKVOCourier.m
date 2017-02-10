//
//  WYKVOCourier.m
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "WYKVOCourier.h"
#import "WYKVOEvent.h"
#import <objc/runtime.h>

@interface WYKVOCourier ()

/** 存储执行block */
@property (nonatomic, strong) NSMutableDictionary <NSString *, WYKVOEvent *> *wy_map;

@end

@implementation WYKVOCourier

static WYKVOCourier *shareCourier = nil;
+ (instancetype)shareCourier {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCourier = [[self alloc] init];
    });
    return shareCourier;
}


/** 保存接受者和回调 */
- (void)keepKVOObserve:(_Nonnull id)observe target:(id)target forPath:(NSString *)path options:(NSKeyValueObservingOptions)options eventHandle:(void(^)(NSDictionary<NSKeyValueChangeKey,id> *))handle {
    
    if (!observe) return;
    // key 由observe 和 path组成
    NSString *key = [NSString stringWithFormat:@"%zd+%@", [observe hash], path];
    WYKVOEvent *event = [self.wy_map objectForKey:key];
    if (!event) {
        event = [[WYKVOEvent alloc] init];
        [self.wy_map setObject:event forKey:key];
    }
    event.observe = makeWeakReference(observe);
    event.target = makeWeakReference(target);
    event.path = path;
    event.handle = handle;

    // kvo这个属性
    void *context = (__bridge void *)(key);
    [target addObserver:self forKeyPath:path options:options context:context];
}



/** KVO回调 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"----");
    NSString *key = (__bridge NSString *)context;
    WYKVOEvent *event = [self.wy_map objectForKey:key];
    if ([keyPath isEqualToString:event.path]) {
        if (!weakReferenceNonretainedObjectValue(event.observe)) { // 监听者已经死了
            // 移除这个
            [self.wy_map removeObjectForKey:key];
        } else { // 执行回调
            if (event.handle) {
                event.handle(change);
            }
        }
    }
}

#pragma mark - 存储事件的Map
- (NSMutableDictionary *)wy_map {
    if (!_wy_map) {
        _wy_map = [NSMutableDictionary dictionary];
    }
    return _wy_map;
}


@end
