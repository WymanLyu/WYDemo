//
//  NSIndexPath+Movie.m
//  8-5MovieCollTest
//
//  Created by wyman on 2017/8/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "NSIndexPath+Movie.h"

@implementation NSIndexPath (Movie)

+ (NSArray<NSArray <NSIndexPath *>*> *)createIndexPathTwoDimensionalArrayFromCollectionView:(UICollectionView *)collectionView {
    NSMutableArray *indexPathArrM = [NSMutableArray array];
    NSInteger sectionCount = 1;
    if ([collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sectionCount  = [collectionView.dataSource numberOfSectionsInCollectionView:collectionView];
    }
    for (int sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
        NSInteger numberOfItemsInSection =  [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:sectionIndex];
        NSMutableArray *sectionArrayM = [NSMutableArray arrayWithCapacity:numberOfItemsInSection];
        for (int i = 0; i < numberOfItemsInSection; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionIndex];
            [sectionArrayM addObject:indexPath];
        }
        [indexPathArrM addObject:[NSArray arrayWithArray:sectionArrayM]];
    }
    return [NSArray arrayWithArray:indexPathArrM];
}

@end
