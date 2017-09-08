//
//  FXReverbItem.h
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <FXAudio/FXAudio.h>

@interface FXReverbItem : FXItem

@property (nonatomic, assign) float dry;
@property (nonatomic, assign) float wet;
@property (nonatomic, assign) float mix;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float damp;
@property (nonatomic, assign) float roomSize;

@end
