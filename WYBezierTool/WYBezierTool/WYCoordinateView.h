//
//  WYCoordinateView.h
//  WYBezierTool
//
//  Created by yunyao on 16/9/22.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WYCoordinateView : NSView

- (void)startAnimation;

@end

@interface WYDotView : NSView

@property (strong) NSColor *backgroundColor;

@end