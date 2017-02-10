//
//  WYNotificationEvent.m
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "WYNotificationEvent.h"

@implementation WYNotificationEvent

- (NSMutableDictionary *)observeDictM {
    if (!_observeDictM) {
        _observeDictM = [NSMutableDictionary dictionary];
    }
    return _observeDictM;
}

@end
