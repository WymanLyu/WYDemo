//
//  FXRollItem.m
//  FXAudio
//
//  Created by wyman on 2017/8/2.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXRollItem.h"
#import "RollFxUnit.h"

@implementation FXRollItem
{
@protected
    RollFxUnit *roll;
}

- (instancetype)initWithFXId:(long)fxId {
    if (self = [super initWithFXId:fxId]) {
        roll = new RollFxUnit(FS);
     }
    return self;
}

- (void)dealloc {
    delete roll;
}

- (void)setWet:(float)wet {
    _wet = wet;
}

- (void)setBpm:(float)bpm {
    _bpm = bpm;
}

- (void)setBeats:(float)beats {
    _beats = beats;
}

#pragma mark - 重写父类

- (void)setEnble:(BOOL)enble {
    [super setEnble:enble];
    roll->enable(_enble);
}

- (void)process:(float *)input output:(float *)output numberOfSamples:(unsigned int)numberOfSamples {
    roll->process(input, output, numberOfSamples);
}


@end
