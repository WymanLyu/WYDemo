//
//  ViewController.m
//  WYHorizonScaleCollectionView
//
//  Created by wyman on 2017/2/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "WYHorizonScaleLayout.h"
#import "WYSupplementaryLblView.h"
#import "WYHorizonScaleCollectionView.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

/** 数据源 */
@property (nonatomic, strong) NSArray *data;

/** 开始位置 */
@property (nonatomic, assign) CGFloat beginOffsetX;

/** 布局 */
@property (nonatomic, strong) WYHorizonScaleLayout *layout;


/** 图片数据源 */
@property (nonatomic, strong) NSArray *imagePathsGroup;
/** 滚动item的数量 */
@property (nonatomic, assign) NSInteger totalItemsCount;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WYHorizonScaleCollectionView *view = [[WYHorizonScaleCollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, ITEMSIZE_HEIGHT)];
    view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:view];
    
}


/*

- (instancetype)init {
    if (self =[super init]) {
        // 初始
        _autoScrollTimeInterval = 3.5f;
        _infiniteLoop = YES;
        _autoScroll = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1.设置布局layout
    WYHorizonScaleLayout *layout = [[WYHorizonScaleLayout alloc] init];
    layout.itemSize = CGSizeMake(ITEMSIZE_WIDTH, ITEMSIZE_HEIGHT);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.direction = HorizonScrollDirectionRight; // 默认是右侧
    self.layout = layout;
//    layout.footerReferenceSize = CGSizeMake(100, 22);
    
    CGFloat margin = 0;
    margin = ([UIScreen mainScreen].bounds.size.width - ITEMSIZE_WIDTH - 140) / 2.0;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    // 2.水平的collectionView
    // 150 + 11 + 7 + font14 + 8 + font11
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, ITEMSIZE_HEIGHT) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor grayColor];
    
    // 3.注册cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ReusableCell"];
    [collectionView registerClass:[WYSupplementaryLblView class] forSupplementaryViewOfKind:kSupplementaryViewKind withReuseIdentifier:@"Title"];
    
    
//    NSArray *data = @[@"csdcs",@"csasdcs",@"csddqdcs",@"dcs",@"csddwdwdwdcs",@"wdcs",@"dcs",@"cwsdcs",@"csdwwwwcs",@"csswswwdcs",@"qqacsdcs",@"sqscsdcs",@"csdcs",@"css",@"cs",@"csqqqdcs"];
    NSArray *data = @[@"one",@"two",@"three"];
    self.data = data;
    layout.data = data;
    
    
}

#pragma mark - 数据源

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"============%f", scrollView.contentOffset.x);
    if (scrollView.contentOffset.x < self.beginOffsetX) { // 右边
        NSLog(@"===========右边");
        self.layout.direction = HorizonScrollDirectionRight;
    } else {
        NSLog(@"===========左边");
        self.layout.direction = HorizonScrollDirectionLeft;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReusableCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    
    UILabel *lbl = [UILabel new];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell addSubview:lbl];
    lbl.text = [self.data objectAtIndex:indexPath.row];
    [lbl sizeToFit];
    lbl.textColor = [UIColor whiteColor];
    

    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kSupplementaryViewKind withReuseIdentifier:@"Title" forIndexPath:indexPath];
    reusableView.backgroundColor = [UIColor redColor];
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    // 移到最前面
    [collectionView bringSubviewToFront:view];
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


*/

@end
