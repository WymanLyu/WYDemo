//
//  FXEchoView.m
//  FXAudioSDKDemo
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXEchoView.h"

@implementation FXEchoView

- (IBAction)dry:(UISlider *)sender {
    self.item.dry = sender.value;
}
- (IBAction)wet:(UISlider *)sender {
    self.item.wet = sender.value;
}
- (IBAction)mix:(UISlider *)sender {
    self.item.mix = sender.value;
}
- (IBAction)beats:(UISlider *)sender {
    self.item.beats = sender.value;
}

- (void)enble:(UISwitch *)enbleSwitch {
    self.item.enble = enbleSwitch.isOn;
}

- (void)setItem:(FXEchoItem *)item {
    _item = item;
    self.FXName.text = [FXItem getFXNameFromFXId:item.fxId];
}


@end
