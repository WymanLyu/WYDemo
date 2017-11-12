//
//  NSError+WY.m
//  HeiPa
//
//  Created by wyman on 2017/8/21.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "NSError+WY.h"

@implementation NSError (WY)

+ (instancetype)wy_errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code des:(NSString *)des {
    NSDictionary *dict = nil;
    if (des.length) {
        dict = @{NSLocalizedDescriptionKey : des};
    }
    return [NSError errorWithDomain:domain code:code userInfo:dict];
}

@end
