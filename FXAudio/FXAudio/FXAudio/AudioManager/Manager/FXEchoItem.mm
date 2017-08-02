//
//  FXEchoItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXEchoItem.h"
#import "EchoFxUnit.h"

@implementation FXEchoItem
{
    @protected
    EchoFxUnit *echo;
}

- (instancetype)initWithFXId:(long)fxId {
    if (self = [super initWithFXId:fxId]) {
        echo = new EchoFxUnit(FS);
    }
    return self;
}

- (void)dealloc {
    delete echo;
}



- (void)setDry:(float)dry {
    _dry = dry;
    echo->setDry(dry);
}

- (void)setWet:(float)wet {
    _wet = wet;
     echo->setWet(wet);
}

- (void)setBpm:(float)bpm {
    _bpm = bpm;
    echo->setBpm(bpm);
}

- (void)setBeats:(float)beats {
    _beats = beats;
    echo->setBeats(beats);
}

- (void)setDecay:(float)decay {
    _decay = decay;
    echo->setDecay(decay);
}

- (void)setMix:(float)mix {
    _mix = mix;
    echo->setMix(mix);
}

#pragma mark - 重写

- (void)setEnble:(BOOL)enble {
    [super setEnble:enble];
    echo->enable(_enble);
}

- (void)process:(float *)input output:(float *)output numberOfSamples:(unsigned int)numberOfSamples {
    echo->process(input, output, numberOfSamples);
}



@end
