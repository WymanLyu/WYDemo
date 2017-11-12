//
//  NSString+WYEasyObjEx.m
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "NSString+WYEasyObjEx.h"

@implementation NSString (WYEasyObjEx)

- (BOOL)easyObjEx_setter_equalTo:(NSString *)string {
    
    // 0.判断是否有足够的set长度
    if (self.length < 4) {
        return NO;
    }
    
    // 1.将自己的第四个字符转成小写
    NSString *newStr = self;
    for (NSInteger i=0; i<self.length; i++) {
        if (i==3) {
            if ([self characterAtIndex:i]>='A'&[self characterAtIndex:i]<='Z') { // 转成小写
                //A  65  a  97
                char  temp= [self characterAtIndex:i]+32;
                newStr = [self stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%c",temp]];
            }
        }
    }

    // 2.判断是否相等
    return [newStr isEqualToString:string];
}

@end
