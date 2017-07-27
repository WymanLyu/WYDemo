//
//  FXEchoItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXEchoItem.h"

@implementation FXEchoItem

- (void)setDry:(float)dry {
    _dry = dry;
    self.dirty = YES;
}

- (void)setWet:(float)wet {
    _wet = wet;
    self.dirty = YES;
}

- (void)setBpm:(float)bpm {
    _bpm = bpm;
    self.dirty = YES;
}

- (void)setBeats:(float)beats {
    _beats = beats;
    self.dirty = YES;
}

- (void)setDecay:(float)decay {
    _decay = decay;
    self.dirty = YES;
}

- (void)setMix:(float)mix {
    _mix = mix;
    self.dirty = YES;
}


@end
