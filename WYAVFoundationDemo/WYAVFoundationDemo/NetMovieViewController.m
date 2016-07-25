//
//  NetMovieViewController.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/25.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "NetMovieViewController.h"
#import "MovieItem.h"
#import "MovieCell.h"
#import "WYAVFoundation/WYAVManager.h"

@interface NetMovieViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPause;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) WYAVManager *manager;

@end

@implementation NetMovieViewController

#pragma mark - 懒加载
- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (WYAVManager *)manager {
    if (!_manager) {
        _manager = [WYAVManager shareManager];
    }
    return _manager;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMoviewData];
}

- (void)loadMoviewData {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/video?type=JSON"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 转模型
        NSDictionary *objDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *movies = objDic[@"videos"];
        for (NSDictionary *dict in movies) {
            MovieItem *item = [MovieItem itemWithDict:dict];
            [self.items addObject:item];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }] resume];
}

#pragma mark - 播放demo
- (IBAction)play:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {// 选中暂停
        [self.manager wy_pausePlay];
    }else { // 没选中播放
        [self.manager wy_resumPlay];
    }
}
- (IBAction)next:(UIButton *)btn {
}
- (IBAction)previous:(UIButton *)btn {
}
- (IBAction)start:(id)sender {
}

#pragma mark - tableView datasource/delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [MovieCell cellWithTableView:tableView];
    cell.item = self.items[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieItem *item = self.items[indexPath.row];
    [self.manager wy_createItemWithUrl:[NSURL URLWithString:item.url]];
    [self.manager wy_readyPlayWithUrl:nil];
    self.manager.wy_currentPlayerLayer.frame = self.playerView.layer.bounds;
    [self.playerView.layer addSublayer:self.manager.wy_currentPlayerLayer];
    [self.manager wy_startPlay];
   
}











@end
