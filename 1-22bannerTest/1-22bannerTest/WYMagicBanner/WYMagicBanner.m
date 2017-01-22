//
//  WYMagicBanner.m
//  KLParallaxView
//
//  Created by wyman on 2017/1/6.
//  Copyright © 2017年 dara. All rights reserved.
//

#import "WYMagicBanner.h"
#import "WYMagicBannerCell.h"
#import "WYCustomTouchCollectionView.h"
#import "WYMagicLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WYMagicBanner () <UICollectionViewDataSource,UICollectionViewDelegate, CAAnimationDelegate>

/** 轮播collectionView */
@property (nonatomic, strong) WYCustomTouchCollectionView *collectionView;
/** layout */
@property (nonatomic, weak) WYMagicLayout *flowLayout;
/** 一开始手势的位置 */
@property (nonatomic, assign) CGFloat lastContentOffset;

/** 图片数据源 */
@property (nonatomic, strong) NSArray *imagePathsGroup;
/** 滚动item的数量 */
@property (nonatomic, assign) NSInteger totalItemsCount;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation WYMagicBanner

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        WYMagicLayout *flowLayout =[[WYMagicLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _flowLayout = flowLayout;

        CGFloat itemW = CGRectGetWidth(frame) ;
        CGFloat itemH = CGRectGetWidth(frame);
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 0.0f;

        _collectionView  =[[WYCustomTouchCollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[WYMagicBannerCell class] forCellWithReuseIdentifier:@"WYMagicBannerCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;

        [self addSubview:_collectionView];
        
        // 初始
        _autoScrollTimeInterval = 3.5f;
        _infiniteLoop = YES;
        _autoScroll = YES;
    }
    return self;
}

#pragma mark - 自定义方法

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup {
    _imagePathsGroup = imagePathsGroup;
    
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 100 : self.imagePathsGroup.count;
    
    if (imagePathsGroup.count != 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.collectionView.scrollEnabled = NO;
    }
    
    [self.collectionView reloadData];

}

#pragma mark - 定时器

-(void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

#pragma mark - 循环滚动逻辑

- (void)layoutSubviews {
    [super layoutSubviews];
    // 挪到中间去
    if (_collectionView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)automaticScroll {
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex {
    if (_collectionView.frame.size.width == 0 || _collectionView.frame.size.height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_collectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

// 获取模型索引
- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.imagePathsGroup.count;
}

#pragma mark - 代理数据源

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYMagicBannerCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"WYMagicBannerCell" forIndexPath:indexPath];
    item.col = collectionView;
    item.banner = self;
    
    // 获取模型设置图片
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    NSString *imagePath = self.imagePathsGroup[itemIndex];
    [item.parallaxView.imgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];

    return item;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"跳转--》%s", __func__);
    // 获取对应模型设置图片
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(magicBannerWithFrame:delegate:placeholderImage:)]) {
        [self.delegate magicBanner:self didSelectItemAtIndex:itemIndex];
    }
    
}

// 是否是拖拽引起的滚动
static bool isScrollingByDrag = NO;
// 滚动的方向
static bool isLeft = NO;
static bool isRight = NO;

// 在最后移除所有动画【因为在滚动式倾斜动画，很多都是removedOnCompletion=NO】
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
     NSArray *visibleCells = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in visibleCells) {
        CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        transform.m34 = 1.0/-700;
        cell.layer.transform = transform;
         [cell.layer removeAllAnimations];
    }
}

#pragma mark ---- 滚动视图代理方法

// 开始滚动时标记，滚动的方向等
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    // 0.定时器
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    
    // 1.记录开始拖拽时刻的偏移量
    self.lastContentOffset = scrollView.contentOffset.x;
    
    // 2.标记为手势触发的滚动
    isScrollingByDrag = YES;
    
    // 3.初始化标记方向
    isLeft = NO;
    isRight = NO;

}

// 滚动时，设置所有item倾斜
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    // 根据当前偏移量与最初拖拽偏移量的差 标示方向
    // 方向变化时候，触发
    
    // 松手了则做回弹效果
    NSArray *visibleCells = [self.collectionView visibleCells];
    if (!isScrollingByDrag) { // 松手了
        NSArray *visibleCells = [self.collectionView visibleCells];
        for (UICollectionViewCell *cell in visibleCells) {
            if ([cell.layer animationForKey:@"scrollViewDidEndDragging"]) {
                continue;
            }
            [cell.layer removeAllAnimations];
            CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
            transform.m34 = 1.0/-700;
            CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform"];
            ani.toValue = [NSValue valueWithCATransform3D:transform];
            ani.duration = 0.25;
            ani.delegate = self;
            ani.removedOnCompletion = NO;
            ani.fillMode = @"forwards";
            [cell.layer addAnimation:ani forKey:@"scrollViewDidEndDragging"];
        }
        return;
    }
    
    // 没有松手则根据方向进行倾斜
    if (scrollView.contentOffset.x < self.lastContentOffset) {
        isLeft = NO;
        isRight = YES;
        // 将已经显示的cell也做一个相同的倾斜变换
        for (UICollectionView *currentCell in visibleCells) {
            [currentCell.layer removeAllAnimations];
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.1];
            
            CGFloat angle = M_PI*0.25*0.8;
            CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
            transform.m34 = 1.0/-700;
            transform = CATransform3DRotate(transform, -angle, 0, 1, 0);
            currentCell.layer.transform = transform;
            [CATransaction commit];
        }
    } else {
        isRight = NO;
        isLeft = YES;
        // 将已经显示的cell也做一个相同的倾斜变换
        for (UICollectionView *currentCell in visibleCells) {
            [currentCell.layer removeAllAnimations];
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.1];
            
            CGFloat angle = M_PI*0.25*0.8;
            CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
            transform.m34 = 1.0/-700;
            transform = CATransform3DRotate(transform, angle, 0, 1, 0);
            currentCell.layer.transform = transform;
            [CATransaction commit];
        }
    }
}


// 滚动完全结束，停驻后 ：  倾斜状态-》普通状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    isScrollingByDrag = NO;
    isLeft = NO;
    isRight = NO;
    NSLog(@"%s-%f", __func__, scrollView.decelerationRate);
    NSArray *visibleCells = [self.collectionView visibleCells];
    for ( UICollectionViewCell *cell in visibleCells) {
        
        if (![cell.layer animationForKey:@"scrollViewDidEndDragging"]) {
            [cell.layer removeAllAnimations];
            CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
            transform.m34 = 1.0/-700;
            CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform"];
            //        ani.beginTime = CACurrentMediaTime() - 0.1;
            ani.toValue = [NSValue valueWithCATransform3D:transform];
            ani.duration = 0.13;
            ani.delegate = self;
            ani.removedOnCompletion = NO;
            ani.fillMode = @"forwards";
            [cell.layer addAnimation:ani forKey:@"scrollViewDidEndDecelerating"];
            continue;
        }
    }
     NSLog(@"%s", __func__);
}

// 即将停止拖拽： 倾斜状态-》普通状态
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s", __func__);
    // 0.定时器
    if (self.autoScroll) {
        [self setupTimer];
    }
    
    isScrollingByDrag = NO;

    NSArray *visibleCells = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in visibleCells) {
        [cell.layer removeAllAnimations];
        CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        transform.m34 = 1.0/-700;
        CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform"];
        ani.toValue = [NSValue valueWithCATransform3D:transform];
        ani.duration = 0.25;
        ani.delegate = self;
        ani.removedOnCompletion = NO;
        ani.fillMode = @"forwards";
        [cell.layer addAnimation:ani forKey:@"scrollViewDidEndDragging"];
    }
}


@end
