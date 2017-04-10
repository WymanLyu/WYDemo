//
//  YSSongLrcLine.m
//  HeiPa
//
//  Created by wyman on 2017/3/27.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "YSSongLrcLine.h"

@implementation YSSongLrcLine

+ (instancetype)songLrcLineWithString:(NSString *)lrcLineString {
    YSSongLrcLine *lrcLine = [YSSongLrcLine new];
    
    // 解析歌词
    // [00:11.091]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？
    // 匹配时间
    NSString *pattern = @"^\\[.*\\]";
    // 创建正则表达
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    //查找第一个匹配结果，如果查找不到的话match会是nil
    NSTextCheckingResult *match = [regex firstMatchInString:lrcLineString
                                                    options:NSMatchingReportCompletion
                                                      range:NSMakeRange(0, [lrcLineString length])];
    if (match) {
        // 时间
        NSLog(@"%@",[lrcLineString substringWithRange:NSMakeRange(1, match.range.length-2)]);
        // 歌词
        NSLog(@"%@",[lrcLineString substringWithRange:NSMakeRange(match.range.length, [lrcLineString length]-match.range.length)]);

        if (match.range.length-2) {
            NSString *timeStr = [lrcLineString substringWithRange:NSMakeRange(1, match.range.length-2)];
            lrcLine.beginTime = [self convertSting2Time:timeStr];
        }
        if ([lrcLineString length]-match.range.length) {
            lrcLine.lrcLineText = [lrcLineString substringWithRange:NSMakeRange(match.range.length, [lrcLineString length]-match.range.length)];
        }
    }
    return lrcLine;
}

+ (NSTimeInterval)convertSting2Time:(NSString *)string {
    // 分钟
    NSInteger min = [[string componentsSeparatedByString:@":"][0] integerValue];
    // 秒
    NSInteger sec = [[string substringWithRange:NSMakeRange(3, 2)] integerValue];
    // 毫秒
    NSInteger hs = [[string componentsSeparatedByString:@"."][1] integerValue];
    return min * 60 + sec + hs * 0.01;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%f-%@", self.beginTime, self.lrcLineText];
}


@end
