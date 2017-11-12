//
//  NSError+WY.h
//  HeiPa
//
//  Created by wyman on 2017/8/21.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (WY)

+ (instancetype)wy_errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code des:(NSString *)des;

@end
