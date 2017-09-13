//
//  ViewController.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "SimpleNavgationBar.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSString *>*dataArr;
@property (nonatomic, weak) UIImageView *topImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FuncLog
    [self tableView];
    self.title = @"SimpleNavigationBar";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FuncLog
    self.sn_navBarBackgroundColor = [UIColor redColor];
    self.sn_navBarAlpha = 1 + (self.tableView.contentOffset.y+64) / (imageHeight-64);
    self.sn_navBarBottomLineHidden = !ceil(self.sn_navBarAlpha);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self sn_reset];
    FuncLog
}


#pragma mark - tableview

- (NSArray<NSString *> *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"To系统原生导航", @"To透明导航", @"To纯色导航", @"test",@"test",@"test",@"test",@"test",@"test",@"test",@"test",@"test",@"test"];
    }
    return _dataArr;
}

static CGFloat imageHeight = 250;

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        _tableView = tableView;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
        UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
        [_tableView addSubview:topImageView];
        topImageView.frame = CGRectMake(0, -imageHeight, self.view.bounds.size.width, imageHeight);
        self.topImageView = topImageView;
        topImageView.contentMode = UIViewContentModeScaleAspectFill;
        topImageView.clipsToBounds = YES;
        
    }
    return _tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.sn_navBarAlpha = 1 + (scrollView.contentOffset.y+64) / (imageHeight-64);
    self.sn_navBarBottomLineHidden = !ceil(self.sn_navBarAlpha);
    if (scrollView.contentOffset.y >= -imageHeight) return;
    self.topImageView.frame = CGRectMake(-self.view.bounds.size.width*(-scrollView.contentOffset.y/imageHeight-1)*0.5, scrollView.contentOffset.y, self.view.bounds.size.width* (-scrollView.contentOffset.y/imageHeight), -scrollView.contentOffset.y);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0==indexPath.row) {
        ViewController1 *vc = [ViewController1 new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (1==indexPath.row) {
        ViewController2 *vc = [ViewController2 new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (2==indexPath.row) {
        ViewController3 *vc = [ViewController3 new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}





@end
