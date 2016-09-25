//
//  WYOperationView.h
//  WYBezierTool
//
//  Created by yunyao on 16/9/22.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WYOperationView : NSView

@property (copy) void(^addClik)();
@property (copy) void(^minusClik)();

@end
