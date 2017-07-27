//
//  FXBaseView.m
//  FXAudioSDKDemo
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "FXBaseView.h"

@implementation FXBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UILabel *lbl = [UILabel new];
        [self addSubview:lbl];
        self.FXName = lbl;
        self.FXName.frame = CGRectMake(15, 15, 88, 44);
        
        UISwitch *enble = [UISwitch new];
        [self addSubview:enble];
        [enble addTarget:self action:@selector(enble:) forControlEvents:UIControlEventValueChanged];
        enble.frame = CGRectMake(350, 0, 44, 44);
    }
    return self;
}

- (void)enble:(UISwitch *)enbleSwitch {
// 子类重写
}

+ (id)viewFromNibNamed:(NSString*)nibName owner:(id)owner{
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    return [nibView firstObject];
}

@end
