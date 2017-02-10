//
//  CustomView2.m
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "CustomView2.h"
#import "NSObject+WYEvent.h"

@interface CustomView2 ()

@property (nonatomic, weak) UILabel *sub1;
@property (nonatomic, weak) UILabel *sub2;

@property (nonatomic, strong) id ss;

@end

@implementation CustomView2

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    for (UIView *subView in self.subviews) {
        if (subView.tag == 1) {
            self.sub1 = (UILabel *)subView;
        }
        if (subView.tag == 2) {
            self.sub2 = (UILabel *)subView;
        }
    }
    
    __weak typeof(self)weakSelf =self;
    [self.sub1 wy_observeNotificationName:@"send111" fromSender:nil handle:^(NSNotification *noti) {
        NSLog(@"send111");
        NSInteger i = [[noti.userInfo objectForKey:@"value"] integerValue];
        weakSelf.sub1.text = [NSString stringWithFormat:@"从所有个发送方接受到信号：%zd",i];
    }];
    [self.sub1 wy_observeNotificationName:@"send222" fromSender:nil handle:^(NSNotification *noti) {
        NSLog(@"send222");
        NSInteger i = [[noti.userInfo objectForKey:@"value"] integerValue];
        weakSelf.sub1.text = [NSString stringWithFormat:@"从所有个发送方接受到信号：%zd",i];
    }];

}

- (void)setVc:(UIViewController *)vc {
    _vc = vc;
    __weak typeof(self)weakSelf =self;

    [self.sub2 wy_observeNotificationName:@"send111" fromSender:self.vc handle:^(NSNotification *noti) {
        NSLog(@"send111");
        NSInteger i = [[noti.userInfo objectForKey:@"value"] integerValue];
        weakSelf.sub2.text = [NSString stringWithFormat:@"从vc发送方接受到信号：%zd",i];
    }];
    [self.sub2 wy_observeNotificationName:@"send222" fromSender:nil handle:^(NSNotification *noti) {
        NSLog(@"send222");
        NSInteger i = [[noti.userInfo objectForKey:@"value"] integerValue];
        weakSelf.sub2.text = [NSString stringWithFormat:@"从所有个发送方接受到信号：%zd",i];
    }];
    [self.sub2 wy_observeNotificationName:@"send333" fromSender:self.vc handle:^(NSNotification *noti) {
        NSLog(@"send333");
        NSInteger i = [[noti.userInfo objectForKey:@"value"] integerValue];
        weakSelf.sub2.text = [NSString stringWithFormat:@"从vc发送方接受到信号：%zd",i];
    }];
    
    // 测试死了还调不调用。。
    self.ss =[NSObject new] ;
    [self.ss wy_observeNotificationName:@"send333" fromSender:nil handle:^(NSNotification *noti) {
        NSLog(@"测试死了还调不调用");
    }];
    self.ss = nil;
    
    
}


@end
