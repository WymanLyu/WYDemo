//
//  BackgroundFilter.m
//  WYCoreImageDemo
//
//  Created by yunyao on 16/9/13.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "BackgroundFilter.h"

NSString  * const inputMinHueAngle = @"minHueAngle";
NSString  * const inputMaxHueAngle = @"maxHueAngle";

// RGB -》 HSV
void rgbToHSV(float *rgb, float *hsv)
{
    float min, max, delta;
    float r = rgb[0], g = rgb[1], b = rgb[2];
    float *h = hsv, *s = hsv + 1, *v = hsv + 2;
    
    min = fmin(fmin(r, g), b );
    max = fmax(fmax(r, g), b );
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h = 2 + ( b - r ) / delta;
    else
        *h = 4 + ( r - g ) / delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}

void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

@implementation BackgroundFilter
{
    CGFloat minHueAngle;
    CGFloat maxHueAngle;
    CIImage *inputImage;
}

@synthesize inputImage = inputImage;

// 重写滤镜链
- (CIImage *)outputImage {
    
    // 1.创建立方色彩梯度模型
    // 单个颜色通道的色彩个数
    const unsigned int colorSize = 64;
    // 颜色通道数（有一个是alpha）
    int colorChannel = 4;
    // 此模型的颜色总数
    int colorCategories = colorSize * colorSize * colorSize;
    // 开辟色彩梯度模型的内存【一个颜色需要的内存大小是 sizeof(float)*colorChannel 】
    float *cubeData = (float *)malloc(colorCategories * sizeof(float)*colorChannel);
    
    // 2.创建数据处理的容器
    // 操作立方模型的指针
    float *c = cubeData;
    // rgb数组
    float rgb[3];
    // hsv数组
    float hsv[3];
    
    // 3.遍历存储所有颜色存储进立方模型（筛选不要的颜色）
    for (int b = 0; b < colorSize; b++) {
        
        rgb[2] = ((float)b) / (colorSize-1); // 蓝色通道
        
        for (int g = 0; g < colorSize; g++) {
            
            rgb[1] = ((float)g) / (colorSize-1); // 绿色通道
            
            for (int r = 0; r < colorSize; r++) {
                
                rgb[2] = ((float)r) / (colorSize - 1); // 红色通道
                
                // 3.1.进行色彩转化至HSV
//                rgbToHSV(rgb, hsv);
                RGBtoHSV(rgb[0], rgb[1], rgb[2], &hsv[0], &hsv[1], &hsv[2]);
                
                // 3.2.去除不需要的颜色
                float alpha = (hsv[0] > minHueAngle && hsv[0] < maxHueAngle)? 0.0f : 1.0f;
                
                // 3.3.写入色彩立方模型
                c[0] = rgb[0]*alpha;
                c[1] = rgb[1]*alpha;
                c[2] = rgb[2]*alpha;
                c[3] = alpha;
                
                c+=4;
            }
            
        }
    }
    
    // 4.创建NSData
    NSData *data = [NSData dataWithBytesNoCopy:cubeData length:colorCategories * sizeof(float)*colorChannel freeWhenDone:YES];
    
    // 5.创建色彩立方滤镜
    CIFilter *cubeFilter = [CIFilter filterWithName:@"CIColorCube"];
    // 设置色彩立方
    [cubeFilter setValue:@(colorSize) forKey:@"inputCubeDimension"];
    [cubeFilter setValue:data forKey:@"inputCubeData"];
    // 设置输入图
    [cubeFilter setValue:inputImage forKey:kCIInputImageKey];
    
    // 混合背景图
    CIImage *backGroundImg = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:@"/Users/yunyao/Library/Containers/com.tencent.qq/Data/Library/Application Support/QQ/Users/384846187/QQ/Temp.db/4EA839F7-4DD3-4D29-863A-A28F9E859972.png"]];
//    [cubeFilter setValue:backGroundImg forKey:@"inputBackgroundImage"];
    CIFilter *sourceOverCompositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [sourceOverCompositingFilter setValue:cubeFilter.outputImage forKey:kCIInputImageKey];
    [sourceOverCompositingFilter setValue:backGroundImg forKey:kCIInputBackgroundImageKey];
  
    // 返回值
    return cubeFilter.outputImage;
//    return sourceOverCompositingFilter.outputImage;
}

@end
