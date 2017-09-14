//
//  SimpleNavgationBar.m
//  HeiPa
//
//  Created by wyman on 2017/9/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "SimpleNavgationBar.h"
#import <objc/runtime.h>

@interface SNKvoObject : NSObject

@end

@implementation SNKvoObject

static char titleKVOKey;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &titleKVOKey) {
        if ([keyPath isEqual:@"center"]) {
            CGPoint p = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
            NSLog(@"new --- %@", NSStringFromCGPoint(p));
        }
    }
}


@end

@interface UINavigationBar (SimpleNavgationBar)

- (void)sn_setBackgroundColor:(UIColor *)backgroundColor;
- (void)sn_reset;

@property (nonatomic, assign) CGFloat sn_alpha;
@property (nonatomic, assign) BOOL sn_bottomLineHidden;
@property (nonatomic, assign) BOOL sn_statusBarHidden;
@property (nonatomic, assign) float sn_translationY;
@property (nonatomic, weak) UIView *overlay;

@property (nonatomic, strong) SNKvoObject *sn_kvoObject;    // 监听者

@end

@interface UINavigationController (SimpleNavgationBar)
@property (nonatomic, assign) NSInteger sn_dontKeepSNState; // YES标示不要记录bar状态
- (void)sn_updateInteractiveTransition:(UIPanGestureRecognizer *)panGesture;

@end


@interface UIColor (SimpleNavgationBar)
+ (BOOL)isSimilarColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent;
@end

@interface UIViewController (_SimpleNavgationBar)
@property (nonatomic, strong) UIColor *sn_keepBackgroundColor; // 保存的背景色
@property (nonatomic, assign) CGFloat sn_keepAlpha;            // 保存的透明度
@property (nonatomic, assign) CGFloat sn_keepTranslationY;     // 保存的Y
@property (nonatomic, strong) UIView *sn_systemVisualEffect;   // 系统模糊层
@property (nonatomic, strong) UIView *sn_systemBottomLineView; // 底部线
@property (nonatomic, strong) UIColor *sn_customBarTransitionColor;         // 自定义nav转场时的颜色
@property (nonatomic, strong) id sn_interactivePopGestureRecognizerDelegate;// 自定义nav开启侧滑时的手势代理，需要还原

- (void)sn_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress;
@end

@implementation UINavigationBar (SimpleNavgationBar)
static char titleCenterKvoKey;
- (void)setSn_kvoObject:(SNKvoObject *)sn_kvoObject {
    objc_setAssociatedObject(self, &titleCenterKvoKey, sn_kvoObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SNKvoObject *)sn_kvoObject {
    SNKvoObject *kvoObj = objc_getAssociatedObject(self, &titleCenterKvoKey);
    if (!kvoObj) {
        kvoObj = [[SNKvoObject alloc] init];
        [self setSn_kvoObject:kvoObj];
    }
    return kvoObj;
}

- (void)sn_reset {
    // 重置前记录
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    self.sn_bottomLineHidden = NO;
}

#pragma mark - 属性

static char overlayKey;
static char statusBarHiddenKey;
static char translationYKey;

// 自定义view
- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)overlay {
    UIView *overlay = objc_getAssociatedObject(self, &overlayKey);
    if (!overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        overlay.userInteractionEnabled = NO;
        overlay.backgroundColor = [UIColor clearColor];
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [self setOverlay:overlay];
        [[self.subviews firstObject] insertSubview:overlay atIndex:0];
    }
    [[self.subviews firstObject] insertSubview:overlay atIndex:0];
    return overlay;
}

// 垂直尺寸
static bool needCunstomLayout = NO;
- (void)setSn_translationY:(float)sn_translationY {
    objc_setAssociatedObject(self, &translationYKey, @(sn_translationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitleVerticalPositionAdjustment:-sn_translationY forBarMetrics:UIBarMetricsDefault];
    needCunstomLayout = YES;
    CGRect f = self.frame;
    f.size.height = 44+sn_translationY;
    self.frame = f;
    CGFloat overlayH = self.sn_statusBarHidden?(44+sn_translationY):(44+20+sn_translationY);
    self.overlay.frame = CGRectMake(0, 0, self.overlay.frame.size.width, overlayH);
    [self sn_layoutSubviews];
}
- (float)sn_translationY {
     return [objc_getAssociatedObject(self, &translationYKey) floatValue];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = CGSizeMake(self.frame.size.width,self.sn_translationY+44);
    return newSize;
}

// 此处布局子控件
- (void)sn_layoutSubviews {
    if (!self.sn_translationY) { // 不是可变时不布局
        return;
    }
    // 获取私有控件
    NSArray *classNamesToReposition = @[@"_UIBarBackground",@"_UINavigationBarBackground", @"_UINavigationBarBackIndicatorView", @"UINavigationItemView", @"UINavigationItemButtonView"];
    UIView *_snUIBarBackground = nil;
    UIView *_snUINavigationBarBackground = nil;
    UIView *_snUINavigationBarBackIndicatorView = nil;
    UIView *_snUINavigationItemView = nil;
    UIView *_snUINavigationItemButtonView = nil;
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:NSClassFromString(classNamesToReposition[0])]) {
            _snUIBarBackground = view;
        } else if ([view isKindOfClass:NSClassFromString(classNamesToReposition[1])]) {
            _snUINavigationBarBackground = view;
        } else if ([view isKindOfClass:NSClassFromString(classNamesToReposition[2])]) {
            _snUINavigationBarBackIndicatorView = view;
        } else if ([NSStringFromClass(view.class) isEqualToString:classNamesToReposition[3]]){ // 因为UINavigationItemButtonView是UINavigationItemView子类
            _snUINavigationItemView = view;
        } else if ([NSStringFromClass(view.class) isEqualToString:classNamesToReposition[4]]){
            _snUINavigationItemButtonView = view;
        } else {
            
        }
    }
    
    // 设置下划线居下
    for (UIView *subView in _snUIBarBackground.subviews) {
        if ([subView isKindOfClass:[UIImageView class]] && subView.frame.origin.y) {
            [subView.layer removeAllAnimations]; // 干掉在动画时的偏移
            CGRect frame = [subView frame];
            frame.origin.y = [self bounds].size.height + 20.f - frame.size.height;
            [subView setFrame:frame];
        }
    }
    
    // 内容背景随动
    CGRect frame = [_snUIBarBackground frame];
    frame.size.height = [self bounds].size.height + 20.f;
    [_snUIBarBackground setFrame:frame];
    
    CGRect frame1 = [_snUINavigationBarBackground frame];
    frame1.size.height = [self bounds].size.height + 20.f;
    [_snUINavigationBarBackground setFrame:frame1];
    
    // 文字控件重排布
    CGPoint titleCenterInBar = CGPointZero;
    for (UIView *view in _snUINavigationItemView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            titleCenterInBar = [view.superview convertPoint:view.center toView:_snUIBarBackground];
        }
    }
    for (UIView *view in _snUINavigationItemButtonView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view.layer removeAllAnimations]; // 干掉在动画时的偏移
            CGPoint center = [view center];
            center.y = [_snUIBarBackground convertPoint:titleCenterInBar toView:view.superview].y;
            [view setCenter:center];
            // 尝试KVO该属性，貌似不行。不要打开，未写移除逻辑会crash
//            [view addObserver:self.sn_kvoObject forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    [_snUINavigationBarBackIndicatorView setCenter:CGPointMake(_snUINavigationBarBackIndicatorView.center.x, [_snUIBarBackground convertPoint:titleCenterInBar toView:_snUINavigationBarBackIndicatorView.superview].y)];
}

// 状态条隐藏
- (void)setSn_statusBarHidden:(BOOL)sn_statusBarHidden {
    objc_setAssociatedObject(self, &statusBarHiddenKey, @(sn_statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CGFloat overlayH = sn_statusBarHidden?(CGRectGetHeight(self.overlay.bounds)-20):(CGRectGetHeight(self.overlay.bounds)+20);
    self.overlay.frame = CGRectMake(0, 0, self.overlay.frame.size.width, overlayH);
}
- (BOOL)sn_statusBarHidden {
    NSNumber *statusBarHidden = (NSNumber *)objc_getAssociatedObject(self, &statusBarHiddenKey);
    return statusBarHidden.boolValue;
}

// 透明度
- (void)setSn_alpha:(CGFloat)sn_alpha {
    self.overlay.alpha = sn_alpha;
}
- (CGFloat)sn_alpha {
    return self.overlay.alpha;
}

// 下划线
- (void)setSn_bottomLineHidden:(BOOL)sn_bottomLineHidden {
    UIImage *shadowImg = nil;
    if (sn_bottomLineHidden) shadowImg=[[UIImage alloc] init];
    self.shadowImage = shadowImg;
}
- (BOOL)sn_bottomLineHidden {
    return (self.shadowImage) ? YES : NO;
}


#pragma mark - 方法

- (void)sn_setBackgroundColor:(UIColor *)backgroundColor {
    self.overlay.backgroundColor = backgroundColor;
}

- (void)sn_setTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

@end

@implementation UIViewController (_SimpleNavgationBar)
@dynamic sn_keepBackgroundColor, sn_keepAlpha;
static char keepBackgroundColorKey;
static char keepAlphaKey;
static char keepTranslationYKey;
static char systemVisualEffectViewKey;
static char systemBottomLineViewKey;
static char sn_customBarTransitionColorKey;
static char sn_interactivePopGestureRecognizerDelegateKey;

- (void)sn_addGuestTarget {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.interactivePopGestureRecognizer addTarget:nav action:@selector(sn_updateInteractiveTransition:)]; // 增加手势方法,处理转场
}
- (void)sn_layoutBar {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.navigationBar sn_layoutSubviews];
}

#pragma mark - 属性
// 转场时系统手势代理
- (void)setSn_interactivePopGestureRecognizerDelegate:(id)sn_interactivePopGestureRecognizerDelegate {
    objc_setAssociatedObject(self, &sn_interactivePopGestureRecognizerDelegateKey, sn_interactivePopGestureRecognizerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)sn_interactivePopGestureRecognizerDelegate {
    return (id)objc_getAssociatedObject(self, &sn_interactivePopGestureRecognizerDelegateKey);
}

// 转场自定义bar的颜色
- (void)setSn_customBarTransitionColor:(UIColor *)sn_customBarTransitionColor {
      objc_setAssociatedObject(self, &sn_customBarTransitionColorKey, sn_customBarTransitionColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)sn_customBarTransitionColor {
    return (UIColor *)objc_getAssociatedObject(self, &sn_customBarTransitionColorKey);
}

// 系统底部线
- (void)setSn_systemBottomLineView:(UIView *)sn_systemBottomLineView {
    [self sn_addGuestTarget];
    [self sn_layoutBar];
    objc_setAssociatedObject(self, &systemBottomLineViewKey, sn_systemBottomLineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)sn_systemBottomLineView {
     return (UIView *)objc_getAssociatedObject(self, &systemBottomLineViewKey);
}

// 系统模糊层
- (void)setSn_systemVisualEffect:(UIView *)sn_systemVisualEffect {
    [self sn_addGuestTarget];
    [self sn_layoutBar];
    objc_setAssociatedObject(self, &systemVisualEffectViewKey, sn_systemVisualEffect, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sn_systemVisualEffect {
    return (UIView *)objc_getAssociatedObject(self, &systemVisualEffectViewKey);
}

// 保存Y
- (void)setSn_keepTranslationY:(CGFloat)sn_keepTranslationY {
    [self sn_addGuestTarget];
    [self sn_layoutBar];
    objc_setAssociatedObject(self, &keepTranslationYKey, @(sn_keepTranslationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)sn_keepTranslationY {
    NSNumber *translationY = (NSNumber *)objc_getAssociatedObject(self, &keepTranslationYKey);
    return translationY.floatValue;
}

// 保存的透明度
- (void)setSn_keepAlpha:(CGFloat )sn_keepAlpha {
    [self sn_addGuestTarget];
    [self sn_layoutBar];
    objc_setAssociatedObject(self, &keepAlphaKey, @(sn_keepAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)sn_keepAlpha {
    NSNumber *alpha = (NSNumber *)objc_getAssociatedObject(self, &keepAlphaKey);
    return alpha.floatValue;
}

// 保存的背景色
- (void)setSn_keepBackgroundColor:(UIColor *)sn_keepBackgroundColor {
    [self sn_addGuestTarget];
    [self sn_layoutBar];
    objc_setAssociatedObject(self, &keepBackgroundColorKey, sn_keepBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)sn_keepBackgroundColor {
    return (UIColor *)objc_getAssociatedObject(self, &keepBackgroundColorKey);
}

#pragma mark - 方法
// 更新颜色
- (void)sn_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress {
    if (toVC.navigationController.isNavigationBarHidden ||
        fromVC.navigationController.isNavigationBarHidden) {
        return;
    }
    // 颜色
    UIColor *fromBarColor = fromVC.sn_keepBackgroundColor;
    UIColor *toBarColor = toVC.sn_keepBackgroundColor;
    if (!toBarColor) {
        toBarColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if (!fromBarColor) {
        fromBarColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if (!fromBarColor || !toBarColor) {
        return;
    }
    UIColor *newBarTintColor = [UIColor middleColor:fromBarColor toColor:toBarColor percent:progress];
    if ([UIColor isSimilarColor:fromBarColor toColor:toBarColor]) { // 渐变才设置
        toVC.sn_navBarBackgroundColor = newBarTintColor; // 这里因为苹果默认的转场时的bar是取toVC的进行模糊
    }
    CGFloat fromBarAlpha = fromVC.sn_keepAlpha;
    CGFloat toBarAlpha = toVC.sn_keepAlpha;
    CGFloat newBarAlpha = fromBarAlpha + (toBarAlpha-fromBarAlpha)*progress;
    toVC.sn_navBarAlpha = newBarAlpha; // 这里因为苹果默认的转场时的bar是取toVC的进行模糊
    
    // 不同高度bar的手势,增加高度
    CGFloat h= (toVC.sn_keepTranslationY-fromVC.sn_keepTranslationY)*progress + fromVC.sn_keepTranslationY;
    // 强行干掉下边线和模糊变大（或者干掉）
    [toVC.navigationController.navigationBar sn_layoutSubviews]; // 布局
    [fromVC.navigationController.navigationBar sn_layoutSubviews]; // 布局
    [[toVC.navigationController.navigationBar.subviews[0] subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]] && obj.frame.origin.y) {
            toVC.sn_systemBottomLineView = obj; // 只记录
        }
        if ([obj isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
            if (fromVC.sn_keepBackgroundColor && toVC.sn_keepBackgroundColor) { //都是自定义
                obj.hidden = YES;    // 结束时要显示回去
            }
            toVC.sn_systemVisualEffect = obj;
            fromVC.sn_systemVisualEffect = obj;
        }
    }];
    if (!fromVC.sn_keepBackgroundColor || !toVC.sn_keepBackgroundColor) { // 存在系统则模糊
        toVC.sn_systemVisualEffect.hidden = NO;
        CGRect f = toVC.navigationController.navigationBar.subviews[0].frame;
        f.size.height = 64+h;
        toVC.navigationController.navigationBar.subviews[0].frame = f;
    }
    
    // 设置导航栏高度
//    NSLog(@"从%f->%f,手势设置高度%f--进度:%f", fromVC.sn_keepTranslationY, toVC.sn_keepTranslationY, h, progress);
    toVC.sn_translationY = h;
    fromVC.sn_translationY = h;
    
    // 自定义bar
    if (fromVC.sn_customBar && fromVC.sn_smoothTransitionToCustomBar) {
        [toVC.navigationController.navigationBar.overlay addSubview:fromVC.sn_customBar];
        fromVC.sn_customBar.backgroundColor = [UIColor clearColor];
        fromVC.sn_customBar.alpha = (1-progress)*(1-progress)*(1-progress)*(1-progress)*(1-progress);
    }
}

@end

@implementation UIViewController (SimpleNavgationBar)

static char barStyleKey;
static char statusBarStyleKey;
static char sn_statusBarHiddenKey;
static char sn_customBarKey;
static char sn_smoothTransitionToCustomBarKey;

- (void)sn_reset {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    // 动画中途取消调用viewWillDisappear时，获取的bar不是自身所需的...
    if (!nav.sn_dontKeepSNState) { // 只有在非中断状态记录
        self.sn_keepBackgroundColor = self.sn_navBarBackgroundColor;
        self.sn_keepAlpha = self.sn_navBarAlpha;
        self.sn_keepTranslationY = self.sn_translationY;
    }
    self.sn_barStyle = UIBarStyleDefault;
    self.sn_statusBarStyle = UIStatusBarStyleDefault;
    self.sn_statusBarHidden = NO;
    self.sn_statusBarBackgroundColor = [UIColor clearColor];
    self.sn_navBarBottomLineHidden = NO;
    self.sn_translationY = 0;
    [self resetNavBarSystemView];
    [self.navigationController.navigationBar sn_reset];
    if (self.sn_interactivePopGestureRecognizerDelegate) { // 还原代理
        nav.interactivePopGestureRecognizer.delegate = self.sn_interactivePopGestureRecognizerDelegate ;
        self.sn_interactivePopGestureRecognizerDelegate = nil;
    }
}

- (void)resetNavBarSystemView {
    self.sn_systemBottomLineView.hidden = NO; // 结束时显示回来
}

// 隐藏
- (void)sn_navBarHidden:(BOOL)animated {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav setNavigationBarHidden:YES animated:animated];
}
- (void)sn_navBarShow:(BOOL)animated {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav setNavigationBarHidden:NO animated:animated];
}

// 侧滑开关
- (void)sn_openScreenPop {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    if (!self.sn_interactivePopGestureRecognizerDelegate) { // 保存代理
        self.sn_interactivePopGestureRecognizerDelegate = nav.interactivePopGestureRecognizer.delegate;
        nav.interactivePopGestureRecognizer.delegate = (id)nav;
    }
}

// 是否顺换过度自定义bar
- (void)setSn_smoothTransitionToCustomBar:(BOOL)sn_smoothTransitionToCustomBar {
    objc_setAssociatedObject(self, &sn_smoothTransitionToCustomBarKey, @(sn_smoothTransitionToCustomBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)sn_smoothTransitionToCustomBar {
    return (BOOL)[objc_getAssociatedObject(self, &sn_smoothTransitionToCustomBarKey) boolValue];
}

// 自定义bar
- (void)setSn_customBar:(UIView *)sn_customBar {
    if (!sn_customBar) return;
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.navigationBar.overlay removeFromSuperview];
    nav.navigationBar.overlay = sn_customBar;
    CGFloat overlayH = nav.navigationBar.sn_statusBarHidden?(44+nav.navigationBar.sn_translationY):(44+20+nav.navigationBar.sn_translationY);
    sn_customBar.frame = CGRectMake(0, 0, nav.navigationBar.bounds.size.width, overlayH);
    [[nav.navigationBar.subviews firstObject] insertSubview:nav.navigationBar.overlay atIndex:0];
    // 开启侧滑
    if (!self.sn_interactivePopGestureRecognizerDelegate) { // 保存代理
        self.sn_interactivePopGestureRecognizerDelegate = nav.interactivePopGestureRecognizer.delegate;
    }
    nav.interactivePopGestureRecognizer.delegate = (id)nav;
    // 隐藏视图
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView.hidden = YES;
    self.sn_navBarBottomLineHidden = YES;
    self.title = @"";
    // 转场记录色彩
    self.sn_customBarTransitionColor = sn_customBar.backgroundColor;
    objc_setAssociatedObject(self, &sn_customBarKey, sn_customBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)sn_customBar {
    return objc_getAssociatedObject(self, &sn_customBarKey);
}

// 垂直尺寸
- (void)setSn_translationY:(float)sn_translationY {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    nav.navigationBar.sn_translationY = sn_translationY;
}
- (float)sn_translationY {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.sn_translationY;
}

// 状态条颜色
- (void)setSn_statusBarBackgroundColor:(UIColor *)sn_statusBarBackgroundColor {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = sn_statusBarBackgroundColor;
    }
}
- (UIColor *)sn_statusBarBackgroundColor {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        return statusBar.backgroundColor;
    } else {
        return nil;
    }
}

// 状态条隐藏
- (void)setSn_statusBarHidden:(BOOL)sn_statusBarHidden {
    [self sn_addGuestTarget];
    objc_setAssociatedObject(self, &sn_statusBarHiddenKey, @(sn_statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    nav.navigationBar.sn_statusBarHidden = sn_statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (BOOL)sn_statusBarHidden {
    NSNumber *statusBarHidden = (NSNumber *)objc_getAssociatedObject(self, &sn_statusBarHiddenKey);
    return statusBarHidden.boolValue;
}
- (BOOL)prefersStatusBarHidden {
    return self.sn_statusBarHidden;
}
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
//    return UIStatusBarAnimationSlide;
//}

// 状态条样式
- (void)setSn_statusBarStyle:(UIStatusBarStyle)sn_statusBarStyle {
    [self sn_addGuestTarget];
    objc_setAssociatedObject(self, &statusBarStyleKey, @(sn_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}
- (UIStatusBarStyle)sn_statusBarStyle {
    NSNumber *statusBarStyle = (NSNumber *)objc_getAssociatedObject(self, &statusBarStyleKey);
    return statusBarStyle.integerValue;
}


// 导航栏样式
- (void)setSn_barStyle:(UIBarStyle)sn_barStyle {
    [self sn_addGuestTarget];
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    nav.navigationBar.barStyle = sn_barStyle;
    objc_setAssociatedObject(self, &barStyleKey, @(sn_barStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIBarStyle)sn_barStyle {
    NSNumber *barStyle = (NSNumber *)objc_getAssociatedObject(self, &barStyleKey);
    return barStyle.integerValue;
}

// 透明度
- (void)setSn_navBarAlpha:(CGFloat)sn_navBarAlpha {
    [self sn_addGuestTarget];
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.navigationBar setSn_alpha:sn_navBarAlpha];
}
- (CGFloat)sn_navBarAlpha {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.sn_alpha;
}

// 背景色
- (void)setSn_navBarBackgroundColor:(UIColor *)sn_navBarBackgroundColor {
    [self sn_addGuestTarget];
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.navigationBar sn_setBackgroundColor:sn_navBarBackgroundColor];
}
- (UIColor *)sn_navBarBackgroundColor {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.overlay.backgroundColor;
}

// 底部条
- (void)setSn_navBarBottomLineHidden:(BOOL)sn_navBarBottomLineHidden {
    [self sn_addGuestTarget];
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    nav.navigationBar.sn_bottomLineHidden = sn_navBarBottomLineHidden;
}
- (BOOL)sn_navBarBottomLineHidden {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav.navigationBar.sn_bottomLineHidden;
}

@end

@implementation UINavigationController (SimpleNavgationBar)

static char sn_dontKeepSNStateKey;

- (void)setSn_dontKeepSNState:(NSInteger)sn_dontKeepSNState {
    objc_setAssociatedObject(self, &sn_dontKeepSNStateKey, @(sn_dontKeepSNState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)sn_dontKeepSNState {
   return [(NSNumber *)objc_getAssociatedObject(self, &sn_dontKeepSNStateKey) integerValue];
}

#pragma mark - 处理statusBar

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return topVC.sn_statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

#pragma mark - 处理手势返回
- (void)sn_updateInteractiveTransition:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            CGFloat persent = transitionX / panGesture.view.frame.size.width;
            UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
//            if (persent < 0.01) { // 刚开始时不要触发渐变【等viewWillAppear调用后再进行】
//                return;
//            }
            [self sn_updateNavigationBarWithFromVC:fromVC toVC:toVC progress:persent];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
        }
        case UIGestureRecognizerStateEnded:{
        }
            break;
        default:
            
            break;
    }
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
//    popToVC.sn_navBarBottomLineHidden = YES; // pop时必须隐藏底部线
    if (popToVC.sn_keepBackgroundColor) { // pop到自定义的,在此触发干掉原导航模糊层
        [self sn_navBarBackgroundColor];
    } else {  // pop到原生的,需要对原生vc进行reset
        self.sn_dontKeepSNState++;
        [popToVC sn_reset];
        self.sn_dontKeepSNState--;
    }
    [self popToViewController:popToVC animated:YES];
    return YES;
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key){
        UIColor *curColor = [[context viewControllerForKey:key] sn_keepBackgroundColor];
        CGFloat curAlpha = [[context viewControllerForKey:key] sn_keepAlpha];
        CGFloat curY = [[context viewControllerForKey:key] sn_keepTranslationY];
        UIViewController *targetVc = [context viewControllerForKey:key];
        targetVc.sn_navBarAlpha = curAlpha;
        targetVc.sn_navBarBackgroundColor = curColor;
        targetVc.sn_translationY = curY;
    };
    if ([context isCancelled] == YES) { // 回到fromVc状态
        double cancelDuration = [context transitionDuration] * [context percentComplete];
        UIViewController *fromVc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
         // 处理有自定义导航
        if (fromVc.sn_customBar) {
            [fromVc.sn_customBar removeFromSuperview];
            fromVc.sn_customBar.backgroundColor = fromVc.sn_customBarTransitionColor;
            fromVc.sn_customBar.alpha = 1.0;
            [fromVc setSn_customBar:fromVc.sn_customBar];
        }
        __weak typeof(self)weakSelf = self;
        weakSelf.sn_dontKeepSNState++; // 加锁
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.sn_dontKeepSNState--; // 解锁
            });
            [weakSelf sn_layoutBar]; // 布局一下
            // 处理有自定义导航
            if (fromVc.sn_customBar) {
                [fromVc.sn_customBar removeFromSuperview];
                fromVc.sn_customBar.backgroundColor = fromVc.sn_customBarTransitionColor;
                fromVc.sn_customBar.alpha = 1.0;
                [fromVc setSn_customBar:fromVc.sn_customBar];
            }
        }];
    } else { // 完成toVc剩下的动画
        __weak typeof(self)weakSelf = self;
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        UIViewController *fromVc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        } completion:^(BOOL finished) {
            UIColor *curColor = [[context viewControllerForKey:UITransitionContextToViewControllerKey] sn_keepBackgroundColor];
            CGFloat curAlpha = [[context viewControllerForKey:UITransitionContextToViewControllerKey] sn_keepAlpha];
            CGFloat curY = [[context viewControllerForKey:UITransitionContextToViewControllerKey] sn_keepTranslationY];
            UIViewController *targetVc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
            weakSelf.sn_navBarAlpha = curAlpha;
            weakSelf.sn_navBarBackgroundColor = curColor;
            targetVc.sn_translationY = curY;
            if (![targetVc sn_keepBackgroundColor]) { // pop到系统的要reset一下
                weakSelf.sn_dontKeepSNState++;
                [targetVc sn_reset];
                weakSelf.sn_dontKeepSNState--;
            }
            [weakSelf sn_layoutBar]; // 布局一下
             // 处理有自定义导航
            if (fromVc.sn_customBar) {
                [fromVc.sn_customBar removeFromSuperview];
                [fromVc sn_reset];
            }
        }];
    }
}

@end

@implementation UIColor (SimpleNavgationBar)
+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

+ (BOOL)isSimilarColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = (toRed - fromRed) / 255.0;
    CGFloat newGreen = (toGreen - fromGreen) / 255.0;
    CGFloat newBlue = (toBlue - fromBlue) / 255.0;
    CGFloat newAlpha = (toAlpha - fromAlpha);
    if (newRed > 0.05 ||
        newGreen > 0.05 ||
        newBlue > 0.05 ||
        newAlpha > 0.05 ) {
        return NO;
    } else {
        return YES;
    }
}

@end



