//
//  WYSoundWaveView.h
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYSoundWaveView : UIView

/** 一个samples默认画多少条线，默认是0，代表和sampleCount相同，设置后如果传入sampleCount>sampleLineCount的部分会被重新绘制上去*/
@property (nonatomic, assign) NSInteger sampleLineCount;

/** 显示水平横线，默认是NO */
@property (nonatomic, assign) BOOL needDrawHorizonLine;

- (void)drawSaveWithSamples:(SInt16 *)samples sampleCount:(NSInteger)sampleCount;

@end
