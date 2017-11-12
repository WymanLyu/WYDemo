//
//  TYBottomPlayView.m
//  3-10设计要看button
//
//  Created by wyman on 2017/9/29.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "TYBottomPlayView.h"

@implementation TYBottomPlayView

static void *BottomPlayViewObserveContext = &BottomPlayViewObserveContext;
- (instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame ]) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}
- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    self.superview.userInteractionEnabled = !hidden;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"---点击了");
    
}

@end
