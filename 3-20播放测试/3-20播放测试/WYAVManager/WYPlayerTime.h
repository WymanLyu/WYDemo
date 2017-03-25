//
//  WYPlayerTime.h
//  WYAVFoundationDemo
//
//  Created by wyman on 2016/12/23.
//  Copyright © 2016年 yunyao. All rights reserved.
//  时间结构

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYPlayerTime : NSObject


/**
 * 当前播放时间(秒)
 */
@property (nonatomic, assign) CGFloat wy_playTime;

/**
 * 当前缓冲进度(秒)
 */
@property (nonatomic, assign) float wy_bufferTime;

/**
 * 总时长(秒)
 */
@property (nonatomic, assign) CGFloat wy_playDuration;

////// 处理后的时间信息

/**
 * 当前播放进度
 */
@property (nonatomic, assign) float wy_playeProgress;

/**
 * 当前缓冲进度
 */
@property (nonatomic, assign) float wy_bufferProgress;

////// 处理后的时间信息

/**
 * 当前播放时间(00:00)
 */
@property (nonatomic, copy) NSString * _Nullable wy_timeNow;

/**
 * 当前播放时间(00:00)
 */
@property (nonatomic, copy) NSString * _Nullable wy_timeBuffer;

/**
 * 总时长(00:00)
 */
@property (nonatomic, copy) NSString * _Nullable wy_duration;

@end
