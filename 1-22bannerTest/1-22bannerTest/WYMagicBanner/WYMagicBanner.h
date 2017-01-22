//
//  WYMagicBanner.h
//  KLParallaxView
//
//  Created by wyman on 2017/1/6.
//  Copyright © 2017年 dara. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYMagicBanner;
@protocol WYMagicBannerDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)magicBanner:(WYMagicBanner *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end


@interface WYMagicBanner : UIView

/** 初始轮播图（推荐使用） */
+ (instancetype)magicBannerWithFrame:(CGRect)frame delegate:(id<WYMagicBannerDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

/** 代理 */
@property (nonatomic, weak) id<WYMagicBannerDelegate> delegate;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

- (void)setupTimer;
- (void)invalidateTimer;

@end
