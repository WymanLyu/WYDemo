//
//  CTFrameParser.m
//  WYCoreTextDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "CTFrameParser.h"

@implementation CTFrameParser

// 从配置中获取属性字典 （好蠢啊，直接设置即可了）
+ (NSDictionary *)attributesWithConfig:(CTFrameParserConfig *)config {
    // 1.创建文本字号
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    
    // 2.设置线宽
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    // 3.文本样式
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    UIColor * textColor = config.textColor;
    
    // 4.建立属性字典
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

// 创建文本
+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig*)config {
 
#warning 此处加载文件（JSON/XML/HTML）获取配置属性
    // 1.获取文本配置字典
    NSDictionary *attributes = [self attributesWithConfig:config];
    
    // 2.创建富文本
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content
                                    attributes:attributes];
    
    // 3.根据富文本创建文本设置
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
    // 4.从配置中获得要绘制的区域
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 5.生成文本
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 6.将文本对象保存至文本模型
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    // 7.释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
//    [[NSMutableAttributedString new] appendAttributedString:<#(nonnull NSAttributedString *)#>]
}

// 创建文本对象
+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(CTFrameParserConfig *)config
                                  height:(CGFloat)height {
    // 1.区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    // 2.创建文本
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}


@end
