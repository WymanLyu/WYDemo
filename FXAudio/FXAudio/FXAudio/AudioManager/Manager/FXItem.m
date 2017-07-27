//
//  FXItem.m
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXItem.h"

@implementation FXItem

- (instancetype)initWithName:(NSString *)name controlValueDict:(NSDictionary *)controlValueDict {
    if (self = [super init]) {
        _fxName = name;
        _controlValueDict = controlValueDict;
        _enble = NO;
    }
    return self;
}

@end
