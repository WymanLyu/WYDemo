//
//  FXLimiterItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXLimiterItem.h"
#import "LimiterFxUnit.h"

@implementation FXLimiterItem
{
@protected
    LimiterFxUnit *limit;
}

- (instancetype)initWithFXId:(long)fxId {
    if (self = [super initWithFXId:fxId]) {
        limit = new LimiterFxUnit(FS);
    }
    return self;
}

- (void)dealloc {
    delete limit;
}

-(void)setCeilingDb:(float)ceilingDb {
    _ceilingDb = ceilingDb;
    limit->setCeilingDb(_ceilingDb*-40);
}

- (void)setThresholdDb:(float)thresholdDb {
    _thresholdDb = thresholdDb;
    limit->setThresholdDb(_thresholdDb*-40);
}

- (void)setReleaseSec:(float)releaseSec {
    _releaseSec = releaseSec;
    limit->setReleaseSec(_releaseSec*(1.6-0.1) + 0.1);
}

#pragma mark - 重写

- (void)setEnble:(BOOL)enble {
    [super setEnble:enble];
    limit->enable(_enble);
}

- (void)process:(float *)input output:(float *)output numberOfSamples:(unsigned int)numberOfSamples {
    limit->process(input, output, numberOfSamples);
}


@end
