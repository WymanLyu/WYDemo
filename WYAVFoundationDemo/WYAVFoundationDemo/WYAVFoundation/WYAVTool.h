//
//  WYAVTool.h
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/14.
//  Copyright © 2016年 yunyao. All rights reserved.
//  多媒体工具 -- by_wyman.lyu

#import <Foundation/Foundation.h>

@interface WYAVTool : NSObject

/** 单例 */
+ (instancetype)shareAVTool;

/////////// 录音 ////////////////

/**
 *  指定录音存储url
 */
+ (void)wy_recorderCreateInURL:(NSURL *)url;

/**
 *  开始录音/如果当前正在暂停则继续录音（默认是在Caches/wyRecorder/yyyyMMdd.caf）
 *  返回资源地址
 */
+ (NSURL *)wy_recorderStart;

/**
 *  暂停当前录音
 */
+ (void)wy_recorderPause;

/**
 *  结束当前录音
 */
+ (void)wy_recorderEnd;

/////////// 播放音效 ////////////////

/**
 *  播放指定资源路径音效
 */
+ (void)wy_playSoundsWithURL:(NSURL *)url;

/**
 *  播放指工程中的音效
 */
+ (void)wy_playSoundsWithName:(NSString *)soundName;


@end
