//
//  ViewController.m
//  8-5MovieCollTest
//
//  Created by wyman on 2017/8/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "MovieLayout.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *dataSourceArr;

@property (nonatomic, strong) MovieLayout *layout;

@property (nonatomic, strong) UICollectionView *movieView;

@property (nonatomic, strong) UIView *blueView;

@property (nonatomic, strong) UIScrollView *scrol;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layout = [[MovieLayout alloc] init];
    _movieView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)collectionViewLayout:_layout];
    _movieView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_movieView];
    
    [_movieView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    _movieView.dataSource = self;
    _movieView.delegate = self;
    
    
    UIScrollView *scrol = [[UIScrollView alloc] initWithFrame:CGRectMake(44, 88, 300, 300)];
//    scrol.contentSize = CGSizeMake(600, 600);
    scrol.backgroundColor = [UIColor yellowColor];
    scrol.zoomScale = 3.0;
    scrol.maximumZoomScale = 2.0;
    scrol.multipleTouchEnabled = YES;
    scrol.delegate = self;
    [self.view addSubview:scrol];
    [scrol addSubview:_movieView];
 
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    blueView.backgroundColor = [UIColor blueColor];
    [scrol addSubview:blueView];
    _blueView = blueView;
    UIView *ori = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [blueView addSubview:ori];
    ori.backgroundColor = [UIColor orangeColor];
    


}

- (NSArray *)dataSourceArr {
    if(!_dataSourceArr) {
//        _dataSourceArr = @[@[@(1), @(0), @(0), @(1),@(1), @(0), @(0), @(1),@(1)], @[@(0), @(0), @(1),@(1), @(0), @(0), @(1),@(1), @(0), @(0), @(1)]];
        _dataSourceArr = @[@[@(1), @(1)], @[@(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1)], @[@(1), @(1), @(1), @(1), @(1), @(1)]];
    }
    return _dataSourceArr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"---");
    [self.layout invalidateLayout];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSourceArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSourceArr[section] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"---%@", indexPath);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.movieView;
}


@end
