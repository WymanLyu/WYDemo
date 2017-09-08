//
//  FXFlangerItem.h
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <FXAudio/FXAudio.h>

@interface FXFlangerItem : FXItem

@property (nonatomic, assign) float wet;
@property (nonatomic, assign) float depth;
@property (nonatomic, assign) float LFOBeats;

@end
