//
//  SectionModelProtocol.h
//  YourSay
//
//  Created by wyman on 2017/2/15.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionCellProtocol.h"

@protocol SectionModelProtocol <NSObject>

@required

/** 
 * cell类型
 */
- (Class <SectionCellProtocol>)cellClass;

/**
 *  获取cell的高度，控制器在此处获取cell高度
 */
- (CGFloat)getCellHeight;

@optional
/**
 *  触发cell的点击事件
 */
- (void)triggerCellClickInRow:(NSInteger)row;


@end
