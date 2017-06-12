//
//  WYSoundWaveView.h
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYSoundWaveView : UIView

- (void)drawSaveWithSamples:(SInt16 *)samples sampleCount:(NSInteger)sampleCount;

@end
