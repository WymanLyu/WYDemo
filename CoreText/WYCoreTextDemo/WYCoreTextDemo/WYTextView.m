//
//  WYTextView.m
//  WYCoreTextDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYTextView.h"
#import <CoreText/CoreText.h>

@implementation WYTextView


- (void)drawRect:(CGRect)rect {
    // 1.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2.反转坐标
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 3.绘制路线
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    // 4.创建富文本
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Hello World!"];
    
    // 5.1.根据富文本创建 文本设置
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    // 5.2.根据结构设置 + 区域 + 路径 + 结构属性  创建文本
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, [attString length]), path, NULL);

    // 6.绘制到view
    CTFrameDraw(frame, context);
    
    // 7.清空
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}


@end
