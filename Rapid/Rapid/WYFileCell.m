//
//  WYFileCell.m
//  Rapid
//
//  Created by wyman on 2017/9/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYFileCell.h"
#import "WYProgressView.h"
#import "Rapid.h"

@interface WYFileCell ()
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet WYProgressView *progressView;


@property (nonatomic, strong) WYDownloadTask *task;

@end

@implementation WYFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUrl:(NSString *)url {
    _url = [url copy];
    // 设置文字
    self.textLabel.text = [url lastPathComponent];
    
    // 控制状态
///// 1
//    if (!_task) {
//        _task = [WYDownloadTask download:self.url toDestinationPath:nil progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
//            NSLog(@"%f", (double)totalBytesWritten / totalBytesExpectedToWrite);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.url = self.url;
//            });
//        } state:^(WYDownloadState state, NSString *file, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.url = self.url;
//            });
//        }];
//
//    }
//    [[WYDownloadSession shareSession] appendDownloadTask:_task];
//    WYDownloadTask *downTask = _task;
   
///// 2
    __weak typeof(self)weakSelf = self;
    _task = [[WYDownloadSession shareSession] download:self.url progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        NSLog(@"%f", (double)totalBytesWritten / totalBytesExpectedToWrite);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.url = weakSelf.url;
        });
    } state:^(WYDownloadState state, NSString *file, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.url = weakSelf.url;
        });
    } autoResume:NO];
    WYDownloadTask *downTask = _task;

///// 3
//    WYDownloadTask *downTask = [[WYDownloadSession shareSession] selectDownLoadTask:_url];

    if (downTask.state == WYDownloadStateCompleted) { // 完成
        self.progressView.hidden = YES;
        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    } else if (downTask.state == WYDownloadStateWillResume) { // 等待
        self.progressView.hidden = NO;
        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
    } else {
        if (downTask.downInfo.totalBytesExpectedToWrite) {
            self.progressView.progress = 1.0 * downTask.downInfo.totalBytesWritten / downTask.downInfo.totalBytesExpectedToWrite;
        } else {
            self.progressView.progress = 0.0;
        }
        if (downTask.state == WYDownloadStateResumed) { // 下载中
            [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        } else { // 未知状态
            [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)download:(UIButton *)sender {
    WYDownloadTask *downTask = [[WYDownloadSession shareSession] selectDownLoadTask:_url];
    
    if (downTask.state == WYDownloadStateResumed || downTask.state == WYDownloadStateWillResume) {
        [[WYDownloadSession shareSession] suspendTask:downTask];
        self.url = self.url;
    } else {
        [[WYDownloadSession shareSession] resumeTask:self.task];

///// 3
//        [[WYDownloadSession shareSession] download:self.url progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
//            NSLog(@"%f", (double)totalBytesWritten / totalBytesExpectedToWrite);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.url = self.url;
//            });
//        } state:^(WYDownloadState state, NSString *file, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.url = self.url;
//            });
//        }];
    }
}



@end
