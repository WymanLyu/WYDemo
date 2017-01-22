//
//  WYLocationManager.h
//  WYCoreLocationDemo
//
//  Created by sialice on 16/5/29.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

/** 位置获取的结果回调 */
typedef void(^LocationResultBlock)(CLLocation *location, CLPlacemark *placeMark, NSString *error);

/** 区域监听的结果回调 */
typedef void(^RegionMonitorBlock)(BOOL isEnter, NSString *error);

@interface WYLocationManager : NSObject

/** 获取单例 */
+ (instancetype)shareManager;

/** 获取用户当前位置 */
- (void)getCurrentLocation:(LocationResultBlock)resultBlock;

/** 区域监听 */
- (void)monitorRegionPlace:(NSString *)placeName InRadius:(CGFloat)radius callBackBlock:(RegionMonitorBlock)resultBlock;

@end
