//
//  CTFrameParser.h
//  WYCoreTextDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//  文本构造

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"

@interface CTFrameParser : NSObject

/**
 *  通过文本配置，将内容生成文本
 *
 *  @param content 文本字符内容
 *  @param config  解析设置
 *
 *  @return
 */
+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig*)config;

@end
