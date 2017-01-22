//
//  TransitionViewController.m
//  12-16VcTransition
//
//  Created by wyman on 2016/12/16.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "TransitionViewController.h"
#import "Transition.h"

@interface TransitionViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) Transition *transition;

@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    // 配置转场代理
    self.transitioningDelegate = self;
    // 初始化转场对象
    self.transition = [Transition new];
    self.transition.rectInWindow = self.rectInWindow;

}

- (BOOL)prefersStatusBarHidden {
    　　return YES; // 返回NO表示要显示，返回YES将hiden
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[UIApplication sharedApplication].keyWindow performSelector:NSSelectorFromString(@"beginDisablingInterfaceAutorotation")];
    self.transition.type = TransitionTypePresent;
    return self.transition;
}

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//    //这里我们初始化dismissType
//    _transitionManage.type = HyPresentOneTransitionTypeDismiss;
//    return _transitionManage;
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
