//
//  NSDate+WY.m
//  by-wyman.lyu-mail: wyman.lyu@gmail.com
//
//  Created by sialice on 16/5/6.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "NSDate+WY.h"

@implementation NSDate (WY)

+ (NSString *)wy_currentDate {
    
    NSDate *  date=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString * str = [dateformatter stringFromDate:date];
    
    return str;
}

- (BOOL)wy_isThisYear{
    // 两个时间
    NSDate *date1 = self;
    NSDate *date2 = [NSDate date];
    
    // 把时间字符串转NSDate类型
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间的格式
    fmt.dateFormat = @"yyyy";
    
    NSString *dateStr1 = [fmt stringFromDate:date1];
    NSString *dateStr2 = [fmt stringFromDate:date2];
    
    return [dateStr1 isEqualToString:dateStr2];
    
}

- (BOOL)wy_isToday{
    // 两个时间
    NSDate *date1 = self;
    NSDate *date2 = [NSDate date];
    
    // 把时间字符串转NSDate类型
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间的格式
    fmt.dateFormat = @"yyyyMMdd";
    
    NSString *dateStr1 = [fmt stringFromDate:date1];
    NSString *dateStr2 = [fmt stringFromDate:date2];
    
    return [dateStr1 isEqualToString:dateStr2];
}


- (BOOL)wy_isYesterday{
    
    
    // 把时间字符串转NSDate类型
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间的格式
    
    
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = self;
    NSDate *date2 = [NSDate date];
    
    //把时分秒去除了
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr1 = [fmt stringFromDate:date1];
    NSString *dateStr2 = [fmt stringFromDate:date2];
    
    date1 = [fmt dateFromString:dateStr1];
    date2 = [fmt dateFromString:dateStr2];
    
    // 日历类
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unit fromDate:date1 toDate:date2 options:0];
    
    BOOL isYesterDay = (components.year == 0 &&  components.month == 0 && components.day == 1);
    
    
    return isYesterDay;
}

- (NSString *)wy_formatTimeString{
    // 把时间字符串转NSDate类型
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间的格式
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *str = [fmt stringFromDate:self];
    NSDate *date = [fmt dateFromString:str];
    
    if ([date wy_isThisYear]) {//NSLog(@"今年");
        if ([date wy_isToday]) {//今天
            // 获取两个时间的 秒数、分钟数、小时数的差
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitSecond |  NSCalendarUnitMinute |NSCalendarUnitHour;
            NSDateComponents *components = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
            // 1小时20分10秒
            if (components.hour > 0) {//24小时内："N小时前"
                return  [NSString stringWithFormat:@"%zd小时前",components.hour];
            }else if (components.minute > 0){//60分钟内 "N分钟前"
                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
            }else{//60秒内 "刚刚"
                return @"刚刚";
            }
            
        }else if([date wy_isYesterday]){//NSLog(@"昨天");
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:date];
        }else{//NSLog(@"前天");
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:date];
        }
    }else{//NSLog(@"非今年");
        
        // 把时间字符串转NSDate类型
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        // 设置时间的格式
        fmt.dateFormat = @"yyyyMMdd";
        return [fmt stringFromDate:date];
    }
    
}

- (NSString *)wy_formatTimeStringInMocha{
    // 把时间字符串转NSDate类型
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间的格式
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *str = [fmt stringFromDate:self];
    NSDate *date = [fmt dateFromString:str];
    
    if ([date wy_isThisYear]) {//NSLog(@"今年");
        if ([date wy_isToday]) {//今天
            // 获取两个时间的 秒数、分钟数、小时数的差
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitSecond |  NSCalendarUnitMinute | NSCalendarUnitHour;
            NSDateComponents *components = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
            // 1小时20分10秒
            if (components.hour > 0) {//24小时内："N小时前"
                return  [NSString stringWithFormat:@"%zd小时前",components.hour];
            }else if (components.minute > 0){//60分钟内 "N分钟前"
                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
            }else{//60秒内 "刚刚"
                return [NSString stringWithFormat:@"%zd秒前",components.second];
            }
            
        }else{//NSLog(@"前天");
            // 获取两个时间的天数的差
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth;
            NSDateComponents *components = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
            if (components.month > 0) {
                return [NSString stringWithFormat:@"%zd月前",components.month];
            }else{
                if(components.day > 0) {
                     return [NSString stringWithFormat:@"%zd天前",components.day];
                }else {
                     return @"1天前";
                }
               
            }
            
//            fmt.dateFormat = @"dd";
//            NSString *dateStr = [fmt stringFromDate:date];
//            NSString *currentDate = [fmt stringFromDate:[NSDate date]];
//            return [NSString stringWithFormat:@"%zd天前", (currentDate.integerValue - dateStr.integerValue)];
            
        }
    }else{//NSLog(@"非今年");
        
        fmt.dateFormat = @"yyyy";
        NSString *dateStr = [fmt stringFromDate:date];
        NSString *currentDate = [fmt stringFromDate:[NSDate date]];
        return [NSString stringWithFormat:@"%zd年前", (currentDate.integerValue - dateStr.integerValue)];

    }
    
}

/**
 * 抹茶工程中的直播预告时间
 */
- (NSString *)wy_formatTimeStringInMochaLiveAdvance {
    // 把时间字符串转NSDate类型
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间的格式
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 获取目标时间
    NSString *str = [fmt stringFromDate:self];
    NSDate *advanceDate = [fmt dateFromString:str];
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [advanceDate timeIntervalSinceDate:currentDate];
    if (timeInterval > 0) { //未到达时间
        if ([advanceDate wy_isToday]) { // 今天
            // 获取两个时间的 秒数、分钟数、小时数的差
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitSecond |  NSCalendarUnitMinute | NSCalendarUnitHour;
            NSDateComponents *components = [calendar components:unit fromDate:currentDate toDate:advanceDate options:0];
            // 1小时20分10秒
            if (components.hour > 0) {//24小时内："N小时前"
                // 把时间字符串转NSDate类型
                NSDateFormatter *fmtH = [[NSDateFormatter alloc] init];
                // 设置时间的格式
                fmtH.dateFormat = @"HH:mm";
                // 获取目标时间
                NSString *strH = [fmtH stringFromDate:advanceDate];
                return  [NSString stringWithFormat:@"今天%@开始",strH];
            }else if (components.minute > 0){//60分钟内 "N分钟后"
                return [NSString stringWithFormat:@"今天%zd分钟后开始",components.minute];
            }else{//60秒内 "刚刚"
                return [NSString stringWithFormat:@"今天%zd秒后开始",components.second];
            }
        }else { // 未来几天
            // 获取两个时间的 秒数、分钟数、小时数的差
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitSecond |  NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay;
            NSDateComponents *components = [calendar components:unit fromDate:currentDate toDate:advanceDate options:0];
//            NSLog(@"当前时间%@==》=》目标时间%@===》目标时间2%@", [fmt stringFromDate:currentDate],[fmt stringFromDate:self], [fmt stringFromDate:advanceDate]);
            // 1小时20分10秒
            NSString *curStr = [fmt stringFromDate:advanceDate];
            NSString *hourStr = [curStr substringWithRange:NSMakeRange(@"yyyy-MM-dd ".length, 5)];
            NSString *dayStr = @"明天";
            if (components.day == 2) {
                dayStr = @"后天";
            }else if (components.day == 1) {
                dayStr = @"明天";
            }else if (components.day == 0){
                dayStr = @"明天";
            }else {
                dayStr = [NSString stringWithFormat:@"%zd天", (components.day)];
            }
            return [NSString stringWithFormat:@"%@%@开始",dayStr, hourStr];
        }
    } else { // 已过期
        
        // 获取两个时间的 秒数、分钟数、小时数的差
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitSecond |  NSCalendarUnitMinute | NSCalendarUnitHour;
        NSDateComponents *components = [calendar components:unit fromDate:advanceDate toDate:currentDate options:0];
        // 1小时20分10秒
        if (components.hour > 0) {//24小时内："N小时前"
            return  [NSString stringWithFormat:@"已延时%zd小时",components.hour];
        }else if (components.minute > 0){//60分钟内 "N分钟前"
            return [NSString stringWithFormat:@"已延时%zd分钟",components.minute];
        }else{//60秒内 "刚刚"
            return [NSString stringWithFormat:@"已延时%zd秒始",components.second];
        }
    }
    
}




@end
