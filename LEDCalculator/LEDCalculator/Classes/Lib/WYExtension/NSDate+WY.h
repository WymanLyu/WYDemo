//
//  NSDate+WY.h
//  by-wyman.lyu-mail: wyman.lyu@gmail.com
//
//  Created by sialice on 16/5/6.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WY)


/**
 *  是否是今年
 */
- (BOOL)wy_isThisYear;

/**
 *  是否当天
 */
- (BOOL)wy_isToday;

/**
 *  是否是昨天
 */
- (BOOL)wy_isYesterday;

/**
 * 格式化时间
 */
- (NSString *)wy_formatTimeString;

/**
 * 抹茶工程的时间
 */
- (NSString *)wy_formatTimeStringInMocha;

/**
 * 抹茶工程中的直播预告时间
 */
- (NSString *)wy_formatTimeStringInMochaLiveAdvance;

@end
