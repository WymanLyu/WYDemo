//
//  WYMagicLayout.m
//  KLParallaxView
//
//  Created by wyman on 2017/1/6.
//  Copyright © 2017年 dara. All rights reserved.
//

#import "WYMagicLayout.h"
#import "WYMagicBannerCell.h"


@implementation WYMagicLayout

/* 1.cell显示的时候，会调用这个方法
 2.用户拖拽的时候，会调用
 */
//-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    //    NSLog(@"%s",__func__);
//    // 布局的属性->数组
//    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
//    // UICollectionViewLayoutAttributes 是决定每个cell的frame
//    for (UICollectionViewLayoutAttributes *attr in layoutAttributes) {
//        
//        // 1.缩放比例的计算
//        // cell的中心点与collectionView的中点的间距，如果越来越小，缩放比就越大
//        
//        // 1.1计算cell的中心点与collectionView的中点的间距
//        CGFloat cellCenterX = attr.center.x;
//        
//        CGFloat contentOffsetX = self.collectionView.contentOffset.x;
//        
//        CGFloat collViewCenterX = self.collectionView.bounds.size.width * 0.5;
//        
//        CGFloat distance = ABS(cellCenterX - contentOffsetX - collViewCenterX);
//        //        NSLog(@"%f",distance);
//        
//        // 1.2 计算缩放比(0~1) (间距越来越小，缩放越大 -> 成反比)
//        //
//        
////        CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
////        // A: 10/320
////        // B: 20/320
////        // C; 30/320
////        CGFloat scale = 1 - distance / collectionViewWidth;
////        attr.transform = CGAffineTransformMakeScale(scale, scale);
//    }
//    
//    return layoutAttributes;
//}


//当尺寸改变，当前的布局无效，就会调用layoutAttributesForElementsInRect
//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    
//    return YES;
//}

/* 1.监听collectionView的拖拽结束
 * 2.计算哪个cell距离中心线最近
 * 3.在collectionView的contentOffset.x 添加一个增加值
 */
//proposedContentOffset 预期/最终的contentOffset
//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
//    //2.计算哪个cell距离中心线最近
//    //2.1获取可见区域cell的UICollectionViewLayoutAttributes
//    NSLog(@"%s", __func__);
//    CGFloat offsetX = proposedContentOffset.x;
//    CGRect visiableRect = CGRectMake(offsetX, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray *layoutAttributes = [self layoutAttributesForElementsInRect:visiableRect];
//    CGFloat minDistance = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes *attr in layoutAttributes) {
//        NSLog(@"%zd",attr.indexPath.row);
//        //2.2计算出cell与中心线的距离
//        CGFloat cellCenterX = attr.center.x;
//        
//        CGFloat contentOffsetX = proposedContentOffset.x;
//        
//        CGFloat collViewCenterX = self.collectionView.bounds.size.width * 0.5;
//        
//        // 距离有正有负
//        CGFloat distance = cellCenterX - contentOffsetX - collViewCenterX;
//        
//        //2.3要判断哪一个cell距离中心线最短
//        if (ABS(distance) < ABS(minDistance)) {
//            minDistance = distance;
//        }
//    }
//    
//    // 3.更改offset
//    proposedContentOffset.x += minDistance;
//    
//    return proposedContentOffset;
//}

//
// // 1.cell显示的时候，会调用这个方法  2.用户拖拽的时候，会调用
//-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//        NSLog(@"%s",__func__);
//    // 布局的属性->数组
//    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
//    // UICollectionViewLayoutAttributes 是决定每个cell的frame
//    for (UICollectionViewLayoutAttributes *attr in layoutAttributes) {
//        CGFloat angle = M_PI*0.25*0.5;
////        CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
////        transform.m34 = 1.0/-700;
////        switch (self.direction) {
////            case MagicScrollDirectionL:
////                attr.transform3D = CATransform3DRotate(transform, angle, 0, 1, 0);
////                break;
////                
////            case MagicScrollDirectionR:
////                attr.transform3D = CATransform3DRotate(transform, -angle, 0, 1, 0);
////                break;
////                
////            default:
////                break;
////        }
//        
//        NSLog(@"%@", NSStringFromCGRect(rect));
//        
//        
//    }
//    
//    return layoutAttributes;
//}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 50;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 50;
//}




@end
