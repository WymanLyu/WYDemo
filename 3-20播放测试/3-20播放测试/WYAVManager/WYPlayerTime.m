//
//  WYPlayerTime.m
//  WYAVFoundationDemo
//
//  Created by wyman on 2016/12/23.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "WYPlayerTime.h"

@implementation WYPlayerTime

- (void)setWy_timeNow:(NSString *)wy_timeNow {
    _wy_timeNow = wy_timeNow;
    if (!wy_timeNow) {
        _wy_timeNow = @"00:00";
    }
}

- (void)setWy_duration:(NSString *)wy_duration {
    _wy_duration = wy_duration;
    if (!wy_duration) {
        _wy_duration = @"00:00";
    }
}


@end
