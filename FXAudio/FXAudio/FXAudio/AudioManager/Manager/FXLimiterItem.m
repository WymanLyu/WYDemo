//
//  FXLimiterItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXLimiterItem.h"

@implementation FXLimiterItem

-(void)setCeilingDb:(float)ceilingDb {
    _ceilingDb = ceilingDb;
    self.dirty = YES;
}

- (void)setThresholdDb:(float)thresholdDb {
    _thresholdDb = thresholdDb;
    self.dirty = YES;
}

- (void)setReleaseSec:(float)releaseSec {
    _releaseSec = releaseSec;
    self.dirty = YES;
}


@end
