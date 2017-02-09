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

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WYHorizonScaleCollectionView *view = [[WYHorizonScaleCollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, ITEMSIZE_HEIGHT)];
    view.backgroundColor = [UIColor grayColor];
    NSArray *dataSource = @[@"111111",@"2222222",@"333333333333"]; // ,@"thr中文无聊的我单排扣我的卡ee",@"twoccecwcw"
    view.dataSource = dataSource;
    
    [self.view addSubview:view];
    
}

@end
