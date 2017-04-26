//
//  NSString+Extension.m
//  03-25WYSlideView
//
//  Created by sialice on 16/4/1.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "NSString+WY.h"


@implementation NSString (WY)

/** 给定最大尺寸（按屏幕宽度） */
- (CGRect)wy_getSizeWithFont:(UIFont *)font {
    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    NSDictionary *textFontDict = @{NSFontAttributeName:font};
    CGRect textContentRect = [self boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textFontDict context:nil];
    return textContentRect;
}

/** 给定最大宽度和字号 返回实际高度 */
- (CGFloat)wy_getHeightWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font{
    CGSize textMaxSize = CGSizeMake(maxWidth, MAXFLOAT);
    NSDictionary *textFontDict = @{NSFontAttributeName:font};
    CGRect textContentRect = [self boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textFontDict context:nil];
    return textContentRect.size.height;
}

/** 给定字号 返回一行文字实际宽度 */
- (CGFloat)wy_getWidthInOneLineWithFont:(UIFont *)font {
    
    CGFloat maxH = [@"oneLineH" wy_getHeightWithMaxWidth:MAXFLOAT font:font];
    CGSize textMaxSize = CGSizeMake(MAXFLOAT, maxH);
    NSDictionary *textFontDict = @{NSFontAttributeName:font};
    CGRect textContentRect = [self boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textFontDict context:nil];
    
    
    return textContentRect.size.width;
}

- (CGFloat)wy_getHeightInOneLineWithFont:(UIFont *)font {
    return [@"8888" wy_getHeightWithMaxWidth:[UIScreen mainScreen].bounds.size.width font:font inNumberLine:1];
}
/** 给定最大宽度和字号 再根据行数返回实际高度 */
- (CGFloat)wy_getHeightWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font inNumberLine:(NSInteger)number {
    
    CGFloat maxH = [@"oneLineH" wy_getHeightWithMaxWidth:maxWidth font:font];
    CGSize textMaxSize = CGSizeMake(maxWidth, maxH*number);
    NSDictionary *textFontDict = @{NSFontAttributeName:font};
    CGRect textContentRect = [self boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textFontDict context:nil];
    
    
    return textContentRect.size.height;
}

// 给定文件路径判断文件类型
- (NSString *)wy_getMIMEType
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self]];
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}

// 判断字符串是否为纯数字
- (BOOL)wy_isPureNumandCharacters
{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(str.length > 0)
    {
        return NO;
    }
    return YES;
}

#pragma mark - 遗弃
/** 给定最大尺寸（按屏幕宽度） */
- (CGRect)wy_getSize {
    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    NSDictionary *textFontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]};
    CGRect textContentRect = [self boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textFontDict context:nil];
    return textContentRect;
}

@end
