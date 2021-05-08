//
//  NSDate+KJExtension.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/16.
//  https://github.com/yangKJ/KJEmitterView

#import "NSDate+KJExtension.h"

@implementation NSDate (KJExtension)
/* 判断两个日期是否在同一周 */
- (BOOL)kj_sameDate:(NSDate*)date{
    if (fabs([self timeIntervalSinceDate:date]) >= 7 * 24 * 3600){
        return NO;
    }
    NSCalendar *calender = [NSCalendar currentCalendar];
    calender.firstWeekday = 2;
    NSUInteger countSelf = [calender ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:self];
    NSUInteger countDate = [calender ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:date];
    return countSelf == countDate;
}
/* 时间戳转指定类型时间字符串，时间戳是否为毫秒量级 */
NSString * kTimestampToDateString(NSTimeInterval timestamp, BOOL msec, NSString *formatter){
    if (msec) timestamp /= 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    return [dateformatter stringFromDate:date];
}
/* 获取今日前后几天的日期 */
NSString * kTodaySpaceDayString(int days, NSString *formatter){
    NSDate *appointDate;
    if (days == 0) {
        appointDate = [NSDate date];
    }else if (days < 0) {
        NSTimeInterval oneDay = 24 * 60 * 60;
        appointDate = [[NSDate date] initWithTimeIntervalSince1970:oneDay * days];
    } else {
        NSTimeInterval oneDay = 24 * 60 * 60;
        appointDate = [[NSDate date] initWithTimeIntervalSinceNow:oneDay * days];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *time = [dateFormatter stringFromDate:appointDate];
    return time;
}


@end
