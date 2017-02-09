//
//  WYHorizonScaleCollectionView.h
//  WYHorizonScaleCollectionView
//
//  Created by wyman on 2017/2/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYHorizonScaleCollectionView : UIView


/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

// 获取模型索引
- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index;

@end
