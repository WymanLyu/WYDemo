//
//  WYKVOTarget.m
//  12-12WYEvent
//
//  Created by wyman on 2017/3/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "WYKVOTarget.h"
#import "WYKVOCourier.h"

@implementation WYKVOTarget

- (void)dealloc {
    [[[WYKVOCourier shareCourier] wy_map] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, WYKVOEvent * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.targetHash isEqualToString:[NSString stringWithFormat:@"%zd", self]]) {
            // ----   debug:
             NSLog(@"%@ -- %zd", key, [self hash]);
             NSLog(@"self -: %@", self);
             NSLog(@"target -:%@", weakReferenceNonretainedObjectValue(obj.target));
             NSLog(@"observer -:%@", weakReferenceNonretainedObjectValue(obj.observe));
            // ----
            [weakReferenceNonretainedObjectValue(obj.target) removeObserver:[WYKVOCourier shareCourier] forKeyPath:obj.path];
        }
        
    }];
}

@end
