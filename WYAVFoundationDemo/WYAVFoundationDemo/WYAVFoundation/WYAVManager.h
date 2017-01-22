//
//  WYAVTool.h
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/14.
//  Copyright © 2016年 yunyao. All rights reserved.
//  多媒体工具 -- by_wyman.lyu

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WYAVManager : NSObject

/** 单例 */
+ (instancetype)shareManager;

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
 *  播放工程中的音效
 */
+ (void)wy_playSoundsWithName:(NSString *)soundName;

/////////// 播放音乐【本地】 ////////////////

/**
 *  播放指定资源的音乐【不支持网络】
 */
+ (AVAudioPlayer *)wy_playMusicWithURL:(NSURL *)url;

/**
 *  播放工程中的音乐
 */
+ (AVAudioPlayer *)wy_playMusicWithName:(NSString *)musicName;

/**
 *  暂停工程中的音乐
 */
+ (void)wy_pauseMusicWithURL:(NSURL *)url;

/**
 *  暂停工程中的音乐
 */
+ (void)wy_pauseMusicWithName:(NSString *)musicName;

/**
 *  停止工程中的音乐
 */
+ (void)wy_stopMusicWithURL:(NSURL *)url;

/**
 *  停止工程中的音乐
 */
+ (void)wy_stopMusicWithName:(NSString *)musicName;

/////////// 播放音乐/视频【远程】 ////////////////

/**
 * 播放器播放状态
 */
@property (nonatomic, assign, readonly) BOOL wy_playing;

/**
 * 播放视图
 */
@property (nonatomic, strong, readonly) AVPlayerLayer *wy_currentPlayerLayer;

/**
 * 加载url资源 并准备播放
 *  1.url为空时此处获取加载当前资源_wy_currentItem
 *  2._wy_currentItem为空时 以列表中第一个的播放资源为当前播放资源
 */
- (void)wy_readyPlayWithUrl:(NSURL *)url;

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
@property (nonatomic, strong, readonly) AVPlayerItem *wy_currentItem;
 
/**
 * 当前播放进度
 */
@property (nonatomic, assign, readonly) float wy_progress;

/**
 * 当前缓冲进度
 */
@property (nonatomic, assign, readonly) float wy_bufferProgress;

/**
 * 当前播放时间(秒)
 */
@property (nonatomic, copy, readonly) NSString *wy_playTime;

/**
 * 总时长(秒)
 */
@property (nonatomic, copy, readonly) NSString *wy_playDuration;

/**
 * 当前播放时间(00:00)
 */
@property (nonatomic, copy, readonly) NSString *wy_timeNow;

/**
 * 总时长(00:00)
 */
@property (nonatomic, copy, readonly) NSString *wy_duration;



















@end
