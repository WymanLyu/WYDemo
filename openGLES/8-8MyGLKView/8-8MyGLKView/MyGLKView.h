//
//  MyGLKView.h
//  8-8MyGLKView
//
//  Created by wyman on 2017/8/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <GLKit/GLKit.h>

@class MyGLKView;

@protocol MyGLKViewDelegate <NSObject>

@required
- (void)glkView:(MyGLKView *)view drawInRect:(CGRect)rect;

@end

@interface MyGLKView : UIView

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context;

@property (nonatomic, weak) IBOutlet id <MyGLKViewDelegate> delegate;

@property (nonatomic, strong) EAGLContext *context;

@property (nonatomic, readonly) GLint drawableWidth;

@property (nonatomic, readonly) GLint drawableHeight;

- (void)display;

@end
