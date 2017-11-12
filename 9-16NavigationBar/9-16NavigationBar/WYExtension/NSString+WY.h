//
//  NSString+Extension.h
//  
//
//  Created by sialice on 16/4/1.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored"duplicate definition of category 'WY' on interface 'UIView'"

@interface NSString (WY)

#pragma mark - 文字尺寸

/** 获取自适应宽度 */
- (CGRect)wy_getSize;

/** 获取文件类型 */
- (NSString *)wy_getMIMEType;

/** 给定字号 返回一行文字实际宽度 */
- (CGFloat)wy_getWidthInOneLineWithFont:(UIFont *)font;
/** 给定字号 返回一行文字实际高度 */
- (CGFloat)wy_getHeightInOneLineWithFont:(UIFont *)font;

/** 给定最大宽度和字号 返回实际高度 */
- (CGFloat)wy_getHeightWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;

/** 给定最大宽度和字号 再根据行数返回实际高度 */
- (CGFloat)wy_getHeightWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font inNumberLine:(NSInteger)number;

/** 给定最大尺寸（按屏幕宽度） */
- (CGRect)wy_getSizeWithFont:(UIFont *)font;

#pragma mark - 校验

/** 判断时候是手机号 */
- (BOOL)wy_isValidatePhone;

/** 判断字符串是否为纯数字 */
- (BOOL)wy_isPureNumandCharacters;

/** 判断是否有中文 */
- (BOOL)wy_isContainChinese;

@end

#pragma clang diagnostic pop
