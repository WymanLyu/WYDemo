//
//  NSObject+DeallocNoti.h
//  3-10设计要看button
//
//  Created by wyman on 2017/9/29.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeallocNotiObj.h"

@interface NSObject (DeallocNoti)

@property (nonatomic, strong, readonly) DeallocNotiObj *deallocNotiObj;

@end
