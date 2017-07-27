//
//  FXReverbView.m
//  FXAudioSDKDemo
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXReverbView.h"

@implementation FXReverbView
- (IBAction)setDry:(UISlider *)sender {
    self.item.dry = sender.value;
}
- (IBAction)setWet:(UISlider *)sender {
    self.item.wet = sender.value;
}
- (IBAction)setMix:(UISlider *)sender {
    self.item.mix = sender.value;
}
- (IBAction)setRoomSize:(UISlider *)sender {
    self.item.roomSize = sender.value;
}

- (void)enble:(UISwitch *)enbleSwitch {
    self.item.enble = enbleSwitch.isOn;
}

- (void)setItem:(FXReverbItem *)item {
    _item = item;
    self.FXName.text = [FXItem getFXNameFromFXId:item.fxId];
}

@end
