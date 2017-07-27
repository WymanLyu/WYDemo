//
//  FXLimiterView.m
//  FXAudioSDKDemo
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXLimiterView.h"

@implementation FXLimiterView

- (IBAction)ceilingDb:(UISlider *)sender {
    self.item.ceilingDb = sender.value;
}
- (IBAction)thresholdDb:(UISlider *)sender {
    self.item.thresholdDb = sender.value;
}
- (IBAction)releaseSec:(UISlider *)sender {
    self.item.releaseSec = sender.value;
}


- (void)enble:(UISwitch *)enbleSwitch {
    self.item.enble = enbleSwitch.isOn;
}

- (void)setItem:(FXFlangerItem *)item {
    _item = item;
    self.FXName.text = [FXItem getFXNameFromFXId:item.fxId];
}


@end
