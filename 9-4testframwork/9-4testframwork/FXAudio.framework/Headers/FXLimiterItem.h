//
//  FXLimiterItem.h
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <FXAudio/FXAudio.h>

@interface FXLimiterItem : FXItem

@property (nonatomic, assign) float ceilingDb;
@property (nonatomic, assign) float thresholdDb;
@property (nonatomic, assign) float releaseSec;

@end
