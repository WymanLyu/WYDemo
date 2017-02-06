//
//  WYCustomNavgationBar.m
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYCustomNavgationBar.h"

@implementation WYCustomNavgationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 1.模糊效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = self.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:blurView];
        _blurView = blurView;
        
        // 2.返回按钮
        UIButton *backBtn = [UIButton new];
        backBtn.frame = CGRectMake(0, 20, 44, 44);
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        backBtn.hidden = YES;
        _backBtn = backBtn;
        
        // 3.分割线
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.75;
        lineView.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
        [self addSubview:lineView];
        _lineView = lineView;
        
    }
    return self;
}

- (void)back:(UIButton *)backBtn {
    if (self.customNavgationBackClick) {
        self.customNavgationBackClick();
    }
}

@end



// 统一样式
@implementation WYCustomNavgationBarAppearance

static NSMutableDictionary *appearanceDict = nil;

// 配置viewControllerClass的导航类型控制器的，自定义导航样式，会在viewdidload之前调用customBarSetting
+ (void)appearanceWithClass:(Class)viewControllerClass customBar:(void(^)(UIViewController *currentVc))customBarSetting {
    
    // 0.校验是否是导航控制器
    if (![viewControllerClass isSubclassOfClass:[UINavigationController class]] && viewControllerClass) return;
    
    // 1.样式字典
    if (!appearanceDict) {
        appearanceDict = [NSMutableDictionary dictionary];
    }
    
    // 2.取出对应样式并设置样式
    WYCustomNavgationBarAppearance *appearance = nil;
    if (viewControllerClass) {
        appearance = [appearanceDict objectForKey:NSStringFromClass(viewControllerClass)];
        if (!appearance) {
            [appearanceDict setObject:customBarSetting forKey:NSStringFromClass(viewControllerClass)];
        }
    } else {
        appearance = [appearanceDict objectForKey:@"ALL"];
        if (!appearance) {
            [appearanceDict setObject:customBarSetting forKey:@"ALL"];
        }
    }

}

+ (NSMutableDictionary *)appearanceDict {
    return appearanceDict;
}

@end












