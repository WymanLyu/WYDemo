//
//  WYKVOObserver.m
//  12-12WYEvent
//
//  Created by wyman on 2017/3/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "WYKVOObserver.h"
#import "WYKVOCourier.h"

@implementation WYKVOObserver

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[[WYKVOCourier shareCourier] wy_map] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, WYKVOEvent * _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([key containsString:[NSString stringWithFormat:@"%zd+", [self hash]]]) {
            
            // ----   debug:
            // NSLog(@"%@ -- %zd", key, [self hash]);
            // NSLog(@"self -: %@", self);
            // NSLog(@"target -:%@", weakReferenceNonretainedObjectValue(obj.target));
            // NSLog(@"observer -:%@", weakReferenceNonretainedObjectValue(obj.observe));
            // ----
            
            [weakReferenceNonretainedObjectValue(obj.target) removeObserver:[WYKVOCourier shareCourier] forKeyPath:obj.path];
        }

// 有上述dubug可知 obj.observe解包后为nil 则不可由此判断
//        if (weakReferenceNonretainedObjectValue(obj.observe) == self) {
//            [weakReferenceNonretainedObjectValue(obj.target) removeObserver:[WYKVOCourier shareCourier] forKeyPath:obj.path];
////            [weakReferenceNonretainedObjectValue(obj.target) removeObject:weakReferenceNonretainedObjectValue(obj.observe)];
//        }
        
        
    }];
    
    
}

@end
