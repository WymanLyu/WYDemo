//
//  WYSupplementaryLblView.m
//  WYHorizonScaleCollectionView
//
//  Created by wyman on 2017/2/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYSupplementaryLblView.h"

@interface WYSupplementaryLblView ()


@end

@implementation WYSupplementaryLblView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *titleLbl = [UILabel new];
        [self addSubview:titleLbl];
        _titleLbl = titleLbl;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // 保证其不偏移
    self.titleLbl.frame = self.bounds;

}





@end
