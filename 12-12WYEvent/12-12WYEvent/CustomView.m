//
//  CustomView.m
//  12-12WYEvent
//
//  Created by wyman on 2017/2/9.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "CustomView.h"
#import "WYEvent.h"

@implementation CustomView

- (void)awakeFromNib {
    [super awakeFromNib];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UISlider class]]) {
            UISlider *slide = (UISlider *)subView;
            [slide addTarget:self action:@selector(slideChange:) forControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)slideChange:(UISlider *)slider {
    [self wy_sendEvent:@"CustomViewSliderChange" something:@(slider.value) callBack:^(__autoreleasing id *res) {
        NSLog(@"自定义事件控制器执行完毕-%f", [(id)*res floatValue]);
    }];
}


@end
