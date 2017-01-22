//
//  WYCustomTouchCollectionView.m
//  KLParallaxView
//
//  Created by wyman on 2017/1/6.
//  Copyright © 2017年 dara. All rights reserved.
//

#import "WYCustomTouchCollectionView.h"
#import "WYMagicBannerCell.h"


@implementation WYCustomTouchCollectionView

//当设置canCancelContentTouches=YES时，触摸事件响应前会调用该方法，是否允许取消contentView的事件
- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    NSLog(@"%s", __func__);
    return NO;
}




//在触摸事件开始相应前调用
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
     NSLog(@"%s", __func__);
    return YES;
}






@end
