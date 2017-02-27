//
//  ModelTypeA.m
//  2-23多类型cell
//
//  Created by wyman on 2017/2/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ModelTypeA.h"

@implementation ModelTypeA

- (CGFloat)getCellHeight {
    return 100;
}


- (Class <SectionCellProtocol>)cellClass {
    return NSClassFromString(@"TableViewCellTypeA");
}

@end
