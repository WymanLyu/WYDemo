//
//  ModelTypeC.m
//  2-23多类型cell
//
//  Created by wyman on 2017/2/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ModelTypeC.h"

@implementation ModelTypeC


- (CGFloat)getCellHeight {
    return 300;
}

- (Class <SectionCellProtocol>)cellClass {
    return NSClassFromString(@"TableViewCellTypeC");
}

@end
