//
//  WYAVManager.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/14.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "WYAVManager.h"

@interface WYAVManager ()

////// 录音 //////////
/** 录音机 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 录音资源url */
@property (nonatomic, strong) NSURL *recorderUrl;

////// 音效 //////////
/** 音效id缓存 */
@property (nonatomic, strong) NSMutableDictionary *soundsIDCaches;

////// 本地音乐 //////////
/** 音乐播放器缓存 */
@property (nonatomic, strong) NSMutableDictionary *musicPlayers;

////// 音乐 //////////
/** 播放器【单例】*/
@property (nonatomic, strong) AVPlayer *wy_player;
/** 音乐资源缓存 */
@property (nonatomic, strong) NSMutableDictionary *musicItemsCache;
/** 音乐缓存key */
@property (nonatomic, strong) NSMutableArray *musicItemKeys;
/** 音乐缓存value */
@property (nonatomic, strong) NSMutableArray *musicItemValues;

/** 播放时间监听对象 */
@property (nonatomic, strong) id timeObserve;

@end

@implementation WYAVManager
{
    BOOL _wy_playing;
}

// 单例
static WYAVManager *_instance;
+ (instancetype)shareManager {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

#pragma mark - 录音

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        
        // 1.录音机设置
        //        NSString *const AVFormatIDKey;
        //        NSString *const AVSampleRateKey;
        //        NSString *const AVNumberOfChannelsKey;
        NSDictionary *setting = @{
                                  AVFormatIDKey         : @(kAudioFormatLinearPCM),
                                  AVSampleRateKey       : @8000,
                                  AVNumberOfChannelsKey : @2
                                  };
        
        // 2.创建录音机
        if (!self.recorderUrl) { // 没有指定路径则使用默认路径
            // 2.存储资源路径
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            
            // 2.1.实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            // 2.2.设定时间格式
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            
            // 2.3.用[NSDate date]可以获取系统当前时间
            NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"wyRecorder/%@.caf", currentDateStr];
            
            
            // 2.4.创建文件夹
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager createDirectoryAtPath:[NSString stringWithFormat:@"%@/wyRecorder", path] withIntermediateDirectories:YES attributes:nil error:nil];
            
            // 2.5.资源路径
            NSString *urlPath = [path stringByAppendingPathComponent:fileName];
            
            // 2.6.资源url
            NSURL *url = [NSURL fileURLWithPath:urlPath];
            
            self.recorderUrl = url;
        }
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recorderUrl settings:setting error:nil];
        
        // 3.准备录音
        [_recorder prepareToRecord];
    }
    return _recorder;
}

/**
 *  指定录音存储url
 */
+ (void)wy_recorderCreateInURL:(NSURL *)url {
    WYAVManager *manager = [self shareManager];
    manager.recorderUrl = url;
    manager.recorder = nil;
}

/**
 *  开始录音/如果当前正在暂停则继续录音（默认是在Caches/wyRecorder/yyyyMMdd.caf）
 */
+ (NSURL *)wy_recorderStart {
    WYAVManager *manager = [self shareManager];
    if (!manager.recorder.isRecording) { // 没有录音才开始录音
        [manager.recorder record];
    }
    return manager.recorderUrl;
}

/**
 *  暂停当前录音
 */
+ (void)wy_recorderPause {
    WYAVManager *manager = [self shareManager];
    if(manager.recorder.isRecording) { // 在录音状态时才允许暂停
        [manager.recorder pause];
    }
}

/**
 *  结束当前录音
 */
+ (void)wy_recorderEnd {
    WYAVManager *manager = [self shareManager];
    if(manager.recorder.isRecording) {  // 在录音状态时才允许结束录音
        [manager.recorder stop];
        // 清空指定的路径和录音器
        manager.recorder = nil;
        manager.recorderUrl = nil;
    }
}

#pragma mark - 音效

- (NSMutableDictionary *)soundsIDCaches {
    if (!_soundsIDCaches) {
        _soundsIDCaches = [NSMutableDictionary dictionary];
    }
    return _soundsIDCaches;
}

/**
 *  播放指定资源路径音效
 */
+ (void)wy_playSoundsWithURL:(NSURL *)url {
    if (!url) return;
    WYAVManager *manager = [WYAVManager shareManager];
    // 1.获取资源ID
    SystemSoundID soundID = [manager.soundsIDCaches[url.absoluteString] unsignedIntValue];
    if (soundID == 0) { // 没有资源缓存
        // 1.资源
        CFURLRef soundUrl = (__bridge CFURLRef)(url);
        
        // 2.生成soundID
        AudioServicesCreateSystemSoundID(soundUrl, &soundID);
        
        // 3.存入缓存
        [manager.soundsIDCaches setValue:@(soundID) forKey:url.absoluteString];
    }
    
    // 2.播放
    AudioServicesPlayAlertSound(soundID);
}

/**
 *  播放指工程中的音效
 */
+ (void)wy_playSoundsWithName:(NSString *)soundName {
    NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
    [self wy_playSoundsWithURL:url];
    
}

#pragma mark - 本地音乐

- (NSMutableDictionary *)musicPlayers {
    if (!_musicPlayers) {
        _musicPlayers = [NSMutableDictionary dictionary];
    }
    return _musicPlayers;
}

/**
 *  播放指定资源的音乐【不支持网络】
 */
+ (AVAudioPlayer *)wy_playMusicWithURL:(NSURL *)url {
    if (!url) return nil;
    WYAVManager *manager = [WYAVManager shareManager];
    // 1.获取播放器
    AVAudioPlayer *player = manager.musicPlayers[url.absoluteString];
    if (!player) { // 没有则创建
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [manager.musicPlayers setValue:player forKey:url.absoluteString];
        [player prepareToPlay];
    }
    
    // 2.播放
    [player play];
    return player;
}

/**
 *  播放工程中的音乐
 */
+ (AVAudioPlayer *)wy_playMusicWithName:(NSString *)musicName {
    NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
    return  [self wy_playMusicWithURL:url];
}

/**
 *  暂停指定资源的音乐
 */
+ (void)wy_pauseMusicWithURL:(NSURL *)url {
    if (!url) return;
    WYAVManager *manager = [WYAVManager shareManager];
    AVAudioPlayer *player = manager.musicPlayers[url.absoluteString];
    if (!player) return; // 没有播放器
    if (!player.isPlaying) return; // 没有播放
    [player pause];
}

/**
 *  暂停工程中的音乐
 */
+ (void)wy_pauseMusicWithName:(NSString *)musicName {
     NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
    [self wy_pauseMusicWithURL:url];
}

/**
 *  停止指定资源的音乐
 */
+ (void)wy_stopMusicWithURL:(NSURL *)url {
    if (!url) return;
    WYAVManager *manager = [WYAVManager shareManager];
    AVAudioPlayer *player = manager.musicPlayers[url.absoluteString];
    if (!player) return; // 没有播放器
    if (!player.isPlaying) return; // 没有播放
    [player stop];
    // 移除播放器
    [manager.musicPlayers removeObjectForKey:url.absoluteString];
    player = nil;
}

/**
 *  停止工程中的音乐
 */
+ (void)wy_stopMusicWithName:(NSString *)musicName {
     NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
    [self wy_stopMusicWithURL:url];
}

#pragma mark - 音乐/视频【远程】

- (AVPlayer *)wy_player {
    if (!_wy_player) {
        _wy_player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem new]];
        
        // 1.接收通知
    }
    return _wy_player;
}

- (NSMutableDictionary *)musicItemsCache {
    if (!_musicItemsCache) {
        _musicItemsCache = [NSMutableDictionary dictionary];
    }
    return _musicItemsCache;
}

- (NSMutableArray *)musicItemKeys {
    if (!_musicItemKeys) {
        _musicItemKeys = [NSMutableArray array];
    }
    return _musicItemKeys;
}

- (NSMutableArray *)musicItemValues {
    if (!_musicItemValues) {
        _musicItemValues = [NSMutableArray array];
    }
    return _musicItemValues;
}

/**
 * 获取播放状态
 */
- (BOOL)wy_playing {
    _wy_playing = (self.wy_player.rate == 1);
    return _wy_playing;
}

/**
 * 加载资源准备播放【url为空时此处获取列表中第一个的播放资源为当前播放资源】
 */
- (void)wy_readyPlayWithUrl:(NSURL *)url {
    
    // 0.停止当前资源
    [self wy_stopPlay];
    
    // 1.加载资源
    if (url) { // url不为空，加载该url资源
        // 1.查找缓存资源
        AVPlayerItem *item = [self.musicItemsCache objectForKey:url.absoluteString];
        
        // 2.校验资源存在
        if (!item){ // 不存在
            item = [self createNewItemWithUrl:url];
        }
        
        // 3.切换资源为当前资源
        _wy_currentItem = item;
        
    }else { // url为空时，以第一个资源为当前资源
        if (!_wy_currentItem) { // 获取第一个资源 加入播放器
            _wy_currentItem = [self firstItem];
   
        }
    }
    
    // 2.切换至当前资源
    if (!_wy_currentItem) return; // 说明url错误或者播放资源中没有资源
    [self.wy_player replaceCurrentItemWithPlayerItem:_wy_currentItem];
    
    // 3.监听当前资源监听状态
    [self addObserverForCurrentItem];
    
    // 4.记录当前资源视图
    _wy_currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.wy_player];
}

/**
 * 开始播放【默认先调用wy_readyPlay】
 */
- (void)wy_startPlay {
    if (self.wy_playing) { // 正在播放时
        [self wy_stopPlay];
    }
    
    [self wy_readyPlayWithUrl:nil];
    [self.wy_player play];
}

/**
 * 暂停播放
 */
- (void)wy_pausePlay {
    if (self.wy_playing) {
        [self.wy_player pause];
    }
}

/**
 * 恢复播放
 */
- (void)wy_resumPlay {
    if (!self.wy_playing) { // 暂停中
        if(!self.wy_currentItem) return; // 没有播放资源
        [self.wy_player play];
    }
}

/**
 * 停止播放
 */
- (void)wy_stopPlay {
    // 回到初始
    [self clearPlayer];
    
    [self.wy_player pause];
}

#pragma mark - 音乐/视频-资源【远程】

/**
 * 创建播放资源并加入播放列表
 */
- (void)wy_createItemWithUrl:(NSURL * __nonnull)url {
    if (!url) return;
    [self wy_createItemsWithUrls:@[url]];
}

/**
 * 创建播放资源列表
 */
- (void)wy_createItemsWithUrls:(NSArray<NSURL *> * __nonnull)urls {
    if (!urls.count) return;
    
    // 1.清空旧资源
    [self cleanOldItems];
    
    // 2.创建资源数组
    for (NSURL *url in urls) {
        [self createNewItemWithUrl:url];
    }
}

/**
 * 追加单个资源
 */
- (void)wy_appendItemWithUrl:(NSURL * __nonnull)url {
    if (!url) return;
    [self createNewItemWithUrl:url];
}

/**
 * 追加多个资源
 */
- (void)wy_appendItemsWithUrls:(NSArray<NSURL *> * __nonnull)urls {
    if (!urls.count) return;
    
    // 创建资源数组
    for (NSURL *url in urls) {
        [self createNewItemWithUrl:url];
    }
}

/**
 * 切换当前播放资源【没有则加入资源列表】
 */
- (void)wy_switchCurrentPlayItemWithUrl:(NSURL * __nonnull)url {
    if (!url) return;
    
    // 1.查找缓存资源
    AVPlayerItem *item = [self.musicItemsCache objectForKey:url.absoluteString];
    
    // 2.校验资源存在
    if (!item){ // 不存在
        item = [self createNewItemWithUrl:url];
    }
    
    // 3.切换资源
    [self.wy_player replaceCurrentItemWithPlayerItem:item];
}

- (void)endOfPlay {
    
}

#pragma mark - 私有方法
// 播放器原始状态
- (void)clearPlayer {
    // 1.移除资源监听
    [self removeObserverForCurrentItem];
    
    // 2.清空当前资源
    _wy_currentPlayerLayer = nil;
    _wy_currentItem = nil;
    
    // 3.置空
    [self.wy_player replaceCurrentItemWithPlayerItem:nil];
}

// 清空资源
- (void)cleanOldItems {
    // 1.还原播放器
    [self clearPlayer];
    
    // 2.清空资源
    [self.musicItemsCache removeAllObjects];
    [self.musicItemKeys removeAllObjects];
    [self.musicItemValues removeAllObjects];
    self.musicItemsCache = nil;
    self.musicItemKeys = nil;
    self.musicItemValues = nil;
    _wy_currentItem = nil;
    _wy_currentPlayerLayer = nil;
}

// 获取第一个资源
- (AVPlayerItem *)firstItem {
    // 1.获取第一个资源
    NSString *key = [self.musicItemKeys firstObject];
    if (!key) return nil;
    AVPlayerItem *firstItem = [self.musicItemsCache objectForKey:key];
    return firstItem;
}

// 创建新资源url
- (AVPlayerItem *)createNewItemWithUrl:(NSURL *)url {
    // 1.创建播放资源
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    // 2.保存
    [self.musicItemsCache setValue:item forKey:url.absoluteString];
    
    // 3.记录key、values
    [self.musicItemKeys addObject:url.absoluteString];
    [self.musicItemValues addObject:item];
    
    return item;
}

// KVO key
static void *statusContext = &statusContext;
static void *loadedTimeRangesContext = &loadedTimeRangesContext;
static void *playbackBufferEmptyContext = &playbackBufferEmptyContext;

// 监听当前播放资源
- (void)addObserverForCurrentItem {
    if (!_wy_currentItem) return;
    
    // 1.KVO
    // 1.1.资源播放状态
    [_wy_currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:statusContext];
    // 1.2.资源缓冲
    [_wy_currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:loadedTimeRangesContext];
    // 1.3.资源下载
    [_wy_currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:loadedTimeRangesContext];
    
    // 2.TimeObserve
    // 2.1.播放器进度监听
    __weak typeof(self)weakSelf = self;
    self.timeObserve = [self.wy_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time); // 当前播放时间
        float total = CMTimeGetSeconds(weakSelf.wy_currentItem.duration); // 总时间
        NSLog(@"%f, %f",current, total);
//        if (current) {
//            weakSelf.progress = current / total;
//            weakSelf.playTime = [NSString stringWithFormat:@"%.f",current];
//            weakSelf.playDuration = [NSString stringWithFormat:@"%.2f",total];
//        }
    }];
    
    // 3.Noti【资源状态】
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.wy_currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemPlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:self.wy_currentItem];
}

// 移除当前资源的监听
- (void)removeObserverForCurrentItem {
    
    // 1.移除KVO
    [_wy_currentItem removeObserver:self forKeyPath:@"status"];
    [_wy_currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [_wy_currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    // 2.TimeObserve
    if (self.timeObserve) {
        [self.wy_player removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
    
    // 3.移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // 4.移除当前资源
    _wy_currentItem = nil;
    [self.wy_player replaceCurrentItemWithPlayerItem:nil];
}

#pragma mark - KVO 回调

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == statusContext) { // 播放状态
        if ([keyPath isEqualToString:@"status"]) {
            switch (self.wy_player.status) {
                case AVPlayerStatusUnknown:
                    NSLog(@"KVO：未知状态");
                    break;
                case AVPlayerStatusReadyToPlay:
                    NSLog(@"KVO：准备完毕");
                    break;
                case AVPlayerStatusFailed:
                    NSLog(@"KVO：加载失败");
                    break;
                default:
                    break;
            }
        }
    }else if (context == loadedTimeRangesContext) {
        if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSArray * array = _wy_currentItem.loadedTimeRanges;
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
            NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
            NSLog(@"共下载缓冲%.2f",totalBuffer);
        }
    }else if (context == playbackBufferEmptyContext) {
        if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            NSLog(@"在加载缓冲中...");
        }
    }
}

#pragma mark - 通知回调

- (void)playerItemDidPlayToEnd:(NSNotification *)noti {
    
}

- (void)playerItemPlaybackStalled:(NSNotification *)noti {
    
}























@end
