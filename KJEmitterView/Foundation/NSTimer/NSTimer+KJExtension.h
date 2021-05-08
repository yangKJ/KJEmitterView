//
//  NSTimer+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/16.
//  https://github.com/yangKJ/KJEmitterView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (KJExtension)
/// 开启一个当前线程内可重复执行的NSTimer对象
+ (NSTimer*)kj_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                      Repeats:(BOOL)repeats
                                        Block:(void(^)(NSTimer*timer))block;
/// 开启一个当前线程内可重复执行的NSTimer对象
+ (NSTimer*)kj_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                      Repeats:(BOOL)repeats
                                        Block:(void(^)(NSTimer*timer))block
                                  RunLoopMode:(NSRunLoopMode)mode;
/// 开启一个需添加到线程的可重复执行的NSTimer对象
+ (NSTimer*)kj_timerWithTimeInterval:(NSTimeInterval)inerval
                             Repeats:(BOOL)repeats
                               Block:(void(^)(NSTimer*timer))block;
/// 立刻执行
- (void)kj_immediatelyTimer;
/// 暂停
- (void)kj_pauseTimer;
/// 重启计时器
- (void)kj_resumeTimer;
/// 延时执行
- (void)kj_resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
/// 释放计时器
+ (void)kj_invalidateTimer:(NSTimer*)timer;

@end

NS_ASSUME_NONNULL_END
