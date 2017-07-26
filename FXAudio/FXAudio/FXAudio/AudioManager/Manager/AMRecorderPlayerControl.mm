//
//  AMRecorderPlayerControl.m
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "AMRecorderPlayerControl.h"
#import "AMAudioPlayer.h"
#import "AMAudioRecorder.h"
#import "SuperpoweredSimple.h"
#import <AVFoundation/AVFoundation.h>
#import "AMConst.h"

#import "SuperpoweredAdvancedAudioPlayer.h"

#define PREFX_RECORDER_DEBUG

@interface AMRecorderPlayerControl ()

/** 伴奏播放器 */
@property (nonatomic, strong) AMAudioPlayer *player;

/** 处理后的录音器 */
@property (nonatomic, strong) AMAudioRecorder *recorder;

/** 处理前的录音器 */
@property (nonatomic, strong) AMAudioRecorder *originRecorder;

@end

@implementation AMRecorderPlayerControl
{
    float *_player_buffer_interleaved_stereo;
    bool _silence;
}

- (void)dealloc {
    free(_player_buffer_interleaved_stereo);
}

/** 获取conrtol */
+ (instancetype)controlWithRecordFileURL:(NSURL *)recordFileURL playFileURL:(NSURL *)playFileURL {
    AMRecorderPlayerControl *control = [self new];
    control.player = [[AMAudioPlayer alloc] initWithFileURL:playFileURL];
    
    NSDictionary *dict = [self creatRecorderURL];
    if (!recordFileURL.absoluteString.length) {
        recordFileURL = dict[@"url"];
    }
    NSURL *originFileURL = dict[@"urlOrigin"];
    control.recorder = [[AMAudioRecorder alloc] initWithFileURL:recordFileURL];
    control.originRecorder = [[AMAudioRecorder alloc] initWithFileURL:originFileURL];
    control->_openReturnVoice = NO;
    control->_silence = NO;
    control.volume = 1.0;
    control.openReturnVoicePropertyActivityWhenHeadSetPlugging = NO;
    // 初始化
    posix_memalign((void **)&control->_player_buffer_interleaved_stereo, 16, (sizeof(float)*BUFFER_SAMPLE_COUNT+64)*CHANNELS);
    
    return control;
}

#pragma mark - AudioManagerDelegate

/** 前处理器，处理前回调 */
- (BOOL)audioManagerIOBeforePreFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples {
    
    // 1.读取播放文件
    self->_silence = ![self.player playWithBuffers:self->_player_buffer_interleaved_stereo numberOfSamples:numberOfSamples];

    // 2.录制未处理前的音频
    [self.originRecorder recordWithBuffers:buffers numberOfSamples:numberOfSamples];
    
    return self->_silence;
}

/** 前处理器，处理后回调 */
- (BOOL)audioManagerIOAfterPreFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples {
    
    // 1.录制处理后的音频
    [self.recorder recordWithBuffers:buffers numberOfSamples:numberOfSamples];
   
    // 2.根据是否进行mix 前提是在播放伴奏
    if (!self->_silence && !self.player.paused) {
        if (self->_openReturnVoicePropertyActivityWhenHeadSetPlugging) { // 仅当插入耳机时有效
            if (self.isOpenReturnVoice && [self isHeadSetPlugging]) { // 插了耳机并开启了返听时 MIX
                SuperpoweredVolumeAdd(self->_player_buffer_interleaved_stereo, buffers, self.volume, self.volume, numberOfSamples);
            } else { // 纯播放
                memcpy(buffers,self->_player_buffer_interleaved_stereo, (sizeof(float)*BUFFER_SAMPLE_COUNT+64)*CHANNELS); // 直接覆盖
            }
        } else {  // 没有耳机时也生效
            if (self.isOpenReturnVoice) { // MIX
                SuperpoweredVolumeAdd(self->_player_buffer_interleaved_stereo, buffers, self.volume, self.volume, numberOfSamples);
            } else { // 纯播放
                memcpy(buffers,self->_player_buffer_interleaved_stereo, (sizeof(float)*BUFFER_SAMPLE_COUNT+64)*CHANNELS); // 直接覆盖
            }
        }
    }
    return self->_silence;
}

/** 处理器，处理前回调 */
- (BOOL)audioManagerIOBeforeFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples {
    return self->_silence;
}

/** 处理器，处理后回调 */
- (BOOL)audioManagerIOAfterFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples {
    
    if (self.openReturnVoicePropertyActivityWhenHeadSetPlugging) { // 仅当耳机时候生效
        if (self.isOpenReturnVoice && [self isHeadSetPlugging]) { // 开启返听
            self->_silence = NO;
        }
    } else{ // 没有耳机时也生效
        if (self.isOpenReturnVoice) { // 开启返听
            self->_silence = NO;
        }
    }
    
    return self->_silence;
}

#pragma mark - 控制
- (void)startRecorder {
    [self.recorder start];
#ifdef PREFX_RECORDER_DEBUG
    [self.originRecorder start];
#endif
}

- (void)pauseRecorder {
    [self.recorder paused];
#ifdef PREFX_RECORDER_DEBUG
    [self.originRecorder pause];
#endif
}

- (void)stopRecorder {
    [self.recorder stop];
#ifdef PREFX_RECORDER_DEBUG
    [self.originRecorder stop];
#endif
}

- (void)startPlayer {
    [self.player start];
}

- (void)pausePlayer {
    [self.player pause];
}

- (void)stopPlayer {
    [self.player stop];
}

#pragma mark - 耳机

- (BOOL)isHeadSetPlugging {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

#pragma mark - 录音路径

+ (NSDictionary *)creatRecorderURL {
    
    // 1.存储资源路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 2.实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // 3.设定时间格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    // 4.用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"FXAudioDemoRecorder/%@", currentDateStr];
    NSString *fileOriginName = [NSString stringWithFormat:@"FXAudioDemoRecorder/%@_origin", currentDateStr];
    
    // 5.创建文件夹
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:[NSString stringWithFormat:@"%@/FXAudioDemoRecorder", path] withIntermediateDirectories:YES attributes:nil error:nil];
    
    // 6.资源路径
    NSString *urlPath = [path stringByAppendingPathComponent:fileName];
    NSString *urlPathOrigin = [path stringByAppendingPathComponent:fileOriginName];
    
    // 7.资源url
    NSURL *url = [NSURL fileURLWithPath:urlPath];
    NSURL *urlOrigin = [NSURL fileURLWithPath:urlPathOrigin];
    
    return @{@"url" : url, @"urlOrigin" : urlOrigin};
}

- (void)setPlayFileURL:(NSURL *)playFileURL {
    _playFileURL = playFileURL;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.player setFileURL:_playFileURL];
        [self.player start];
    });
}

#pragma mark - test

void playerEventCallback (void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
    switch (event) {
        case SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_LoadError:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_LoadError");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_NetworkError:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_NetworkError");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_EOF:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_EOF");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_JogParameter:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_JogParameter");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_DurationChanged:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_DurationChanged");
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_LoopEnd:
            NSLog(@"SuperpoweredAdvancedAudioPlayerEvent_LoopEnd");
        default:
            break;
    }

}



@end
