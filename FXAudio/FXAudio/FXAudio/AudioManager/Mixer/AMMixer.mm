//
//  AMMixer.m
//  FXAudio
//
//  Created by wyman on 2017/8/2.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "AMMixer.h"
#import "SuperpoweredSimple.h"

@implementation AMMixer

+ (void)mixInputBuffer:(float *)input outBuffer:(float *)output volume:(float)volume numberOfSamples:(int)numberOfSamples {
    if (NULL ==  input || NULL == output || volume<0.0 || volume>1.0) return;
     SuperpoweredVolumeAdd(input, output, volume, volume, numberOfSamples);
}

@end
