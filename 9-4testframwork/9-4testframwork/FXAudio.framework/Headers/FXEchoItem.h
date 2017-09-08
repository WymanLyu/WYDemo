//
//  FXEchoItem.h
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <FXAudio/FXAudio.h>

@interface FXEchoItem : FXItem

@property (nonatomic, assign) float dry;
@property (nonatomic, assign) float wet;
@property (nonatomic, assign) float bpm;
@property (nonatomic, assign) float beats;
@property (nonatomic, assign) float decay;
@property (nonatomic, assign) float mix;

@end
