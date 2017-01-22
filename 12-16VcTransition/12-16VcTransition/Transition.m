//
//  Transition.m
//  12-16VcTransition
//
//  Created by wyman on 2016/12/16.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "Transition.h"

@implementation Transition

/** 时长 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    // 1.获取转场控制器视图和容器视图
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // 因为默认加载xib的大小，在这调整一下吧。。。
    toVc.view.frame = fromVc.view.frame;
    

    if (self.type == TransitionTypePresent) {
        
        // 3.加到转场容器上面
        [containerView addSubview:toVc.view];
        
        // 4.容器上添加蒙层
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = containerView.bounds;
        effectView.alpha = 1;
        [containerView addSubview:effectView];
        
        // 5.
        [containerView addSubview:toVc.view];
        if (self.rectInWindow) {
            CGRect f = toVc.view.frame;
            f.origin = self.rectInWindow().origin;
            toVc.view.frame = f;
        }

        
//        toVc.view.alpha = 0.0f;
        [UIView animateWithDuration:1.0 animations:^{
            effectView.alpha = 0.1;
        }];
        
        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:200 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
             toVc.view.frame = fromVc.view.frame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            fromVc.view.hidden = NO;
            //            [snapView removeFromSuperview];
//            [effectView removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
//            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        
        
        
    } else {
        
    }
}

- (UIImageView *)snapVc:(UIViewController *)vc {
    UIGraphicsBeginImageContextWithOptions(vc.view.frame.size, NO, 0);
    [vc.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [[UIImageView alloc] initWithImage:image];
}




@end
