//
//  UIView+WYCustomNavigationBar.h
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WYCustomNavigationBar)

/** 添加子控件的回调block */
@property (nonatomic, copy) void(^wy_addSubViewsFinishCallBack)();

@end
