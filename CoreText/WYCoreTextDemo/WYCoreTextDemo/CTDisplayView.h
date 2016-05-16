//
//  CTDisplayView.h
//  WYCoreTextDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

@interface CTDisplayView : UIView

/** 文本模型 */
@property (strong, nonatomic) CoreTextData * data;

@end
