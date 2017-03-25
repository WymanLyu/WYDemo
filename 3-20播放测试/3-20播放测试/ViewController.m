//
//  ViewController.m
//  3-20播放测试
//
//  Created by wyman on 2017/3/20.
//  Copyright © 2017年 playerTest. All rights reserved.
//

#import "ViewController.h"
#import "WYAVManager.h"

#define CHANGBA_URL @"http://qiniuuwmp3.changba.com/852737642.mp3"
#define MINE_URL @"http://user-storage.oss-cn-qingdao.aliyuncs.com/song/20170316194143_100000078_1da950dc13974bdbd059cc92da94dd9b.mp3"// @"http://user-storage.oss-cn-qingdao.aliyuncs.com/song/20170309182728_100000001_827d29e0c98063cf90a8b6e4af953c7a.mp3"



@interface ViewController ()
@property (nonatomic, strong) AVPlayer *wy_player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:MINE_URL]];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
//    AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:CHANGBA_URL]];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    self.wy_player = player;
    self.wy_player.automaticallyWaitsToMinimizeStalling = false;
    [self.wy_player play];

    
    NSLog(@"1111111111111111111----%f", CACurrentMediaTime());
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.wy_player.status) {
            case AVPlayerStatusUnknown:
                                    NSLog(@"KVO：未知状态");
//                if (self.wy_status != WYPlayerStatusUnknown) {
//                    _wy_status = WYPlayerStatusUnknown;
//                    [self callObserversType:kStatusBlock];
//                }
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"KVO：准备完毕");
                //                    YSLog(@"1111111111111111111----%f", CACurrentMediaTime());
//                if (self.wy_status != WYPlayerStateReadyPlayer) {
//                    _wy_status = WYPlayerStateReadyPlayer;
//                    [self callObserversType:kStatusBlock];
//                    //                        [self.wy_player play]; // 播放歌曲
//                }
//                if (self.wy_playing) {
//                    _wy_status = WYPlayerStatePlaying;
//                    [self callObserversType:kStatusBlock];
//                }
                [self.wy_player play];
                NSLog(@"000000000000000----%f", CACurrentMediaTime());
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败");
//                if (self.wy_status != WYPlayerStateFailed) {
//                    _wy_status = WYPlayerStateFailed;
//                    [self callObserversType:kStatusBlock];
//                }
                break;
            default:
                break;
        }

    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * array = self.wy_player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        NSLog(@"共下载缓冲%.2f",totalBuffer);
//        _wy_bufferTime = totalBuffer;
//        if (_wy_playDuration) {
//            _wy_bufferProgress = totalBuffer / _wy_playDuration;
//        }
//        _wy_timeBuffer = [self timeStringWithFloat:_wy_bufferTime];
//        [self callObserversType:kTimeBlock];
    }

}

#pragma mark - WY
- (void)testPlayer {
    WYAVManager *manager= [WYAVManager shareManager];
    
    [manager wy_addObserver:self playerStatus:^(WYPlayerStatus status) {
        switch (status) {
            case WYPlayerStatusUnknown:
                NSLog(@"未知状态");
                break;
            case WYPlayerStateReadyPlayer:
                NSLog(@"准备播放状态/seek到没有缓存的地方");
                NSLog(@"0000000000000000----%f", CACurrentMediaTime());
                break;
            case WYPlayerStatePlaying:
                NSLog(@"播放中状态/仍进行缓存 ");
                break;
            case WYPlayerStatePaused:
                NSLog(@"暂停状态");
                break;
            case WYPlayerStateEnd:
                NSLog(@"播放完毕状态");
                break;
            case WYPlayerStateFailed:
                NSLog(@"播放失败状态");
                break;
            default:
                break;
        }
    }];
    [manager wy_addObserver:self playerTime:^(WYPlayerTime * _Nonnull time) {
        NSLog(@"---%f", time.wy_bufferProgress);
    }];
    
    [manager wy_createItemWithUrl:[NSURL URLWithString:@"http://user-storage.oss-cn-qingdao.aliyuncs.com/song/20170309182728_100000001_827d29e0c98063cf90a8b6e4af953c7a.mp3"]];
    [manager wy_startPlay];
    NSLog(@"1111111111111111111----%f", CACurrentMediaTime());
}


@end
