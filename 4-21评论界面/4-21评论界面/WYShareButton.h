//
//  WYShareButton.h
//  4-16分享动效
//
//  Created by wyman on 2017/4/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYShareButton,WYShareButtonAnimateTargetData;
@protocol WYShareButtonDelegate <NSObject>

@optional

// - 获取目标数据
- (WYShareButtonAnimateTargetData *)shareButtonFirstMidLayerTargetData:(WYShareButton *)shareBtn;
- (WYShareButtonAnimateTargetData *)shareButtonSecondMidLayerTargetData:(WYShareButton *)shareBtn;
- (WYShareButtonAnimateTargetData *)shareButtonThirstMidLayerTargetData:(WYShareButton *)shareBtn;


// - 动画状态
- (void)shareButtonStateNormal2SelecteAnimateBegin:(WYShareButton *)shareBtn;
- (void)shareButtonStateSelecte2NormalAnimateBegin:(WYShareButton *)shareBtn;
- (void)shareButtonStateAnimateEnd:(WYShareButton *)shareBtn;

@end


@interface WYShareButton : UIView

@property (nonatomic, weak) id<WYShareButtonDelegate> delegate;

@property (nonatomic, assign, getter=isShareSelected) BOOL shareSelected;

//// 子layer
@property (nonatomic, strong) CAShapeLayer *lineLayer1;
@property (nonatomic, strong) CAShapeLayer *lineLayer2;

@property (nonatomic, strong) CALayer *midLayer1;
@property (nonatomic, strong) CALayer *midLayer2;
@property (nonatomic, strong) CALayer *midLayer3;


//// 初始值
@property (nonatomic, assign) CGPoint midP1;
@property (nonatomic, assign) CGPoint midP2;
@property (nonatomic, assign) CGPoint midP3;
@property (nonatomic, assign) CGRect midBounds1;
@property (nonatomic, assign) CGRect midBounds2;
@property (nonatomic, assign) CGRect midBounds3;
@property (nonatomic, strong) id midContents1;
@property (nonatomic, strong) id midContents2;
@property (nonatomic, strong) id midContents3;
/** 动画 */
@property (nonatomic, assign) CGFloat animateTime;

- (void)forceLayout;

- (void)disSelect;

@property (nonatomic, assign) CGRect hitTestRect;

@end


@interface WYShareButtonAnimateTargetData : NSObject

@property (nonatomic, assign) CGPoint targetCenterPoint;
@property (nonatomic, assign) CGSize targetSize;
@property (nonatomic, strong) UIImage *targetImg;

@end


