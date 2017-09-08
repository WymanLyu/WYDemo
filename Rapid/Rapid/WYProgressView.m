//
//  WYProgressView.m
//  Rapid
//
//  Created by wyman on 2017/9/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYProgressView.h"

@implementation WYProgressView

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [[UIColor redColor] set];
    UIRectFill(CGRectMake(0, 0, self.progress * rect.size.width, rect.size.height));
}


@end
