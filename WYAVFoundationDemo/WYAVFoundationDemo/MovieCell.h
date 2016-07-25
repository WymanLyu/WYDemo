//
//  MovieCell.h
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/25.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieItem.h"

@interface MovieCell : UITableViewCell
@property (nonatomic, strong) MovieItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
