//
//  MovieLayout.m
//  8-5MovieCollTest
//
//  Created by wyman on 2017/8/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "MovieLayout.h"
#import "NSIndexPath+Movie.h"

#define ITEM_SIZE_W 30
#define ITEM_SIZE_H 30
#define ITEM_MARGIN_H 5 // 水平间距
#define ITEM_MARGIN_V 5 // 垂直间距

#define MAX_ITEM_COUNT_H 8 // 水平最多个数

#define SCREEN_MARGIN 10   // 银屏和第一组第一排的间距
#define SECTION_MARGIN 20  // 组间间距

@interface MovieLayout ()

/** 数据源数据 */
@property (nonatomic, strong) NSArray<NSArray <NSIndexPath *>*> *indexPathArr;

/** 各组（各个section）的总行数 */
@property (nonatomic, strong) NSMutableArray *rowCountArrM;

/** 各组的高度 */
@property (nonatomic, strong) NSMutableArray *sectionMaxYArrM;

/** 中心线 */
@property (nonatomic, assign) CGFloat centerLineX;

@end

@implementation MovieLayout

- (instancetype)init {
    if (self = [super init]) {
        _rowCountArrM = [NSMutableArray array];
        _sectionMaxYArrM = [NSMutableArray array];
    }
    return self;
}

- (void)invalidateLayout {
    [super invalidateLayout];
    // 触发重新计算的方法，第一次创建到collectionview时会系统触发
    NSLog(@"%s", __func__);
}

- (void)prepareLayout {
    [super prepareLayout];
    NSLog(@"%s", __func__);
    
    // 1.计算 section数 和 对应section的row个数，并记录成NSIndexPath
    _indexPathArr = [NSIndexPath createIndexPathTwoDimensionalArrayFromCollectionView:self.collectionView];
    
    // 2.计算每组总行数
    for (NSArray<NSIndexPath *> *indexPathArr in self.indexPathArr) {
        int rowCount = (int)ceilf(indexPathArr.count*1.0 / MAX_ITEM_COUNT_H);
        [self.rowCountArrM addObject:@(rowCount)];
    }
    
    // 3.计算该组高度Y
    CGFloat sectionMaxY = 0;
    for (int i = 0; i < self.rowCountArrM.count; i++) {
        NSInteger rowCountValue = [self.rowCountArrM[i] integerValue];
        sectionMaxY = sectionMaxY + SCREEN_MARGIN + rowCountValue*ITEM_SIZE_H + (rowCountValue-1)*ITEM_MARGIN_H;
        if (i != 0) {
            sectionMaxY += SECTION_MARGIN;
        }
        [self.sectionMaxYArrM addObject:@(sectionMaxY)];
    }
    
    // 4.中心线
    _centerLineX = self.collectionView.bounds.size.width / 2;
}

- (CGSize)collectionViewContentSize {
    NSLog(@"%s", __func__);
//    self.collectionView.multipleTouchEnabled = YES;
//    self.collectionView.maximumZoomScale=2;
//    self.collectionView.zoomScale = 3.0;
//    return CGSizeMake(self.collectionView.frame.size.width*2.0, self.collectionView.frame.size.height*2.0);
    return self.collectionView.frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
     NSLog(@"%s", __func__);
    MovieAttributes *attributes = [MovieAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 计算
    //
    //  eg: 21个座位
    //  总行数 ： row = ceilf(21.0/8) 向上取整  总列数 ： 8
    //  最后一行不足8的时候为N，则列数是N（N<8）:
    //      第一个元素在中心左边，第二个在中心右边，第三个在左边。。。
    //
    
    // 该组的最大y值
    CGFloat sectionMaxY = [self.sectionMaxYArrM[indexPath.section] floatValue];
    NSLog(@"--%f", sectionMaxY);
  
    // 计算item中心点
    CGFloat itemCenterX = 0;
    CGFloat itemCenterY = 0;
    NSInteger rowNumber =  indexPath.row / MAX_ITEM_COUNT_H; // 行号
    if (indexPath.section == 1) {
        NSLog(@"rowNumber: %zd", rowNumber);
    }
    if (!(indexPath.row % 2)) { // 偶数，在中心线左边
        // 0 序号的 item的中心点X = _centerLineX - (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5)
        // 2 序号的 item的中心点x = _centerLineX - (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5) - (ITEM_MARGIN_H + ITEM_SIZE_W)
        // 4 序号的 item的中心点x = _centerLineX - (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5) - (ITEM_MARGIN_H + ITEM_SIZE_W)*2
        // 6 序号的 item的中心点x = _centerLineX - (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5) - (ITEM_MARGIN_H + ITEM_SIZE_W)*3
        itemCenterX = _centerLineX - (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5) - (ITEM_MARGIN_H + ITEM_SIZE_W) * ((indexPath.row%MAX_ITEM_COUNT_H)/2);
        itemCenterY = sectionMaxY - ITEM_MARGIN_H*0.5  - (ITEM_SIZE_H + ITEM_MARGIN_V) * rowNumber;

    } else { // 奇数，在中心线右边
        
        // 1 序号的 item的中心点X = _centerLineX + (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5)
        // 3 序号的 item的中心点x = _centerLineX + (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5) + (ITEM_MARGIN_H + ITEM_SIZE_W)
        // 5 序号的 item的中心点x = _centerLineX + (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5) + (ITEM_MARGIN_H + ITEM_SIZE_W)*2
        // 7 序号的 item的中心点x = _centerLineX + (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5) + (ITEM_MARGIN_H + ITEM_SIZE_W)*3
        itemCenterX =  _centerLineX + (ITEM_MARGIN_H*0.5 + ITEM_SIZE_W*0.5) + (ITEM_MARGIN_H + ITEM_SIZE_W) * (((indexPath.row%MAX_ITEM_COUNT_H)-1)/2);
        itemCenterY = sectionMaxY - ITEM_MARGIN_H*0.5  - (ITEM_SIZE_H + ITEM_MARGIN_V) * rowNumber;
//        itemCenterY = (sectionMaxY - ITEM_MARGIN_H*0.5) * (rowNumber+1);
 
    }
    
    attributes.size = CGSizeMake(ITEM_SIZE_W, ITEM_SIZE_H);
    attributes.center = CGPointMake(itemCenterX, itemCenterY);
    
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSLog(@"%s", __func__);
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger sectionCount = 0; sectionCount < self.indexPathArr.count; sectionCount++) {
        NSArray *indexPathArray = self.indexPathArr[sectionCount];
        for (NSIndexPath *indexPath in indexPathArray) {
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}

- (Class)layoutAttributesClass {
    NSLog(@"%s", __func__);
    return [MovieAttributes class];
}



@end
