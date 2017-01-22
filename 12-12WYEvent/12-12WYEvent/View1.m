//
//  View1.m
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "View1.h"

@implementation View1

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(50,70, 22, 33);
        view.backgroundColor = [UIColor redColor];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        [self addSubview:view];
    }
    return self;
}


- (void)click:(UITapGestureRecognizer *)tap {
     NSLog(@"View1响应");
//    [WYEventCenter wy_sendEvent:@"ssss" something:@(1231) callBack:^(id *res) {
//        NSLog(@"-=-=%@ 控制器执行完毕。。。", *res);
//    }];
    
    [self wy_sendEvent:@"ssss" something:@(1231) callBack:^(__autoreleasing id *res) {
        NSLog(@"-=-=%@ 执行完毕。。。", *res);
    }];
}

@end
