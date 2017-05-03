//
//  UIImage+Extension.m
//  02-01聊天界面
//
//  Created by sialice on 16/2/2.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "UIImage+WY.h"

@implementation UIImage (WY)

+ (instancetype)wy_resizabledImageNamed:(NSString *)name
{
    // 拉伸的图片
    UIImage *image = [UIImage imageNamed:name];
    //        UIEdgeInsets inset = UIEdgeInsetsMake(messageFrame.textBtnF.size.height*0.5 - 1, messageFrame.textBtnF.size.width*0.5 - 1, messageFrame.textBtnF.size.height*0.5, messageFrame.textBtnF.size.width*0.5);
    // 保护的范围（只拉伸中间的点）
    UIEdgeInsets inset = UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height*0.5, image.size.width *0.5);
    // 拉伸后的图片
    UIImage *resizabledImage = [image resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
    // 返回拉伸的图片
    return resizabledImage;
}

// 根据颜色创建一张图片
+ (instancetype)wy_imageWithUIColor:(UIColor *)color andFrame:(CGRect)rect
{
    // 开启上下文
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

// 翻转图片
- (UIImage *)wy_revertImageWithDirection:(ResizableImageDirection)direction {
    
    // 1.开启上下微博
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (direction == ResizableImageDirectionTop || direction == ResizableImageDirectionBottom) { // 上下翻转
        // 上下翻转坐标系
        CGContextTranslateCTM(ctx, 0, self.size.height);
        CGContextScaleCTM(ctx, 1, -1);
        [self drawAtPoint:CGPointZero];
        return UIGraphicsGetImageFromCurrentImageContext();
    }else if(direction == ResizableImageDirectionLeft || direction == ResizableImageDirectionRight) { // 左右翻转
        // 左右翻转
        CGContextTranslateCTM(ctx, self.size.width, 0);
        CGContextScaleCTM(ctx, -1, 1);
        [self drawAtPoint:CGPointZero];
        return UIGraphicsGetImageFromCurrentImageContext();
    }else { // 不翻转
        return self;
    }
}

// 返回圆角图片
- (instancetype)wy_circleCornerImage {
    // 根据图片设置上下文大小
    CGFloat border = self.size.width < self.size.height ? self.size.width : self.size.height;
    CGSize ctxSize = CGSizeMake(border, border);
    // 开启图片上下文
    //    UIGraphicsBeginImageContext(ctxSize);
    UIGraphicsBeginImageContextWithOptions(ctxSize, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置裁剪区域
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, border, border));
    CGContextClip(ctx);
    // 上下文绘制图片
    [self drawAtPoint:CGPointZero];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
    
}

// 异步返回圆角图片
- (void)wy_asynCircleCornerImageFinish:(void(^)(UIImage *circleCornerImage))finishHanled {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *circleImage = [self wy_circleCornerImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishHanled) {
                finishHanled(circleImage);
            }
        });
    });

}

- (UIImage *)wy_resizableImageWithSize:(CGSize)targetSize direction:(ResizableImageDirection)direction {
    
    // 拉伸区域
    UIEdgeInsets inset = UIEdgeInsetsZero;
    // 拉伸后图片宽度
    CGFloat targetWidth = self.size.width;
    // 拉伸后图片高度
    CGFloat targetHeight = self.size.height;
    // 根据类型调整
    if (direction == ResizableImageDirectionTop) { // 上
        inset = UIEdgeInsetsMake(1, 1, self.size.height -2, 1);
        // 如果原图过大则不拉伸
        if (targetSize.height < targetHeight) return self;
        targetHeight = targetSize.height;
    }else if (direction == ResizableImageDirectionBottom) { // 下
        inset = UIEdgeInsetsMake(self.size.height -2, 1, 1, 1);
        // 如果原图过大则不拉伸
        if (targetSize.height < targetHeight) return self;
        targetHeight = targetSize.height;
    }else if (direction == ResizableImageDirectionLeft) { // 左
        inset = UIEdgeInsetsMake(1, 1, 1, self.size.width -2);
        // 如果原图过大则不拉伸
        if (targetSize.width < targetWidth) return self;
        targetWidth = targetSize.width;
    }else if (direction == ResizableImageDirectionRight) { // 右
        inset = UIEdgeInsetsMake(1, self.size.width -2, 1, 1);
        // 如果原图过大则不拉伸
        if (targetSize.width < targetWidth) return self;
        targetWidth = targetSize.width;
    }else if (direction == ResizableImageDirectionHorizontal) { // 水平拉伸
        return  [self wy_resizableImageWithSize:targetSize axis:direction];
    }else if (direction == ResizableImageDirectionVertical) { // 垂直
        return  [self wy_resizableImageWithSize:targetSize axis:direction];
    }else if (direction == ResizableImageDirectionCenter) { // 中心
        return [self wy_resizableImageWithSize:targetSize axis:direction];
    }else {
        return self;
    }
    
    // 拉伸后的图片
    UIImage *resizabledImage = [self resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight), NO, [UIScreen mainScreen].scale);
    [resizabledImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    //拿到拉伸过的图片
    UIImage *strechImage = UIGraphicsGetImageFromCurrentImageContext();
//    NSLog(@"拉伸%zd类型后尺寸--%@", direction, NSStringFromCGSize(strechImage.size));
    UIGraphicsEndImageContext();
    return strechImage;
}

- (UIImage *)wy_resizableImageWithSize:(CGSize)targetSize axis:(ResizableImageDirection)direction {
    
    if (direction == ResizableImageDirectionHorizontal) { // 左右拉伸
        
        // 1.先拉申左边
        CGSize targetLeftSize = CGSizeMake(targetSize.width*0.5 + self.size.width*0.5, self.size.height);
        UIImage *resizableLeftImg = [self wy_resizableImageWithSize:targetLeftSize direction:ResizableImageDirectionLeft];
        
        // 2.拉伸右边
        CGSize targetRightSize = CGSizeMake(targetSize.width, resizableLeftImg.size.height);
        return [resizableLeftImg wy_resizableImageWithSize:targetRightSize direction:ResizableImageDirectionRight];
        
    }else if (direction == ResizableImageDirectionVertical) { // 上下拉伸
        
        // 1.先拉伸上边
        CGSize targetTopSize = CGSizeMake(self.size.width, targetSize.height*0.5 + self.size.height*0.5);
        UIImage *resizableTopImg = [self wy_resizableImageWithSize:targetTopSize direction:ResizableImageDirectionTop];
        
        // 2.拉伸下边
        CGSize targetBottomSize = CGSizeMake(targetTopSize.width, targetSize.height);
        return [resizableTopImg wy_resizableImageWithSize:targetBottomSize direction:ResizableImageDirectionBottom];
        
    }else if (direction == ResizableImageDirectionCenter) { // 居中不变
        
        UIImage *resizableHorizontalImg = [self wy_resizableImageWithSize:targetSize axis:ResizableImageDirectionHorizontal];
        return [resizableHorizontalImg wy_resizableImageWithSize:targetSize axis:ResizableImageDirectionVertical];
        
    }else { // 不拉伸
        return self;
    }
    
}


@end
