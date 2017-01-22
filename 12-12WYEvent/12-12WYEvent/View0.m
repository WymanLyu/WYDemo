//
//  View0.m
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "View0.h"
#import "View1.h"

@implementation View0

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        View1 *view = [View1 new];
        view.frame = CGRectMake(10, 20, 222, 333);
        view.backgroundColor = [UIColor yellowColor];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        [self addSubview:view];
    }
    return self;
}


- (void)click:(UITapGestureRecognizer *)tap {
    NSLog(@"View0响应");
    
    [WYEventCenter wy_observeHandingEvent:@"ssss" handle:^(id noti, id *re) {
        *re = @(1011);
        NSLog(@"--%@ view0。。。", noti);
    }];
}

@end
