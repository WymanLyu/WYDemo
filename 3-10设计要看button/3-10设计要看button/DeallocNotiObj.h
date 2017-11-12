//
//  DeallocNotiObj.h
//  3-10设计要看button
//
//  Created by wyman on 2017/9/29.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const DeallocNotification;

@class DeallocNotiObj;
typedef void(^DeallocCallback)(DeallocNotiObj *deallocObj);

@interface DeallocNotiObj : NSObject

@property (nonatomic, strong, readonly) DeallocNotiObj *deallocNotiObj;
@property (nonatomic, copy) DeallocCallback deallocCallback;

@end
