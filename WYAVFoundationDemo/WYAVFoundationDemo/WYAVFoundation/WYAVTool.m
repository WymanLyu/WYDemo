//
//  WYAVTool.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/14.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "WYAVTool.h"
#import <AVFoundation/AVFoundation.h>

@interface WYAVTool ()

////// 录音 //////////
/** 录音机 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 录音资源url */
@property (nonatomic, strong) NSURL *recorderUrl;

////// 音效 //////////
/** 音效id缓存 */
@property (nonatomic, strong) NSMutableDictionary *soundsIDCaches;

@end

@implementation WYAVTool

// 单例
static WYAVTool *_instance;
+ (instancetype)shareAVTool {
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
    WYAVTool *avTool = [self shareAVTool];
    avTool.recorderUrl = url;
    avTool.recorder = nil;
}

/**
 *  开始录音/如果当前正在暂停则继续录音（默认是在Caches/wyRecorder/yyyyMMdd.caf）
 */
+ (NSURL *)wy_recorderStart {
    WYAVTool *avTool = [self shareAVTool];
    if (!avTool.recorder.isRecording) { // 没有录音才开始录音
        [avTool.recorder record];
    }
    return avTool.recorderUrl;
}

/**
 *  暂停当前录音
 */
+ (void)wy_recorderPause {
    WYAVTool *avTool = [self shareAVTool];
    if(avTool.recorder.isRecording) { // 在录音状态时才允许暂停
        [avTool.recorder pause];
    }
}

/**
 *  结束当前录音
 */
+ (void)wy_recorderEnd {
    WYAVTool *avTool = [self shareAVTool];
    if(avTool.recorder.isRecording) {  // 在录音状态时才允许结束录音
        [avTool.recorder stop];
        // 清空指定的路径和录音器
        avTool.recorder = nil;
        avTool.recorderUrl = nil;
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
    WYAVTool *avTool = [WYAVTool shareAVTool];
    // 1.查询缓存
    SystemSoundID soundID = [avTool.soundsIDCaches[url.absoluteString] unsignedIntValue];
    if (soundID == 0) { // 没有资源缓存
        // 1.资源
        CFURLRef soundUrl = (__bridge CFURLRef)(url);
        
        // 2.生成soundID
        AudioServicesCreateSystemSoundID(soundUrl, &soundID);
        
        // 3.存入缓存
        [avTool.soundsIDCaches setValue:@(soundID) forKey:url.absoluteString];
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























@end
