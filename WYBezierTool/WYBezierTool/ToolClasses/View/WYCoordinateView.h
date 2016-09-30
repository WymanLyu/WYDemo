//
//  WYCoordinateView.h
//  WYBezierTool
//
//  Created by yunyao on 16/9/22.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WYBezierLineModel.h"

extern NSString *const kDotViewCoordinateNotification;

@interface WYCoordinateView : NSView

/** 维护贝塞尔曲线的数组 */
@property (strong) NSMutableArray<WYBezierLineModel *> *bezierArrM;

- (void)startAnimation;

@end