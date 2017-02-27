//
//  ViewController.m
//  2-23多类型cell
//
//  Created by wyman on 2017/2/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

#import "ModelTypeA.h"
#import "ModelTypeB.h"
#import "ModelTypeC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

/** 列表 */
@property (nonatomic, weak) UITableView *tableview;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArrayM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    _tableview = tableview;
    
}

- (NSMutableArray *)dataArrayM {
    if (!_dataArrayM) {
        // 这里就由模型决定cell的类型，这里顺序一换，界面就换了
        ModelTypeA *a = [ModelTypeA new];
        ModelTypeB *b = [ModelTypeB new];
        ModelTypeC *c = [ModelTypeC new];
        _dataArrayM = [NSMutableArray arrayWithArray:@[a, c, b]];
    }
    return _dataArrayM;
}

#pragma mark - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<SectionModelProtocol> *model = [self.dataArrayM objectAtIndex:indexPath.row];
    Class <SectionCellProtocol> cellClass = [model cellClass];
    UITableViewCell<SectionCellProtocol> *cell = [cellClass reusedCellWithTable:tableView];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<SectionModelProtocol> *model = [self.dataArrayM objectAtIndex:indexPath.row];
    return model.getCellHeight;
}


@end
