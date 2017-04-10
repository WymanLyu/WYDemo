//
//  ViewController.m
//  3-20播放测试
//
//  Created by wyman on 2017/3/20.
//  Copyright © 2017年 playerTest. All rights reserved.
//

#import "ViewController.h"
#import "WYAVManager.h"

#define CHANGBA_URL @"http://heipa-storage.oss-cn-shanghai.aliyuncs.com/song/20170331162953_100000025_6d8b4ab703d3e4f4c0791205837a12c9.mp3" // @"http://qiniuuwmp3.changba.com/852737642.mp3"
#define MINE_URL @"http://oss.rapself.com/song/20170331162953_100000025_6d8b4ab703d3e4f4c0791205837a12c9.mp3"

//@"http://o9kbeutq6.bkt.clouddn.com/10001_20160901194923_lkUdcMGq8uV-pK1nBOVP4VGSxzPp.mp3" // @"http://user-storage.oss-cn-qingdao.aliyuncs.com/song/20170316194143_100000078_1da950dc13974bdbd059cc92da94dd9b.mp3"// @"http://user-storage.oss-cn-qingdao.aliyuncs.com/song/20170309182728_100000001_827d29e0c98063cf90a8b6e4af953c7a.mp3"



@interface ViewController ()
@property (nonatomic, strong) AVPlayer *wy_player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

     NSString *re = [self maxLenghtStrInStr:@"hello world" str:@"orlhelldls"];
    NSLog(@"%@", re);
}


- (NSString *)maxLenghtStrInStr:(NSString *)str1 str:(NSString *)str2 {
    
    if (!str1.length || !str2.length) return nil;
    NSArray <NSString *>*subArr1 = [self calSubStringSet:str1];
    NSArray <NSString *>*subArr2 = [self calSubStringSet:str2];
    NSMutableArray <NSString *>*equleArrM = [NSMutableArray array];
    [subArr1 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subArr2 containsObject:obj]) {
            [equleArrM addObject:obj];
        }
    }];
    NSArray *resultArr = [equleArrM sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        if (str1.length > str2.length) {
            return NSOrderedAscending;
        } else if (str1.length < str2.length) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return [resultArr firstObject];
}

- (NSArray <NSString *>*)calSubStringSet:(NSString *)str {
    NSInteger length = str.length;
    NSMutableArray *subStringArrM = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        for (int j = 1; j < length-i; j++) {
            NSString *subStr = [str substringWithRange:NSMakeRange(i, j)];
            [subStringArrM addObject:subStr];
        }
    }
    return [NSArray arrayWithArray:subStringArrM];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1：代表是oss存储mp3资源url   0：代表是其他云存储mp3资源url
    int flag = 0;
    AVPlayerItem *item = nil;
    if (flag) {
        item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:MINE_URL]];
    } else {
        item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:CHANGBA_URL]];
    }
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    self.wy_player = player;
    self.wy_player.automaticallyWaitsToMinimizeStalling = false;
    [self.wy_player play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * array = self.wy_player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        NSLog(@"共下载缓冲%.2fkb",totalBuffer);
    }
}

/*
 
 if ([keyPath isEqualToString:@"status"]) {
 switch (self.wy_player.status) {
 case AVPlayerStatusUnknown:
 //                NSLog(@"KVO：未知状态");
 break;
 case AVPlayerStatusReadyToPlay:
 //                NSLog(@"KVO：准备完毕");
 [self.wy_player play];
 break;
 case AVPlayerStatusFailed:
 //                NSLog(@"KVO：加载失败");
 break;
 default:
 break;
 }
 
 } else
 */

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
//                NSLog(@"0000000000000000----%f", CACurrentMediaTime());
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
