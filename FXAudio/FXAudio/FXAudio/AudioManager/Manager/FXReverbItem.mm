//
//  FXReverbItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXReverbItem.h"
#import "ReverbFxUnit.h"

@implementation FXReverbItem
{
    @protected
    ReverbFxUnit *reverb;
}

- (instancetype)initWithFXId:(long)fxId {
    if (self = [super initWithFXId:fxId]) {
        reverb = new ReverbFxUnit(FS);
    }
    return self;
}

- (void)dealloc {
    delete reverb;
}

- (void)setMix:(float)mix {
    reverb->setMix(mix);
}

-(void)setDry:(float)dry {
    reverb->setDry(dry);
}

- (void)setWet:(float)wet {
    reverb->setWet(wet);
}

- (void)setRoomSize:(float)roomSize {
    reverb->setRoomSize(roomSize);
}

-(void)setWidth:(float)width {
    reverb->setWidth(width);
}

- (void)setDamp:(float)damp {
    reverb->setDamp(damp);
}

#pragma mark - 重写

- (void)setEnble:(BOOL)enble {
    [super setEnble:enble];
    reverb->enable(_enble);
}

- (void)process:(float *)input output:(float *)output numberOfSamples:(unsigned int)numberOfSamples {
    reverb->process(input, output, numberOfSamples);
}





@end
