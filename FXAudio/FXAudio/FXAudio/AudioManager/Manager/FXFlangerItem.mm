//
//  FXFlangerItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXFlangerItem.h"
#import "FlangerFxUnit.h"

@implementation FXFlangerItem
{
@protected;
    FlangerFxUnit *flanger;
}

- (instancetype)initWithFXId:(long)fxId {
    if (self = [super initWithFXId:fxId]) {
        flanger = new FlangerFxUnit(FS);
    }
    return self;
}

- (void)dealloc {
    delete flanger;
}

- (void)setWet:(float)wet {
    _wet = wet;
    flanger->setWet(_wet);
}

- (void)setDepth:(float)depth {
    _depth = depth;
    flanger->setDepth(_depth);
}

- (void)setLFOBeats:(float)LFOBeats {
    _LFOBeats = LFOBeats;
    flanger->setLFOBeats(_LFOBeats);
}


#pragma mark - 重写
- (void)process:(float *)input output:(float *)output numberOfSamples:(unsigned int)numberOfSamples {
    flanger->process(input, output, numberOfSamples);
}

- (void)setEnble:(BOOL)enble {
    [super setEnble:enble];
    flanger->enable(_enble);
}


@end
