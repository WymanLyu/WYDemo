//
//  NSIndexPath+Movie.h
//  8-5MovieCollTest
//
//  Created by wyman on 2017/8/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath (Movie)

+ (NSArray<NSArray <NSIndexPath *>*> *)createIndexPathTwoDimensionalArrayFromCollectionView:(UICollectionView *)collectionView;

@end
