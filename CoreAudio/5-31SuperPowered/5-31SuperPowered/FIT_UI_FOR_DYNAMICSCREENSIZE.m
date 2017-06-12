//
//  FIT_UI_FOR_DYNAMICSCREENSIZE.m
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FIT_UI_FOR_DYNAMICSCREENSIZE.h"


@implementation FIT_UI_FOR_DYNAMICSCREENSIZE

#pragma mark - 设置数据

- (void)setViewModel:(NSObject *)viewModel {
    // 设置数据
}

#pragma mark - 布局

static double margin = 10; // 一些间距信息


- (void)layoutSubView {
    // 布局子控件
}

+ (double)caculateCellHeightForModel:(NSObject *)viewModel { // 这个接口可能是viewModel的一个协议，你在viewmodel拿到数据，作为交换你实现个cell高度给viewmodel不过分吧，【 不然你就要暴露一些 间距信息 和 布局信息出去了】或者【上帝角度写死在viewmodel】
    // 根据布局计算高度
    return 100;
}

#pragma mark - 事件
- (void)clickEvent {
    // 视图事件
}


@end
