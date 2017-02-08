//
//  WYHorizonScaleLayout.h
//  WYHorizonScaleCollectionView
//
//  Created by wyman on 2017/2/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYHorizonScaleCollectionView.h"

#define ITEMSIZE_WIDTH 185 // 185
#define ITEMSIZE_HEIGHT 150

static NSString * const kSupplementaryViewKind = @"kSupplementaryViewKind";

typedef enum : NSUInteger {
    HorizonScrollDirectionRight,
    HorizonScrollDirectionLeft,
} HorizonScrollDirection;

@interface WYHorizonScaleLayout : UICollectionViewFlowLayout

/** superview */
@property (nonatomic, weak) WYHorizonScaleCollectionView *fatherView;

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

/** 滚动方向 */
@property (nonatomic, assign) HorizonScrollDirection direction;

@end
