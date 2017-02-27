//
//  TableViewCellTypeC.m
//  2-23多类型cell
//
//  Created by wyman on 2017/2/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "TableViewCellTypeC.h"
#import "ModelTypeC.h"

@implementation TableViewCellTypeC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  获取循环利用的cell
 */
+ (instancetype)reusedCellWithTable:(UITableView *)table {
    
    TableViewCellTypeC *cell = [table dequeueReusableCellWithIdentifier:@"C"];
    if (!cell) {
        cell = [[TableViewCellTypeC alloc] initWithStyle:0 reuseIdentifier:@"C"];
    }
    return cell;
    
}


/**
 *  给cell配置模型
 */
- (void)setModel:(NSObject *)model {
    
    ModelTypeC *modelC = (ModelTypeC *)model;
    self.textLabel.text = @"modelC类型的cell";
    
}

@end
