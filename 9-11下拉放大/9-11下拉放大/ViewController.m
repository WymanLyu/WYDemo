//
//  ViewController.m
//  9-11下拉放大
//
//  Created by wyman on 2017/9/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIImageView *topImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *T = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:T];
    T.dataSource = self;
    self.tableView = T;
    self.tableView.delegate = self;
    
    
    CGFloat imageHeight = 250;
    self.tableView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录1.jpg"]];
    [self.tableView addSubview:topImageView];
    topImageView.frame = CGRectMake(0, -imageHeight, self.view.bounds.size.width, imageHeight);

    self.topImageView = topImageView;
    
    
    
    
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.clipsToBounds = YES;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= -250) return;
    self.topImageView.frame = CGRectMake(-self.view.bounds.size.width*(-scrollView.contentOffset.y/250.0-1)*0.5, scrollView.contentOffset.y, self.view.bounds.size.width* (-scrollView.contentOffset.y/250.0), -scrollView.contentOffset.y);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}




@end
