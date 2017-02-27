//
//  TableViewCellTypeA.m
//  2-23多类型cell
//
//  Created by wyman on 2017/2/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "TableViewCellTypeA.h"
#import "ModelTypeA.h"

@implementation TableViewCellTypeA

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
    
    TableViewCellTypeA *cell = [table dequeueReusableCellWithIdentifier:@"A"];
    if (!cell) {
        cell = [[TableViewCellTypeA alloc] initWithStyle:0 reuseIdentifier:@"A"];
    }
    return cell;
    
}


/**
 *  给cell配置模型
 */
- (void)setModel:(NSObject *)model {
    
    ModelTypeA *modelA = (ModelTypeA *)model;
    self.textLabel.text = @"modelA类型的cell";
    
}


@end
