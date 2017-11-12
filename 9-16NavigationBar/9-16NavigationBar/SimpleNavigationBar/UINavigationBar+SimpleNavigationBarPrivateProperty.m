//
//  UINavigationBar+SimpleNavigationBarPrivateProperty.m
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UINavigationBar+SimpleNavigationBarPrivateProperty.h"
#import "NSObject+SimpleNavigationBar.h"

@implementation UINavigationBar (SimpleNavigationBarPrivateProperty)

#pragma mark - 私有视图
/** 背景视图 */
- (UIView *)_sn_UIBarBackground {
    __block UIView *_sn_UIBarBackground = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj sn_isKindOfClassString:@"_UIBarBackground"]) {
            _sn_UIBarBackground = obj;
            *stop = YES;
        }
    }];
    return _sn_UIBarBackground;
}

/** 底部分割线 */
- (UIView *)_sn_UIImageViewBottomLine {
    __block UIView *_sn_UIImageViewBottomLine = nil;
    [self._sn_UIBarBackground.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj sn_isKindOfClassString:@"UIImageView"]) {
            if (obj.frame.origin.y > 0 ) {
                _sn_UIImageViewBottomLine = obj;
                *stop = YES;
            }
        }
    }];
    return _sn_UIImageViewBottomLine;
}

/** 模糊层 */
- (UIView *)_sn_UIVisualEffectView {
    __block UIView *_sn_UIVisualEffectView = nil;
    [self._sn_UIBarBackground.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj sn_isKindOfClassString:@"UIVisualEffectView"]) {
            _sn_UIVisualEffectView = obj;
            *stop = YES;
        }
    }];
    return _sn_UIVisualEffectView;
}

/** titleItemView */
- (UIView *)_sn_UINavigationItemView {
    __block UIView *_sn_UINavigationItemView = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj sn_isKindOfClassString:@"UINavigationItemView"]) {
            _sn_UINavigationItemView = obj;
            *stop = YES;
        }
    }];
    return _sn_UINavigationItemView;
}

/** 左侧文本ItemView */
- (UIView *)_sn_UINavigationItemButtonView {
    __block UIView *_sn_UINavigationItemButtonView = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj sn_isKindOfClassString:@"UINavigationItemButtonView"]) {
            _sn_UINavigationItemButtonView = obj;
            *stop = YES;
        }
    }];
    return _sn_UINavigationItemButtonView;
}
/** 左侧返回视图 */
- (UIView *)_sn_UINavigationBarBackIndicatorView {
    __block UIView *_UINavigationBarBackIndicatorView = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj sn_isKindOfClassString:@"_UINavigationBarBackIndicatorView"]) {
            _UINavigationBarBackIndicatorView = nil;
            *stop = YES;
        }
    }];
    return _UINavigationBarBackIndicatorView;
}

@end
