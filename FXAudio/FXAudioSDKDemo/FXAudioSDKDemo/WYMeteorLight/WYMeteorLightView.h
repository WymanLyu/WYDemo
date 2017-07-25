//
//  WYMeteorLightView.h
//  FXAudioDemo
//
//  Created by wyman on 2017/6/20.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MeteorLightDirectionLeft  = 0, // 从左-》右
    MeteorLightDirectionRight = 1, // 从右-》左
    MeteorLightDirectionTop   = 3, // 从上-》下
    MeteorLightDirectionBottom= 4, // 从下-》上
} MeteorLightDirection;

@interface WYMeteorLightView : UIView

/** 默认是白色 */
@property (nonatomic, strong) UIColor *meteorLightColor;

/** 默认是20px */
@property (nonatomic, assign) CGFloat meteorLightWidth;

/** 流光方向 默认MeteorLightDirectionTop */
@property (nonatomic, assign) MeteorLightDirection direction;

#pragma mark - 动画控制
- (void)start;
- (void)stop;

@end
