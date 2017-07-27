//
//  FXFlangerView.m
//  FXAudioSDKDemo
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXFlangerView.h"

@implementation FXFlangerView

- (IBAction)setWet:(UISlider *)sender {
    
    self.item.wet = sender.value;
    
}

- (void)enble:(UISwitch *)enbleSwitch {
    self.item.enble = enbleSwitch.isOn;
}


- (void)setItem:(FXFlangerItem *)item {
    _item = item;
   self.FXName.text = [FXItem getFXNameFromFXId:item.fxId];
}

@end
