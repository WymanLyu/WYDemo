//
//  FIT_UI.m
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

// 屏幕尺寸大小

#define iPhone_4_W 320.0
#define iPhone_4_H 480.0

#define iPhone_5_W 320.0
#define iPhone_5_H 568.0

#define iPhone_6_W 375.0
#define iPhone_6_H 667.0

#define iPhone_6P_W 414.0
#define iPhone_6P_H 736.0

// 屏幕适配 750×1334
#define fitW_6(w)  (((w)/(750.0))*([UIScreen mainScreen].bounds.size.width))
#define fitH_6(h)  (((h)/(1334.0))*([UIScreen mainScreen].bounds.size.height))

#define fitW_5(w)  (((w)/(750.0))*([UIScreen mainScreen].bounds.size.width))
#define fitH_5(h)  (((h)/(1334.0))*([UIScreen mainScreen].bounds.size.height))

#define fitW_4(w)  (((w)/(750.0))*([UIScreen mainScreen].bounds.size.width))
#define fitH_4(h)  (((h)/(1334.0))*([UIScreen mainScreen].bounds.size.height))

#define fitW_6P(w)  (((w)/(750.0))*([UIScreen mainScreen].bounds.size.width))
#define fitH_6P(h)  (((h)/(1334.0))*([UIScreen mainScreen].bounds.size.height))

//判断设备类型
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)



//如果不给的花需要等比:
//size.x = fit_base6() // 基于6做等比
//font.size = fit_base6p() // 基于6p做等比
//如果比例系数需要自定义：
//size.x = fit_base6().scale() // 基于6做等比 重新定义比例系数
//font.size = fit_base6p().scale()
//接口使用应该是这样的：
//size.x = fit6().fit5().fit6p().fit
//font.size = fit6().fit5().fit6p().fit
