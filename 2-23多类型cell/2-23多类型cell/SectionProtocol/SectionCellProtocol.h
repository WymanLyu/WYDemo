//
//  SectionCellProtocol.h
//  YourSay
//
//  Created by wyman on 2017/2/15.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionCellProtocol <NSObject>

@required

/**
 *  获取循环利用的cell
 */
+ (instancetype)reusedCellWithTable:(UITableView *)table;


/**
 *  给cell配置模型
 */
- (void)setModel:(NSObject *)model;

@end
