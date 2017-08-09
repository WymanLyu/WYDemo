//
//  ViewController.m
//  8-8Triangle
//
//  Created by wyman on 2017/8/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

// 顶点数据结构，一个三维坐标向量
typedef struct vector {
    GLKVector3 positionCoords;
}SceneVertex;

// 三角形顶点数据
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0}},
    {{ 0.5f, -0.5f, 0}},
    {{-0.5f,  0.5f, 0}}
};

@interface ViewController ()

/** 基础的片元着色器程序 */
@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end

@implementation ViewController

static GLuint vertexBufferID = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置GL上下文
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; // EAGL == Embled Apple GL ?
    [EAGLContext setCurrentContext:view.context];
    
    // 为GL创建片元着色器程序
    _baseEffect = [[GLKBaseEffect alloc] init];
    _baseEffect.useConstantColor = YES; // 使用常量颜色
    _baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0); // R G B A
    
    // 设置当前上下文的背景色
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    // step1:生成顶点buffer的标识
    glGenBuffers(1, &vertexBufferID); // bufferID个数-bufferID地址
    
    // step2:绑定bufferID到到GLES中
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID); // buffer类型-bufferID
    
    // step3:开辟内存初始化数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW); // buffer类型-buffer数据大小-buffer地址-存储操作方式（GL_STATIC_DRAW存入GPU中）
}

- (void)dealloc {
    if (vertexBufferID != 0) {
        // step7:删除buffer
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    GLKView *view = (GLKView *)self.view;
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
    
    // step4:启用顶点数据
    glEnableVertexAttribArray(GLKVertexAttribPosition); // buffer的数据包含的信息（GLKVertexAttribPosition 位置信息）
    
    // step5:设置指针
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL); // buffer的数据包含的信息-每个信息有几个部分(坐标位置有x,y,z)-每部分的数据类型-小数点固定类型是否可改(一般都不允许再修改)-buffer数据的步长（每个信息的长度）-从哪个指针访问buffer（NULL表示开始位置指针）
    
    // step6:绘制
    glDrawArrays(GL_TRIANGLES, 0, 3); // 绘制模式(三角形)-第一个绘制顶点位置-渲染数量
}



@end





















