//
//  ViewController.m
//  11-8ShareView
//
//  Created by wyman on 2017/11/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController1.h"
#import "TableViewController2.h"
#import "UIView+ScrollShareView.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*2, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    
    TableViewController1 *vc1 = [[TableViewController1 alloc] init];
    TableViewController2 *vc2 = [[TableViewController2 alloc] init];
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    vc1.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    vc2.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [scrollView addSubview:vc1.view];
    [scrollView addSubview:vc2.view];
    
}



@end
