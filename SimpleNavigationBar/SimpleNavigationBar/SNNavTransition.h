//
//  SNNavTransition.h
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Nav 转场代理
@interface SNNavTransition : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UINavigationController *navVc;

@end

#pragma mark - Nav 动画控制器
@interface SNNavAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

#pragma mark - Nav 交互控制器
typedef NS_ENUM(NSUInteger,InteractiveTransitionGestureDirection) {
    InteractiveTransitionGestureDirectionLeft = 0,
    InteractiveTransitionGestureDirectionRight,
    InteractiveTransitionGestureDirectionUp,
    InteractiveTransitionGestureDirectionDown
};
@interface SNNavInteractionController : UIPercentDrivenInteractiveTransition <UIViewControllerInteractiveTransitioning>

@property (nonatomic,assign) InteractiveTransitionGestureDirection direction;

- (void)sn_handleGesture:(UIPanGestureRecognizer *)panGesture;


@end
