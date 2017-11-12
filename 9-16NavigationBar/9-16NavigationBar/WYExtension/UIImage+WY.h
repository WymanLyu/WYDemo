//
//  UIImage+Extension.h
//  
//
//  Created by sialice on 16/2/2.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ResizableImageDirection) {
    ResizableImageDirectionTop        = 2,
    ResizableImageDirectionBottom     = 2<<1,
    ResizableImageDirectionLeft       = 2<<2,
    ResizableImageDirectionRight      = 2<<3,
    ResizableImageDirectionHorizontal = 14,
    ResizableImageDirectionVertical   = 6,
    ResizableImageDirectionCenter     = 20,
};

@interface UIImage (WY)


// 利用拉伸模式进行拉伸图片
+ (instancetype)wy_resizabledImageNamed:(NSString *)name;

// 根据颜色创建一张图片
+ (instancetype)wy_imageWithUIColor:(UIColor *)color andFrame:(CGRect)rect;

// 设置圆形图片 半径为最小边
- (instancetype)wy_circleCornerImage;

// 异步返回圆角图片
- (void)wy_asynCircleCornerImageFinish:(void(^)(UIImage *circleCornerImage))finishHanled;

// 翻转图片
- (UIImage *)wy_revertImageWithDirection:(ResizableImageDirection)direction;

// 拉伸某个方向拉伸
- (UIImage *)wy_resizableImageWithSize:(CGSize)targetSize direction:(ResizableImageDirection)direction;

// 沿某个轴进行拉伸
- (UIImage *)wy_resizableImageWithSize:(CGSize)targetSize axis:(ResizableImageDirection)direction;

// 压缩图片 sizeScale 0- 1
- (UIImage *)wy_compressImageBySizeScale:(CGFloat)sizeScale;


@end
