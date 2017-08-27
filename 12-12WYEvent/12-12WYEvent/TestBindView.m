//
//  TestBindView.m
//  12-12WYEvent
//
//  Created by wyman on 2017/8/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "TestBindView.h"
#import "NSObject+WYRuntime.h"

@interface TestBindView ()

@property (nonatomic, strong) UILabel *l;

@end

@implementation TestBindView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *l = [UILabel new];
        l.frame = CGRectMake(0, 0, 100, 100);
        l.backgroundColor = [UIColor grayColor];
        [self addSubview:l];
        _l = l;
    }
    return self;
}


- (void)setModel:(TestBindModel *)model {
    _model = model;
    self.l.text = [NSString stringWithFormat:@"%f元",_model.price];
    NSLog(@"价钱改变...");
    [self wy_bind:_model value:keyPath(_model, price)];
//    [self wy_bind:keyPath(_model.price)];
}



@end
