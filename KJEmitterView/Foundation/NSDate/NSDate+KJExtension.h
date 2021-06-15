//
//  NSDate+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/16.
//  https://github.com/yangKJ/KJEmitterView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (KJExtension)
/// 是否为昨天
@property (nonatomic,assign,readonly) BOOL isYesterday;
/// 是否同一周
- (BOOL)kj_weekSameDate:(NSDate*)date;
/// 是否同一天
- (BOOL)kj_daySameDate:(NSDate*)date;
/// 蔡勒公式获取周几
- (NSInteger)kj_weekDay;
/// 当前周末日期
- (NSDate*)kj_weekendDate;
/// 将日期转化为本地时间
- (NSDate*)kj_localeDate;
/// 本月多少天
- (NSUInteger)kj_monthHowDays;
/// 月初
- (NSDate*)kj_monthFristDay;
/// 月末
- (NSDate*)kj_monthLastDay;
/// 偏移几天的日期
- (NSString*)kj_skewingDay:(NSInteger)day format:(NSString*)format;
/// 偏移几月的日期
- (NSString*)kj_skewingMonth:(NSInteger)month format:(NSString*)format;

/// 时间字符串转位NSDate
+ (NSDate*)kj_dateFromString:(NSString*)string;
/// 获取当前时间戳，是否为毫秒
+ (NSTimeInterval)kj_currentTimeTimestampWithFormat:(NSString*)format msec:(BOOL)msec;
/// 时间戳转时间，内部判断是毫秒还是秒
+ (NSString*)kj_timeWithTimestamp:(NSTimeInterval)timestamp format:(NSString*)format;

@end

NS_ASSUME_NONNULL_END
