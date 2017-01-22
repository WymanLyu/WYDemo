//
//  WYMagicBannerCell.h
//  KLParallaxView
//
//  Created by wyman on 2017/1/6.
//  Copyright © 2017年 dara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYMagicBanner.h"
#import "WYMagicView.h"

@interface WYMagicBannerCell : UICollectionViewCell

/** 讲collectionView传入，是为了控制cell的点击和视差点击的区分【其实应该写代理或block比较合理，不过懒。。】 */
@property (nonatomic, weak) UICollectionView *col;
@property (nonatomic, weak) WYMagicBanner *banner;

@property (nonatomic, weak) WYMagicView *parallaxView;

@end
