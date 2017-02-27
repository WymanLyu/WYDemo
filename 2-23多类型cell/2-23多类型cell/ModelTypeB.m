//
//  ModelTypeB.m
//  2-23多类型cell
//
//  Created by wyman on 2017/2/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ModelTypeB.h"

@implementation ModelTypeB

- (CGFloat)getCellHeight {
    return 200;
}

- (Class <SectionCellProtocol>)cellClass {
    return NSClassFromString(@"TableViewCellTypeB");
}

@end
