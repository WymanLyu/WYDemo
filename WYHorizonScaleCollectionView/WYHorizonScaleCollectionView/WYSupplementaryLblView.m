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
//     NSLog(@"%s", __func__);
    self.titleLbl.frame = self.bounds;
    
//    NSLog(@"%f", self.frame.size.width );// / (185 - 147)
    
    
}

- (void)setProgressScale:(CGFloat)progressScale {
    _progressScale = progressScale;
    
//    NSLog(@"xxxxxxxxxxxxxx---%f", _progressScale);
    
}

- (void)setTransform:(CGAffineTransform)transform {
    [super setTransform:transform];
    NSLog(@"%s", __func__);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
//    NSLog(@"%s", __func__);
}



@end
