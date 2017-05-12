//
//  WYAVTool.h
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/14.
//  Copyright © 2016年 yunyao. All rights reserved.
//  多媒体工具 -- by_wyman.lyu

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "WYPlayerTime.h"

typedef enum : NSUInteger {
    WYPlayerStatusUnknown     = 1, // 未知状态
    WYPlayerStateReadyPlayer  = 2, // 准备播放状态/seek到没有缓存的地方  =》 此时可以获取时长
    WYPlayerStatePlaying      = 3, // 播放中状态/仍进行缓存    =》 此时可以获取缓冲时长，播放时长
    WYPlayerStatePaused       = 4, // 暂停状态
    WYPlayerStateEnd          = 5, // 播放完毕状态
    WYPlayerStateFailed       = 6, // 播放失败状态
} WYPlayerStatus;

@interface WYAVManager : NSObject

/** 单例 */
+ (instancetype __nonnull)shareManager;

/////////// 播放音乐/视频【远程】 ////////////////

/**
 * 播放器播放状态
 */
@property (nonatomic, assign, readonly) BOOL wy_playing;

/**
 * 播放视图
 */
@property (nonatomic, strong, readonly) AVPlayerLayer *__nonnull wy_currentPlayerLayer;

/**
 * 加载url资源 并准备播放
 *  1.url为空时此处获取加载当前资源_wy_currentItem
 *  2._wy_currentItem为空时 以列表中第一个的播放资源为当前播放资源
 */
- (void)wy_readyPlayWithUrl:(NSURL *_Nullable )url;

/**
 * 开始播放【默认先调用wy_readyPlayWithUrl:nil】
 */
- (void)wy_startPlay;

/**
 * 暂停播放
 */
- (void)wy_pausePlay;

/**
 * 恢复播放
 */
- (void)wy_resumPlay;

/**
 * 停止播放
 */
- (void)wy_stopPlay;

/**
 *  快进到某个程度
 */
- (void)wy_seekToProgress:(CGFloat)progress;

/**
 * 快进几秒（+是快，-是退）
 */
- (void)wy_seekByTime:(CGFloat)time;

//--------- 播放资源

/**
 * 创建播放资源并加入播放列表【会清空旧资源】
 */
- (void)wy_createItemWithUrl:(NSURL * __nonnull)url;

/**
 * 追加单个资源
 */
- (void)wy_appendItemWithUrl:(NSURL * __nonnull)url;

/**
 * 创建播放资源列表【会清空旧资源】
 */
- (void)wy_createItemsWithUrls:(NSArray<NSURL *> * __nonnull)urls;

/**
 * 追加多个资源
 */
- (void)wy_appendItemsWithUrls:(NSArray<NSURL *> * __nonnull)urls;

/**
 * 切换当前播放资源【没有则加入资源列表】
 */
- (void)wy_switchCurrentPlayItemWithUrl:(NSURL * __nonnull)url;

/**
 * 切换下一个资源播放
 */
- (void)wy_nextPlayItem;

/**
 * 切换上一个资源播放
 */
- (void)wy_previousPlayItem;

/**
 * 当前播放资源
 */
@property (nonatomic, strong, readonly) AVPlayerItem * _Nullable  wy_currentItem;

////// 监听信息

/** 播放状态 */
- (void)wy_addObserver:(NSObject * __nonnull)observer playerStatus:(void(^ _Nullable )(WYPlayerStatus status))observeHandle;

/** 播放各种时间 */
- (void)wy_addObserver:(NSObject * __nonnull)observer playerTime:(void(^ _Nullable)(WYPlayerTime * __nonnull time))observeHandle;

/** 播放缓存 */
- (void)wy_addObserver:(NSObject * __nonnull)observer bufferProgress:(void(^ _Nullable )(CGFloat bufferProgress))observeHandle;

/** 播放进度 */
- (void)wy_addObserver:(NSObject * __nonnull)observer playerProgress:(void(^ _Nullable )(CGFloat progress))observeHandle;


////// 单独获取信息

/** 
 * 播放状态
 */
@property (nonatomic, assign, readonly) WYPlayerStatus wy_status;

////// 时间信息

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



@interface WYAVManager (Recoder)


/////////// 录音 ////////////////

/**
 *  指定录音存储url
 */
+ (void)wy_recorderCreateInURL:(NSURL *__nonnull)url;

/**
 *  开始录音/如果当前正在暂停则继续录音（默认是在Caches/wyRecorder/yyyyMMdd.caf）
 *  返回资源地址
 */
+ (NSURL *__nonnull)wy_recorderStart;

/**
 *  暂停当前录音
 */
+ (void)wy_recorderPause;

/**
 *  结束当前录音
 */
+ (void)wy_recorderEnd;

@end

@interface WYAVManager (Local)

/////////// 播放音乐【本地】 ////////////////

/**
 *  播放指定资源的音乐【不支持网络】
 */
+ (AVAudioPlayer *__nonnull)wy_playMusicWithURL:(NSURL *__nonnull)url;

/**
 *  播放工程中的音乐
 */
+ (AVAudioPlayer *__nonnull)wy_playMusicWithName:(NSString *__nonnull)musicName;

/**
 *  暂停工程中的音乐
 */
+ (void)wy_pauseMusicWithURL:(NSURL *__nonnull)url;

/**
 *  暂停工程中的音乐
 */
+ (void)wy_pauseMusicWithName:(NSString *__nonnull)musicName;

/**
 *  停止工程中的音乐
 */
+ (void)wy_stopMusicWithURL:(NSURL *__nonnull)url;

/**
 *  停止工程中的音乐
 */
+ (void)wy_stopMusicWithName:(NSString *__nonnull)musicName;

@end

@interface WYAVManager (Sounds)

/////////// 播放音效 ////////////////

/**
 *  播放指定资源路径音效
 */
+ (void)wy_playSoundsWithURL:(NSURL *__nonnull)url;

/**
 *  播放工程中的音效
 */
+ (void)wy_playSoundsWithName:(NSString *__nonnull)soundName;

@end



@interface WYAVManager (time)

/**
 * 返回00:00
 */
- (NSString * __nonnull)timeStringWithFloat:(CGFloat)time;

@end










