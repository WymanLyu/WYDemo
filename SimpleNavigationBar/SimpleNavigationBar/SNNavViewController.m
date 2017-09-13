//
//  SNNavViewController.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "SNNavViewController.h"
#import "SNNavTransition.h"
#import "SimpleNavgationBar.h"
#import <objc/runtime.h>

@interface SNNavViewController ()

@property (nonatomic, strong) SNNavTransition *navTransition;

@end

@implementation SNNavViewController

void sn_handleGesture() {
    NSLog(@"----");
}

- (void)wr_updateInteractiveTransition:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"开始手势...");
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (!self.sn_dontKeepSNState) {
                CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
                CGFloat persent = transitionX / panGesture.view.frame.size.width;
                UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
                UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
                [self sn_updateNavigationBarWithFromVC:fromVC toVC:toVC progress:persent];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"手势取消...");
        }
        case UIGestureRecognizerStateEnded:{
            NSLog(@"停止手势...");
        }
            break;
        default:
            
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    class_addMethod([self class], @selector(sn_handleGesture), (IMP)sn_handleGesture, "v");
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(wr_updateInteractiveTransition:)]; // 偷换系统手势方法
//    [self.interactivePopGestureRecognizer addTarget:self action:@selector(sn_andleGesture)]; // 偷换系统手势方法
    
//    _navTransition = [SNNavTransition new];
//    _navTransition.navVc = self;
//    self.delegate = _navTransition; //  push 执行代理 pop后清空 ... 0x17403dba0
//    self.transitioningDelegate = _navTransition; // pop 执行代理 // 0x17403dba0
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    self.delegate = _navTransition;
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}


#pragma mark - 处理中断
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __weak typeof (self) weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    if ([coor initiallyInteractive] == YES) {
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        // 状态回调都在控制器will生命周期前触发
        if ([sysVersion floatValue] >= 10) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        } else {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    [self.navigationController popToViewController:popToVC animated:YES];
    return YES;
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    self.sn_dontKeepSNState = YES;
    NSLog(@"中断...");
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key){
        UIColor *curColor = [[context viewControllerForKey:key] sn_keepBackgroundColor];
        CGFloat curAlpha = [[context viewControllerForKey:key] sn_keepAlpha];
        UIViewController *targetVc = [context viewControllerForKey:key];
        targetVc.sn_navBarAlpha = curAlpha;
        targetVc.sn_navBarBackgroundColor = curColor;
    };
    if ([context isCancelled] == YES) { // 回到fromVc状态
        double cancelDuration = [context transitionDuration] * [context percentComplete];
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        } completion:^(BOOL finished) {
            UIColor *curColor = [[context viewControllerForKey:UITransitionContextFromViewControllerKey] sn_keepBackgroundColor];
            CGFloat curAlpha = [[context viewControllerForKey:UITransitionContextFromViewControllerKey] sn_keepAlpha];
            UIViewController *targetVc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
            weakSelf.sn_navBarAlpha = curAlpha;
            weakSelf.sn_navBarBackgroundColor = curColor;
            weakSelf.sn_dontKeepSNState = NO;
            NSLog(@"中断后返回动画结束-%@-%f ***** %@-%f", targetVc.sn_navBarBackgroundColor, targetVc.sn_navBarAlpha, curColor, curAlpha);
        }];
    } else { // 完成toVc剩下的动画
         __weak typeof(self)weakSelf = self;
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        } completion:^(BOOL finished) {
            UIColor *curColor = [[context viewControllerForKey:UITransitionContextToViewControllerKey] sn_keepBackgroundColor];
            CGFloat curAlpha = [[context viewControllerForKey:UITransitionContextToViewControllerKey] sn_keepAlpha];
            UIViewController *targetVc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
            weakSelf.sn_navBarAlpha = curAlpha;
            weakSelf.sn_navBarBackgroundColor = curColor;
//            weakSelf.sn_dontKeepSNState = NO;
            NSLog(@"中断后补充动画结束-%@-%f ***** %@-%f", targetVc.sn_navBarBackgroundColor, targetVc.sn_navBarAlpha, curColor, curAlpha);
        }];
    }
}


@end
