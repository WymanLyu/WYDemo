 //
//  SNNavTransition.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "SNNavTransition.h"
#import <objc/runtime.h>

@interface SNNavTransition ()
/** 动画控制器 */
@property (nonatomic, strong) SNNavAnimationController *animator;
/** 手势控制器 */
@property (nonatomic, strong) SNNavInteractionController *interaction;
@end
@implementation SNNavTransition

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"%@ init ", self);
    }
    return self;
}

//void sn_handleGesture() {
//    NSLog(@"----");
//}

- (void)setNavVc:(UINavigationController *)navVc {
    _navVc = navVc;
//    class_addMethod([self.navVc.interactivePopGestureRecognizer.delegate class], @selector(sn_handleGesture), (IMP)sn_handleGesture, "v");
//    [self.navVc.interactivePopGestureRecognizer addTarget:self.navVc.interactivePopGestureRecognizer.delegate action:@selector(sn_handleGesture)]; // 偷换系统手势方法
    
    [self.navVc.interactivePopGestureRecognizer addTarget:self.interaction action:@selector(sn_handleGesture:)]; // 偷换系统手势方法
}

#pragma mark - 懒加载
- (SNNavInteractionController *)interaction {
    if (!_interaction) {
        _interaction = [SNNavInteractionController new];
    }
    return _interaction;
}

- (SNNavAnimationController *)animator {
    if (!_animator) {
        _animator = [SNNavAnimationController new];
    }
    return _animator;
}

#pragma mark - Navigation 代理
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(nonnull UIViewController *)fromVC
                                                           toViewController:(nonnull UIViewController *)toVC {
    FuncLog
    self.animator.operation = operation;
//    return (self.navVc.interactivePopGestureRecognizer.state == UIGestureRecognizerStateBegan) ? self.animator : nil;
    return self.animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    FuncLog
    // 必须是交互驱动才返回此对象
    return (self.navVc.interactivePopGestureRecognizer.state == UIGestureRecognizerStateBegan) ? self.interaction : nil;

    
//    return (self.animator.operation == UINavigationControllerOperationPop) ? (id <UIViewControllerInteractiveTransitioning>)self.navVc.interactivePopGestureRecognizer.delegate : nil;

//    return self.interaction;
//    return nil;
}

@end


/////////////////////  动画控制器

@implementation SNNavAnimationController : NSObject

// 动画时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 3.25;
}

// 动画逻辑
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.operation == UINavigationControllerOperationPush) {
        [self push:transitionContext];
    } else if (self.operation == UINavigationControllerOperationPop) {
        [self pop:transitionContext];
    }

}

- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration  = [self transitionDuration:transitionContext];
    CGRect bounds            = [[UIScreen mainScreen] bounds];
    fromVc.view.frame = bounds;
    toVc.view.frame = CGRectMake(CGRectGetMaxX(bounds), 0, bounds.size.width, bounds.size.height);
    [[transitionContext containerView] addSubview:fromVc.view];
    [[transitionContext containerView] addSubview:toVc.view];
    [UIView animateWithDuration:duration animations:^{
        toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    } completion:^(BOOL finished) {
        [fromVc.view removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration  = [self transitionDuration:transitionContext];
    CGRect bounds            = [[UIScreen mainScreen] bounds];
    fromVc.view.frame = bounds;
    toVc.view.frame = bounds;
    [[transitionContext containerView] addSubview:toVc.view];
    [[transitionContext containerView] addSubview:fromVc.view];
    [UIView animateWithDuration:duration animations:^{
        fromVc.view.frame = CGRectMake(CGRectGetMaxX(bounds), 0, bounds.size.width, bounds.size.height);;
    } completion:^(BOOL finished) {
        [fromVc.view removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

/////////////////////  手势控制器

@implementation SNNavInteractionController : UIPercentDrivenInteractiveTransition


// 手势过渡过程
- (void)sn_handleGesture:(UIPanGestureRecognizer *)panGesture {
    
    CGFloat persent = 0;
    switch (_direction) {
        case InteractiveTransitionGestureDirectionLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case InteractiveTransitionGestureDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case InteractiveTransitionGestureDirectionUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case InteractiveTransitionGestureDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
    }
    
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
//            self.isBegininteration = true;
//            [self startGesture];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:persent];
            break;
        }
            
        case UIGestureRecognizerStateEnded:{
//            self.isBegininteration = false;
//            if (persent > 0.5) {
//                [self finishInteractiveTransition];
//            }else{
//                [self cancelInteractiveTransition];
//            }
        }
            break;
        default:
            
            break;
    }
}


@end

