//
//  UIViewController+WYCustomNavigationBar.m
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIViewController+WYCustomNavigationBar.h"
#import <objc/runtime.h>
#import "UIView+WYCustomNavigationBar.h"
#import "WYFullPanGestureDelegate.h"

static const void *kWYNavgationBarKey = &kWYNavgationBarKey;
static const void *kWYFullScreenGestKey = &kWYFullScreenGestKey;
static const void *kWYFullPanGestureDelegateKey = &kWYFullPanGestureDelegateKey;

@implementation UIViewController (WYCustomNavigationBar)

+ (void)load {
    // runtime加载类时hook 原有的viewDidLoad，注册监听控制器view的subview变化
    Method oldViewDidLoadMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method newViewDidLoadMethod = class_getInstanceMethod([self class], @selector(wy_WYCustomNavigationBar_viewDidLoad));
    method_exchangeImplementations(oldViewDidLoadMethod, newViewDidLoadMethod);
}

#pragma mark - 关联自定义bar的属性，setter/getter方法

- (void)setWy_navgationBar:(WYCustomNavgationBar *)wy_navgationBar {
 
    // 添加控制器的自定义bar，有且仅当控制器为：非容器控制器/已经添加/专场控制器 时候 添加
    if (![self isKindOfClass:[UITabBarController class]] && ![self isKindOfClass:[UINavigationController class]] && (self.wy_navgationBar!=wy_navgationBar) && ![self isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingController")]) {
        wy_navgationBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        if (self.wy_navgationBar) {
            [self.wy_navgationBar removeFromSuperview];
        }
        [self.view addSubview:wy_navgationBar];
        if (self.navigationController.childViewControllers.count >= 2) {// 大于1则显示返回按钮
            if ([self.wy_navgationBar respondsToSelector:@selector(backBtn)]) {
                self.wy_navgationBar.backBtn.hidden = NO;
            }
        }
    }

    // 建立关联属性
    objc_setAssociatedObject(self, kWYNavgationBarKey, wy_navgationBar, OBJC_ASSOCIATION_ASSIGN);
}

- (WYCustomNavgationBar *)wy_navgationBar {
    return objc_getAssociatedObject(self, kWYNavgationBarKey);
}

- (void)setWy_fullScreenPopGestureEnabled:(BOOL)wy_fullScreenPopGestureEnabled {
    // 1.获取全屏手势
    UIGestureRecognizer *panGest = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        panGest = objc_getAssociatedObject(self, kWYFullScreenGestKey);
    } else {
        panGest = objc_getAssociatedObject(self.navigationController, kWYFullScreenGestKey);
    }
    // 2.设置手势是否失效
    panGest.enabled = wy_fullScreenPopGestureEnabled;
}

- (BOOL)wy_fullScreenPopGestureEnabled {
    // 获取全屏手势
    UIGestureRecognizer *panGest = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        panGest = objc_getAssociatedObject(self, kWYFullScreenGestKey);
    } else {
        panGest = objc_getAssociatedObject(self.navigationController, kWYFullScreenGestKey);
    }
    return panGest.isEnabled;
}

#pragma mark - hook控制器生命周期方法

- (void)wy_WYCustomNavigationBar_viewDidLoad {
    
    // 0.隐藏原生navigationBar
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVc = (UINavigationController *)self;
        [navVc setNavigationBarHidden:YES animated:NO];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    
    // 1.添加控制器的自定义bar，有且仅当控制器为：非容器控制器/已经添加/转场控制器 时候 添加
    if (![self isKindOfClass:[UITabBarController class]] && ![self isKindOfClass:[UINavigationController class]] && !self.wy_navgationBar && ![self isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingController")]) {
        WYCustomNavgationBar *customBar = [[WYCustomNavgationBar alloc]
                                           initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        [self.view addSubview:customBar];
        [self setWy_navgationBar:customBar];
        if (self.navigationController.childViewControllers.count >= 2) {// 大于1则显示返回按钮
            if ([self.wy_navgationBar respondsToSelector:@selector(backBtn)]) {
                 self.wy_navgationBar.backBtn.hidden = NO;
            }
        }
    }
    
    // 2.添加对视图addSubViews的回调
    __weak typeof(self)weakSelf = self;
    self.view.wy_addSubViewsFinishCallBack = ^{
        // 移动至最顶部
        [weakSelf.view bringSubviewToFront:weakSelf.wy_navgationBar];
    };
    
    // 3.针对Nav，增加全屏侧滑；针对在Nav管理控制器下的返回操作
    if ([self isKindOfClass:[UINavigationController class]] || self.navigationController) {
        __weak UINavigationController *navVc = (UINavigationController *)self;
        if ([self isKindOfClass:[UINavigationController class]]) { // 自己是导航控制器，则添加全屏手势
            // 3.1.创建全屏滑动手势，并利用原有的滑动动画实现
            UIGestureRecognizer *panGest= [[UIPanGestureRecognizer alloc] initWithTarget:navVc.interactivePopGestureRecognizer.delegate action: NSSelectorFromString(@"handleNavigationTransition:")];
            // 3.2.添加手势,并关联属性
            [navVc.view addGestureRecognizer:panGest];
            objc_setAssociatedObject(self, kWYFullScreenGestKey, panGest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            // 3.3.添加手势代理,设置在Nav根控制器时候，关闭全屏侧滑
            WYFullPanGestureDelegate *fullPanGestureDelegate = [WYFullPanGestureDelegate new];
            panGest.delegate = fullPanGestureDelegate;
            objc_setAssociatedObject(self, kWYFullPanGestureDelegateKey, fullPanGestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            fullPanGestureDelegate.recognizerShouldBeginHandle = ^() {
                if(weakSelf.childViewControllers.count == 1) {
                    return NO;
                }
                return YES;
            };
            // 3.3.禁止原生的侧滑
            navVc.interactivePopGestureRecognizer.enabled = NO;
                
        } else { // 自己不是导航，且在导航控制器管理下，则设置返回按钮
            
            // 3.4.设置返回按钮点击
            __weak UIViewController *weakSelf = self;
            if ([self.wy_navgationBar respondsToSelector:@selector(setCustomNavgationBackClick:)]) {
                self.wy_navgationBar.customNavgationBackClick = ^{
                    if (weakSelf.navigationController.childViewControllers.count >= 2) {// 大于1则pop回去
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                };
            }
        }
        
    }
    
    // 4.默认开启全屏手势
    [self setWy_fullScreenPopGestureEnabled:YES];
    
    // 5.执行默认样式
    NSMutableDictionary *appearanceDict = [WYCustomNavgationBarAppearance appearanceDict];
    NSString *currentVckey = NSStringFromClass([self.navigationController class]);
    [appearanceDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"ALL"]) { // 统一样式
            CustomBarSettingBlock block = (CustomBarSettingBlock)obj;
            if (block) {
                block(self);
            }
        } else if ([key isEqualToString:currentVckey]) { // 当前key就是当前控制器的导航控制器，则执行其样式
            CustomBarSettingBlock block = (CustomBarSettingBlock)obj;
            if (block) {
                block(self);
            }
        } else { // 没有样式
            
            
        }
    }];
    
    // 6.继续执行viewDidLoad
    [self wy_WYCustomNavigationBar_viewDidLoad];
    
}


@end
