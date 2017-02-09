//
//  WYHorizonScaleCollectionView.m
//  WYHorizonScaleCollectionView
//
//  Created by wyman on 2017/2/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYHorizonScaleCollectionView.h"
#import "WYHorizonScaleLayout.h"
#import "WYSupplementaryLblView.h"
#import "WYHorizonScaleCell.h"

#define IPHONE6_PLUS_SCREEN_WIDTH 414
#define IPHONE6_SCREEN_WIDTH 375
#define IPHONE5_SCREEN_WIDTH 320
#define CURRENTSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width



@interface WYHorizonScaleCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

/** 轮播collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 开始位置 */
@property (nonatomic, assign) CGFloat beginOffsetX;

/** 布局 */
@property (nonatomic, strong) WYHorizonScaleLayout *layout;


///** 图片数据源 */
//@property (nonatomic, strong) NSArray *imagePathsGroup;
/** 滚动item的数量 */
@property (nonatomic, assign) NSInteger totalItemsCount;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation WYHorizonScaleCollectionView


static double margin = 90; // 调节中心点的硬编码

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame] ) {
        
       margin = (
                    {
                        CGFloat width = 90;
                        if (CURRENTSCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
                            width = 70;
                        } else if (CURRENTSCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
                            width = 90;
                        } else if (CURRENTSCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
                            width = 117.5;
                        } else {
                            width = 90;
                        }
                        width;
                    }
                 );
        
        
        // 初始
        _autoScrollTimeInterval = 3.5f;
        _infiniteLoop = YES;
        _autoScroll = YES;
        
        CGRect tempF = {frame.origin, CGSizeMake([UIScreen mainScreen].bounds.size.width, ITEMSIZE_HEIGHT)};
        self.frame = tempF;
        
        // 1.设置布局layout
        WYHorizonScaleLayout *layout = [[WYHorizonScaleLayout alloc] init];
        layout.itemSize = CGSizeMake(ITEMSIZE_WIDTH, ITEMSIZE_HEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.direction = HorizonScrollDirectionRight; // 默认是右侧
        layout.fatherView = self;
        self.layout = layout;

        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        // 2.水平的collectionView
        // 150 + 11 + 7 + font14 + 8 + font11
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ITEMSIZE_HEIGHT) collectionViewLayout:layout];
        [self addSubview:collectionView];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor grayColor];
        _collectionView = collectionView;
        
        // 3.注册cell
        [collectionView registerClass:[WYHorizonScaleCell class] forCellWithReuseIdentifier:@"ReusableCell"];
        [collectionView registerClass:[WYSupplementaryLblView class] forSupplementaryViewOfKind:kSupplementaryViewKind withReuseIdentifier:@"Title"];

    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    self.layout.dataSource = dataSource;
    
    _totalItemsCount = self.infiniteLoop ? _dataSource.count * 100 : _dataSource.count;
    
    if (dataSource.count != 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.collectionView.scrollEnabled = NO;
    }
    
    [self.collectionView reloadData];
    [self.layout invalidateLayout];
 
    // 移到中间
    [_collectionView setContentOffset:CGPointMake([self.layout collectionViewContentSize].width*0.5+margin, _collectionView.contentOffset.y) animated:NO];
}

#pragma mark - 数据源

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginOffsetX = scrollView.contentOffset.x;
    // 杀死定时器
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 重启定时器
    [self setupTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.x < self.beginOffsetX) { // 右边
        self.layout.direction = HorizonScrollDirectionRight;
    } else {
        self.layout.direction = HorizonScrollDirectionLeft;
    }
    
    // 临界值处理
    if (scrollView.contentOffset.x < 600 || (scrollView.contentOffset.x > (scrollView.contentSize.width - 600))) {
        // 移到中间
        [_collectionView setContentOffset:CGPointMake([self.layout collectionViewContentSize].width*0.5+margin, _collectionView.contentOffset.y) animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取cell
    WYHorizonScaleCell *cell = (WYHorizonScaleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ReusableCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    
//    UILabel *lbl = [UILabel new];
//    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [cell addSubview:lbl];
//    lbl.text = [_dataSource objectAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.row]];
//    
//    [lbl sizeToFit];
//    lbl.textColor = [UIColor whiteColor];
    
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kSupplementaryViewKind withReuseIdentifier:@"Title" forIndexPath:indexPath];
    reusableView.backgroundColor = [UIColor redColor];
    
    self.layout.supplementaryView = (WYSupplementaryLblView *)reusableView;
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    // 移到最前面
    [collectionView bringSubviewToFront:view];
    
    // 设置title
    int idx = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    @try {
        NSString *title = [self.dataSource objectAtIndex:idx+1];
        WYSupplementaryLblView *lblView = (WYSupplementaryLblView *)view;
        lblView.titleLbl.text = title;
    } @catch (NSException *exception) {
        
    }
    
    
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

- (void)automaticScroll {
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= _totalItemsCount-1) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_collectionView setContentOffset:CGPointMake(_collectionView.contentOffset.x + ITEMSIZE_WIDTH, _collectionView.contentOffset.y) animated:YES];
    
}

- (int)currentIndex {
    if (_collectionView.frame.size.width == 0 || _collectionView.frame.size.height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_collectionView.contentOffset.x + _layout.itemSize.width * 0.5) / _layout.itemSize.width;
    } else {
        index = (_collectionView.contentOffset.y + _layout.itemSize.height * 0.5) / _layout.itemSize.height;
    }
    
    return MAX(0, index);
}

// 获取模型索引
- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.dataSource.count;
}



@end
