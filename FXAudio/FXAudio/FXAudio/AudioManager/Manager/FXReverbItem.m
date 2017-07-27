//
//  FXReverbItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXReverbItem.h"

@implementation FXReverbItem

- (void)setMix:(float)mix {
    _mix = mix;
    self.dirty = YES;
}

-(void)setDry:(float)dry {
    _dry = dry;
    self.dirty = YES;
}

- (void)setWet:(float)wet {
    _wet = wet;
    self.dirty = YES;
}

- (void)setRoomSize:(float)roomSize {
    _roomSize = roomSize;
    self.dirty = YES;
}

-(void)setWidth:(float)width {
    _width = width;
    self.dirty = YES;
}

- (void)setDamp:(float)damp {
    _damp = damp;
    self.dirty = YES;
}





@end
