//
//  WYMagicBannerCell.m
//  KLParallaxView
//
//  Created by wyman on 2017/1/6.
//  Copyright © 2017年 dara. All rights reserved.
//

#import "WYMagicBannerCell.h"

#define ALLOWSSELECTION_TIMEINTERVA 0.25 // 点击时间的时间差【决定在这个时间差内是否触发collection的点击事件】
#define MAGICVIEW_WIDTH [UIScreen mainScreen].bounds.size.width* 0.75
#define MAGICVIEW_HEIGHT 200

@interface WYMagicBannerCell ()
@property (nonatomic, strong)  NSDate *current;
@property (nonatomic, strong) NSSet *touches;
@property (nonatomic, strong) UIEvent *event;

@end

@implementation WYMagicBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        WYMagicView *parallaxView = [[WYMagicView alloc] initWithFrame:CGRectMake(0, 0, MAGICVIEW_WIDTH, MAGICVIEW_HEIGHT)];
        parallaxView.cornerRadius = 5.0;
        parallaxView.shadowColor = [UIColor blackColor];
        parallaxView.initialShadowRadius= 28;
        parallaxView.finalShadowRadius = 18;
        parallaxView.layer.zPosition = 100.0;
        parallaxView.backgroundColor = [UIColor whiteColor];
        parallaxView.center = self.contentView.center;
        [self.contentView addSubview:parallaxView];
        self.parallaxView = parallaxView;
        
        // 透视效果
        CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        transform.m34 = 1.0/-700;
        self.contentView.layer.transform = transform;
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s", __func__);
    // 0.定时器
    if (self.banner.autoScroll) {
        [self.banner invalidateTimer];
    }
    
    self.current = [NSDate date];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSDate *afterDate = [NSDate date];
    NSTimeInterval m = [afterDate timeIntervalSinceDate:self.current];
    NSLog(@"%f", m);
    // 0.定时器
    if (self.banner.autoScroll) {
        [self.banner setupTimer];
    }
    if (m < ALLOWSSELECTION_TIMEINTERVA) {
        NSLog(@"跳转");
        self.col.allowsSelection = YES;
        [super touchesEnded:touches withEvent:event];
    } else {
        NSLog(@"不跳转");
        self.col.allowsSelection = NO;
    }
}



@end
