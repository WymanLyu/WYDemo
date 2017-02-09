//
//  WYHorizonScaleLayout.m
//  WYHorizonScaleCollectionView
//
//  Created by wyman on 2017/2/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYHorizonScaleLayout.h"

#pragma mark - 排序函数
// 升序状态
NSInteger sortByIndexPath (id obj1, id obj2, void *context)
{
    NSIndexPath *path1 = (NSIndexPath *)obj1;
    NSIndexPath *path2 = (NSIndexPath *)obj2;
    if (path1.row < path2.row) {
        return NSOrderedAscending;
    } else if (path1.row > path2.row) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

@interface WYHorizonScaleLayout ()

@property (nonatomic, strong) UICollectionViewLayoutAttributes *supplementaryAttributes;

@end

@implementation WYHorizonScaleLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    // 默认属性
    self.itemSize = CGSizeMake(ITEMSIZE_WIDTH, ITEMSIZE_HEIGHT);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.direction = HorizonScrollDirectionRight; // 默认是右侧
    
    // 这里给装饰视图，创建布局属性
    UICollectionViewLayoutAttributes *supplementaryAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kSupplementaryViewKind withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    self.supplementaryAttributes = supplementaryAttributes;
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSLog(@"%s", __func__);
    
    ////////////////////////////////////// 缩放 ////////////////////////////////////////////
    NSMutableArray *layoutAttributes =  [[NSMutableArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    for (UICollectionViewLayoutAttributes *attr in layoutAttributes) {
        // cell中心点与collectionView的中点的间距
        CGFloat cellCenterX = attr.center.x;
        CGFloat contentOffsetX = self.collectionView.contentOffset.x;
        CGFloat collViewCenterX = self.collectionView.bounds.size.width * 0.5;
        CGFloat distance = ABS(cellCenterX - contentOffsetX - collViewCenterX);

        // 缩放比例
        CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
        CGFloat controlValue = 7.0; // 16.0
        CGFloat scale = 1 - (controlValue*distance)/(15.0*collectionViewWidth);
        attr.transform = CGAffineTransformMakeScale(scale, scale);
        attr.alpha = scale;
    }
    
    ////////////////////////////////////// 文字 ////////////////////////////////////////////
    // 获取显示的模型--无序的（根据row排序）,再根据滚动方向可以获取滚动目标数据（左则取最小值，右则取最大值）
    NSArray *visibleDataIndexPaths = self.collectionView.indexPathsForVisibleItems;
    // 根据row排序
    visibleDataIndexPaths = [visibleDataIndexPaths sortedArrayUsingFunction:sortByIndexPath context:nil];
    // 上一次的文本
    NSString *lastText = nil;
    // 获取目标的文本
    NSString *targetText = nil;
    // 目标cell的UICollectionViewLayoutAttributes!!! 拿这个没用，需要拿到视图才是实时的坐标啊！！！
    // UICollectionViewLayoutAttributes *targetCellAttributes = nil;
    UICollectionViewCell *targetCell = nil;
   
    
    if (visibleDataIndexPaths.count == 3) { // 3个情况，是正常情况目标是中间那个
        targetText = [self.dataSource objectAtIndex:[self.fatherView pageControlIndexWithCurrentCellIndex:[[visibleDataIndexPaths objectAtIndex:1] row]]];
        targetCell = [self.collectionView cellForItemAtIndexPath:[visibleDataIndexPaths objectAtIndex:1]];
        
        if (self.direction == HorizonScrollDirectionRight) { // 内容往右边滚,则原来的是最后一个
            lastText = [self.dataSource objectAtIndex:[self.fatherView pageControlIndexWithCurrentCellIndex:[[visibleDataIndexPaths lastObject] row]]];
        } else { // 左边滚，则目标是第一个
            lastText = [self.dataSource objectAtIndex:[self.fatherView pageControlIndexWithCurrentCellIndex:[[visibleDataIndexPaths firstObject] row]]];
        }
    } else { // 只有两个（左右到顶的情况）
        if (self.direction == HorizonScrollDirectionRight) { // 内容往右边滚,则目标是第一个
            targetCell = [self.collectionView cellForItemAtIndexPath:[visibleDataIndexPaths firstObject]];
            targetText = [self.dataSource objectAtIndex:[self.fatherView pageControlIndexWithCurrentCellIndex:[[visibleDataIndexPaths firstObject] row]]];
            lastText =  [self.dataSource objectAtIndex:[self.fatherView pageControlIndexWithCurrentCellIndex:[[visibleDataIndexPaths lastObject] row]]];
            
        } else { // 内容往左边滚，则目标是最后一个
            targetCell = [self.collectionView cellForItemAtIndexPath:[visibleDataIndexPaths lastObject]];
            targetText = [self.dataSource objectAtIndex:[self.fatherView pageControlIndexWithCurrentCellIndex:[[visibleDataIndexPaths lastObject] row]]];
            lastText = [self.dataSource objectAtIndex:[self.fatherView pageControlIndexWithCurrentCellIndex:[[visibleDataIndexPaths firstObject] row]]];
        }
    }
    
    // 用来计算尺寸的label
    UILabel *caculateLbl = [UILabel new];
    // 原始尺寸
    caculateLbl.text = lastText;
    [caculateLbl sizeToFit];
    CGSize originSize = caculateLbl.bounds.size;
    // 目标尺寸
    caculateLbl.text = targetText;
    [caculateLbl sizeToFit];
    CGSize targetSize = caculateLbl.bounds.size;
    // 计算过渡的比例
    CGFloat cellCenterX = targetCell.center.x;
    CGFloat cellContentOffsetX = self.collectionView.contentOffset.x;
    CGFloat cellCollViewCenterX = self.collectionView.bounds.size.width * 0.5;
    CGFloat distance = ABS(cellCenterX - cellContentOffsetX - cellCollViewCenterX);
    CGFloat defaultWidth = 200; //ABS([[layoutAttributes firstObject] center].x - [[layoutAttributes objectAtIndex:1] center].x);
    CGFloat titleLblScale = 1 - distance*1.0 / defaultWidth;
    
    // 获取装饰视图处理文本渐变动画,只支持9.0以上
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//        if ([self.collectionView respondsToSelector:@selector(supplementaryViewForElementKind:atIndexPath:)]) {
//             WYSupplementaryLblView *supplementaryView = (WYSupplementaryLblView *)[self.collectionView supplementaryViewForElementKind:kSupplementaryViewKind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//            [supplementaryView.titleLbl sizeToFit];
//            supplementaryView.titleLbl.text = targetText;
//            supplementaryView.titleLbl.backgroundColor = [UIColor yellowColor];
//            supplementaryView.titleLbl.alpha = titleLblScale*titleLblScale*titleLblScale;
//            supplementaryView.progressScale = titleLblScale*titleLblScale*titleLblScale;
//        }
//    }
    
    // 直接在外面传进来了，因为只有一个视图就不循环利用【糟糕的设计也会有不错的效果】
    [self.supplementaryView.titleLbl sizeToFit];
    self.supplementaryView.titleLbl.text = targetText;
    self.supplementaryView.titleLbl.backgroundColor = [UIColor yellowColor];
    self.supplementaryView.titleLbl.alpha = titleLblScale*titleLblScale*titleLblScale;
    
    
    
    // 设置尺寸
    self.supplementaryAttributes.size = CGSizeMake((targetSize.width-originSize.width)*titleLblScale + originSize.width, targetSize.height);
//    NSLog(@"\\\\\\\\\\\\\\\\%@-c:%@",lastText,targetText);
    // 始终水平居中
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat contentOffsetY = self.collectionView.contentOffset.y;
    CGFloat collViewCenterX = self.collectionView.bounds.size.width * 0.5;
    CGFloat collViewCenterY = self.collectionView.bounds.size.height * 0.5 + 40;
    self.supplementaryAttributes.center = CGPointMake(contentOffsetX + collViewCenterX, contentOffsetY + collViewCenterY);
    [layoutAttributes addObject:self.supplementaryAttributes];
    
    return [layoutAttributes copy];
}

//当尺寸改变，当前的布局无效，就会调用layoutAttributesForElementsInRect
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

// 分页效果，自动停在最近的中心位置
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{

    // 获取布局
    CGFloat offsetX = proposedContentOffset.x;
    CGRect visiableRect = CGRectMake(offsetX, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *layoutAttributes = [self layoutAttributesForElementsInRect:visiableRect];
    CGFloat minDistance = MAXFLOAT;
    
    // 计算最近的那个布局
    for (UICollectionViewLayoutAttributes *attr in layoutAttributes) {
        if (attr.representedElementCategory == UICollectionElementCategorySupplementaryView) { // 遇到装饰视图则跳过
            continue;
        }
        if ([attr.representedElementKind isEqualToString:kSupplementaryViewKind]) {
            continue;
        }
        CGFloat cellCenterX = attr.center.x;
        CGFloat contentOffsetX = proposedContentOffset.x;
        CGFloat collViewCenterX = self.collectionView.bounds.size.width * 0.5;
        CGFloat distance = cellCenterX - contentOffsetX - collViewCenterX;
        if (ABS(distance) < ABS(minDistance)) {
            minDistance = distance;
        }
    }
    
    // 修改目标offset【这个感觉不错哟！不知scrollerview会不会有用呢，这样是不是就可以实现较好的自定义分页效果？有空测试下】
    proposedContentOffset.x += minDistance;
    
    return proposedContentOffset;
}


// 重载这个的原因是要修复有些cell刚出现时的布局不正确【就是没有利用layoutAttributesForElementsInRect中计算好的缩放】该方法调用时机不明
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath; {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.transform = CGAffineTransformIdentity;
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __func__);
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    
    return layoutAttributes;
}



@end
