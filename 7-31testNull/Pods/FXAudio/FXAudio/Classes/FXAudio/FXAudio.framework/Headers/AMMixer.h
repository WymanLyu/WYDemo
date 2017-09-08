//
//  AMMixer.h
//  FXAudio
//
//  Created by wyman on 2017/8/2.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMMixer : NSObject

/** outBuffer = volume*input + outBuffer volume控制input的强弱，0则没有声音，1则完全叠加  */
+ (void)mixInputBuffer:(float *)input outBuffer:(float *)output volume:(float)volume numberOfSamples:(int)numberOfSamples;

@end
