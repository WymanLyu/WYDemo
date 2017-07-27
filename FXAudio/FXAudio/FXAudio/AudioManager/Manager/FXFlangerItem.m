//
//  FXFlangerItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXFlangerItem.h"

@implementation FXFlangerItem

- (void)setWet:(float)wet {
    _wet = wet;
    self.dirty = YES;
}

@end
