//
//  FXItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXItem.h"

NSString * const UPDATE_FX_PROPERTY = @"UPDATE_FX_PROPERTY";

@implementation FXItem

@synthesize enble=_enble;

- (instancetype)initWithFXId:(long)fxId {
    if (self = [super init]) {
        self.fxId = fxId;
        _enble = NO;
    }
    return self;
}

- (void)setFxId:(long)fxId {
    _fxId = fxId;
    self.fxName = [FXItem getFXNameFromFXId:_fxId];
}

+ (NSString *)getFXNameFromFXId:(long)fxId {
    
    switch (fxId) {
        case FX_TYPE_FILTER:
        {
            return @"Filiter";
        }
            break;
        case FX_TYPE_REVERB:
        {
            return @"Reverb";
        }
            break;
        case FX_TYPE_FLANGER:
        {
            return @"Flanger";
        }
            break;
        case FX_TYPE_3_BAND_EQ:
        {
            return @"3BandEQ";
        }
            break;
        case FX_TYPE_GATE:
        {
            return @"Gate";
        }
            break;
        case FX_TYPE_ROLL:
        {
            return @"Roll";
        }
            break;
        case FX_TYPE_ECHO:
        {
            return @"Echo";
        }
            break;
        case FX_TYPE_WOOSH:
        {
            return @"Woosh";
        }
            break;
        case FX_TYPE_LIMITER:
        {
            return @"Limiter";
            
        }
            break;
        default:
            break;
    }
    return @"";
}

- (void)process:(float *)input output:(float *)output numberOfSamples:(unsigned int)numberOfSamples {
    // 子类重写
}

- (void)setEnble:(BOOL)enble {
    _enble = enble;
    // 子类重写
}

@end
