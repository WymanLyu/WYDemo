//
//  TableViewCellTypeB.m
//  2-23多类型cell
//
//  Created by wyman on 2017/2/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "TableViewCellTypeB.h"
#import "ModelTypeB.h"

@implementation TableViewCellTypeB

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
    
    TableViewCellTypeB *cell = [table dequeueReusableCellWithIdentifier:@"B"];
    if (!cell) {
        cell = [[TableViewCellTypeB alloc] initWithStyle:0 reuseIdentifier:@"B"];
    }
    return cell;
    
}


/**
 *  给cell配置模型
 */
- (void)setModel:(NSObject *)model {
    
    ModelTypeB *modelB = (ModelTypeB *)model;
    self.textLabel.text = @"modelB类型的cell";
    
}

@end
