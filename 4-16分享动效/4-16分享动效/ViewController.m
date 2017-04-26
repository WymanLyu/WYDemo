//
//  ViewController.m
//  4-16分享动效
//
//  Created by wyman on 2017/4/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "WYShareButton.h"
#import "WYShareView.h"
#import "UIView+WY.h"

@interface ViewController ()<WYShareButtonDelegate>

@property (nonatomic, strong)  WYShareView *shareView ;

@property (nonatomic, weak) WYShareButton *shareBtn;

@property (nonatomic, strong) UIImageView *snapAniView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    WYShareView *shareView = [[WYShareView alloc] initWithFrame:CGRectMake(10, 300-50, [UIScreen mainScreen].bounds.size.width-20, 50)];
    [self.view addSubview:shareView];
    _shareView = shareView;
    _shareView.hidden = YES;
    _shareView.clipsToBounds= YES;
    
    WYShareButton *shareBtn = [[WYShareButton alloc] initWithFrame:CGRectMake(10, 300, 50, 50)];
    shareBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:shareBtn];

    
    shareBtn.delegate = self;
    _shareBtn =shareBtn ;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.shareView.sharePlatform = 0;//SharePlatformQQSession;// | SharePlatformWechatTimeline | SharePlatformQZone |SharePlatformWechatFav;
    [self.shareBtn disSelect];
    
    self.shareBtn.frame = CGRectMake(200, 310, 99, 99);
    [self.shareBtn forceLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WYShareButtonDelegate


// - 动画状态
- (void)shareButtonStateNormal2SelecteAnimateBegin:(WYShareButton *)shareBtn {
    
    if (self.snapAniView || !self.shareView.scrollView.subviews.count) {
        return;
    }
    shareBtn.userInteractionEnabled = NO;
    [self.shareView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            btn.imageView.hidden = YES;
        }
    }];
    self.shareView.hidden = NO;
    self.snapAniView = [[UIImageView alloc] initWithImage:self.shareView.wy_snapshotImage];
    self.snapAniView.frame = self.shareBtn.frame;
    [self.view insertSubview:self.snapAniView belowSubview:self.shareBtn];
    self.shareView.hidden = YES;
    
    [UIView animateWithDuration:self.shareBtn.animateTime delay:self.shareBtn.animateTime*0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.snapAniView.frame = CGRectMake(10, 300-50, [UIScreen mainScreen].bounds.size.width-20, 50);
    } completion:^(BOOL finished) {
        [self.shareView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                btn.imageView.hidden = NO;
            }
        }];
        self.shareView.hidden = NO;
        self.shareBtn.midLayer1.hidden = YES;
        self.shareBtn.midLayer2.hidden = YES;
        self.shareBtn.midLayer3.hidden = YES;
        
        self.snapAniView.hidden= YES;
        self.snapAniView = nil;
        [self.snapAniView removeFromSuperview];
        shareBtn.userInteractionEnabled = YES;
    }];

}

- (void)shareButtonStateSelecte2NormalAnimateBegin:(WYShareButton *)shareBtn {
    
    if (self.snapAniView || !self.shareView.scrollView.subviews.count) {
        return;
    }
    shareBtn.userInteractionEnabled = NO;
    [self.shareView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            btn.imageView.hidden = YES;
        }
    }];
    self.shareView.hidden = NO;
    [self.shareView.scrollView setContentOffset:CGPointZero animated:NO];
    self.snapAniView = [[UIImageView alloc] initWithImage:self.shareView.wy_snapshotImage];
    self.snapAniView.frame = CGRectMake(10, 300-50, [UIScreen mainScreen].bounds.size.width-20, 50);
    [self.view insertSubview:self.snapAniView belowSubview:self.shareBtn];
    self.shareView.hidden = YES;
    
    self.shareBtn.midLayer1.hidden = NO;
    self.shareBtn.midLayer2.hidden = NO;
    self.shareBtn.midLayer3.hidden = NO;
    self.shareView.hidden = YES;
    
    [UIView animateWithDuration:self.shareBtn.animateTime delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.snapAniView.frame = self.shareBtn.frame;
    } completion:^(BOOL finished) {
        [self.shareView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                btn.imageView.hidden = NO;
            }
        }];
        self.snapAniView.hidden= YES;
        self.snapAniView = nil;
        [self.snapAniView removeFromSuperview];
        shareBtn.userInteractionEnabled = YES;
    }];
}


// - 获取目标数据
- (WYShareButtonAnimateTargetData *)shareButtonFirstMidLayerTargetData:(WYShareButton *)shareBtn {
    WYShareButtonAnimateTargetData *data = [WYShareButtonAnimateTargetData new];
    if (self.shareView.scrollView.subviews.count < 1) {
        data.targetCenterPoint = [shareBtn convertPoint:shareBtn.midP1 toView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIButton *subBtn1 = [self.shareView.scrollView.subviews objectAtIndex:0];
        data.targetCenterPoint = [subBtn1 convertPoint:subBtn1.imageView.center toView:[UIApplication sharedApplication].keyWindow];
        data.targetSize = subBtn1.imageView.bounds.size;
        data.targetImg = subBtn1.imageView.image;
    }
    return data;
}

- (WYShareButtonAnimateTargetData *)shareButtonSecondMidLayerTargetData:(WYShareButton *)shareBtn {
    WYShareButtonAnimateTargetData *data = [WYShareButtonAnimateTargetData new];
    if (self.shareView.scrollView.subviews.count < 2) {
        data.targetCenterPoint = [shareBtn convertPoint:shareBtn.midP2 toView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIButton *subBtn2 = [self.shareView.scrollView.subviews objectAtIndex:1];
        data.targetCenterPoint = [subBtn2 convertPoint:subBtn2.imageView.center toView:[UIApplication sharedApplication].keyWindow];
        data.targetSize = subBtn2.imageView.bounds.size;
        data.targetImg = subBtn2.imageView.image;
    }
    return data;
}

- (WYShareButtonAnimateTargetData *)shareButtonThirstMidLayerTargetData:(WYShareButton *)shareBtn {
    WYShareButtonAnimateTargetData *data = [WYShareButtonAnimateTargetData new];
    if (self.shareView.scrollView.subviews.count < 3) {
        data.targetCenterPoint = [shareBtn convertPoint:shareBtn.midP1 toView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIButton *subBtn3 = [self.shareView.scrollView.subviews objectAtIndex:2];
        data.targetCenterPoint = [subBtn3 convertPoint:subBtn3.imageView.center toView:[UIApplication sharedApplication].keyWindow];
        data.targetSize = subBtn3.imageView.bounds.size;
        data.targetImg = subBtn3.imageView.image;
    }
    return data;
}


@end
