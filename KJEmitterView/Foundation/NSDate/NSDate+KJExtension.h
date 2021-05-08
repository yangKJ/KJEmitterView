//
//  NSDate+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/16.
//  https://github.com/yangKJ/KJEmitterView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (KJExtension)
/* 判断两个日期是否在同一周 */
- (BOOL)kj_sameDate:(NSDate*)date;
/* 时间戳转指定类型时间字符串，时间戳是否为毫秒量级 */
FOUNDATION_EXPORT NSString * kTimestampToDateString(NSTimeInterval timestamp, BOOL msec, NSString *formatter);
/* 获取今日前后几天的日期 */
FOUNDATION_EXPORT NSString * kTodaySpaceDayString(int days, NSString *formatter);

@end

NS_ASSUME_NONNULL_END
