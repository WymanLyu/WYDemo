//
//  WYBezierLineModel.h
//  WYBezierTool
//
//  Created by yunyao on 16/9/23.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYDotView.h"

@interface WYBezierLineModel : NSObject

/** 起始点 */
@property (assign) CGPoint beginDotPoint;
@property (strong) WYDotView *beginDot;;

/** 结束点 */
@property (assign) CGPoint endDotPoint;
@property (strong) WYDotView *endDot;

/** 控制点1 */
@property (assign) CGPoint controlPoint1;
@property (strong) WYDotView *controlDot1;

/** 控制点2 */
@property (assign) CGPoint controlPoint2;
@property (strong) WYDotView *controlDot2;

/** 序号 */
@property (nonatomic, assign) NSInteger index;


@end
