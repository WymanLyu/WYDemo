//
//  WYDotView.h
//  WYBezierTool
//
//  Created by yunyao on 16/9/23.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const kDotViewMouseDownNotification;
extern NSString *const kDotViewMouseUpNotification;
extern NSString *const kDotViewMouseMoveNotification;

@interface WYDotView : NSView

@property (strong) NSColor *backgroundColor;

@property (nonatomic, assign, readonly) BOOL isDragged;

@property (nonatomic, assign) BOOL noDrag;

@end
