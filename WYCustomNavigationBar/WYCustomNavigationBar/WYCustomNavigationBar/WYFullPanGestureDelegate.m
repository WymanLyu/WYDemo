//
//  WYFullPanGestureDelegate.m
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYFullPanGestureDelegate.h"

@implementation WYFullPanGestureDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 触发回调
    if(self.recognizerShouldBeginHandle) {
        return self.recognizerShouldBeginHandle();
    }
    
    return YES;
}

@end
