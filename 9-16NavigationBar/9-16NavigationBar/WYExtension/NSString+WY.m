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

#pragma mark - 校验

- (BOOL)wy_isValidatePhone {
    NSString *phone = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phone.length != 11) {
        return NO;
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phone];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phone];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phone];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}


- (BOOL)wy_isContainChinese {
    if (!self.length) {
        return NO;
    }
    for(int i=0; i<[self length]; i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
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
