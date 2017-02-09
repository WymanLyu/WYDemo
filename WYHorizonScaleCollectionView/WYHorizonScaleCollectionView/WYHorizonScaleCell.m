//
//  WYHorizonScaleCell.m
//  WYHorizonScaleCollectionView
//
//  Created by wyman on 2017/2/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYHorizonScaleCell.h"

@implementation WYHorizonScaleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *imgView = [UILabel new];
        imgView.backgroundColor = [UIColor redColor];
        imgView.text= @"xsahkahkjh";
        [self.contentView addSubview:imgView];
        _imgView = imgView;
        
        UIView *discView = [UIView new];
        discView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:discView];
        _discView = discView;


    }
    return self;
}



- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    

    CGFloat scale = pow(layoutAttributes.alpha, 10);
    if (scale < 0.1) {
        scale = pow(layoutAttributes.alpha, 14);
    }
    if (scale < 0.05) {
        scale = 0;
    }
    
    CGFloat changeDiscW = (self.bounds.size.width - 150)*(scale);
    CGFloat defalutW = 150;

    // 保证整体居中
    CGFloat imgX = (185 -  defalutW - changeDiscW)*0.5;
    self.imgView.frame = CGRectMake(imgX, 0, defalutW, self.bounds.size.height);
    self.discView.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame), 0, changeDiscW, defalutW);
}


@end
