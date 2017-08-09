//
//  MyGLKView.m
//  8-8MyGLKView
//
//  Created by wyman on 2017/8/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "MyGLKView.h"

@interface MyGLKView ()

@property (nonatomic, assign) GLuint defaultFrameBuffer;
@property (nonatomic, assign) GLuint colorRenderBuffer;

@end

@implementation MyGLKView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)dealloc {
    if (self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context {
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        // kEAGLDrawablePropertyRetainedBacking==NO 表示不要尝试保留之前绘制结果，只要显示就渲染整个层
        // kEAGLDrawablePropertyColorFormat 用RGBA 8位存储色彩 32位
        eaglLayer.drawableProperties = @{
                                            kEAGLDrawablePropertyRetainedBacking : @(NO),
                                            kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
                                         };
        self.context = context;
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.drawableProperties = @{
                                            kEAGLDrawablePropertyRetainedBacking : @(NO),
                                            kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
                                         };
    }
    return self;
}

- (void)setContext:(EAGLContext *)context {
    if (_context != context) {
        
        // 1.删除已有bufferID
        [EAGLContext setCurrentContext:_context];
        if (0 != self.defaultFrameBuffer) {
            glDeleteBuffers(1, &_defaultFrameBuffer);
            self.defaultFrameBuffer = 0;
        }
        if (0 != self.colorRenderBuffer) {
            glDeleteBuffers(1, &_colorRenderBuffer);
            self.colorRenderBuffer = 0;
        }
        _context = context;
        
        // 2.如果新context不为空,创建并绑定新的frameBuffer
        if (nil != _context) {
            [EAGLContext setCurrentContext:_context];
            
            glGenFramebuffers(1, &_defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, _defaultFrameBuffer);
            
            glGenRenderbuffers(1, &_colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
            
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CAEAGLLayer *eagLayer = (CAEAGLLayer *)self.layer;
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eagLayer];
    glBindRenderbuffer(GL_RENDERBUFFER, self.colorRenderBuffer);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"CA合成GL失败...");
    }
}

- (void)display {
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, self.drawableWidth, self.drawableHeight);
    [self drawRect:self.bounds];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect {
    if ([self.delegate respondsToSelector:@selector(glkView:drawInRect:)]) {
        [self.delegate glkView:self drawInRect:[self bounds]];
    }
}

- (GLint)drawableHeight {
    GLint drawableHeight;
    // 初始化
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &drawableHeight);
    return drawableHeight;
}


- (GLint)drawableWidth {
    GLint drawableWidth;
    // 初始化
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &drawableWidth);
    return drawableWidth;
}






@end
