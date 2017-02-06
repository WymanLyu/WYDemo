//
//  WYFullPanGestureDelegate.h
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYFullPanGestureDelegate : NSObject <UIGestureRecognizerDelegate>

/** 手势触发回调 */
@property (nonatomic, copy) BOOL(^recognizerShouldBeginHandle)();

@end
