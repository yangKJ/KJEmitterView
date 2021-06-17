//
//  NSTimer+KJExtension.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/16.
//  https://github.com/yangKJ/KJEmitterView

#import "NSTimer+KJExtension.h"
#import <objc/runtime.h>
@implementation NSTimer (KJExtension)
+ (NSTimer *)kj_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval Repeats:(BOOL)repeats Block:(void(^)(NSTimer * timer))block{
    return [NSTimer scheduledTimerWithTimeInterval:inerval target:self selector:@selector(blcokInvoke:) userInfo:[block copy] repeats:repeats];
}
+ (void)blcokInvoke:(NSTimer *)timer{
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) block(timer);
}
+ (NSTimer *)kj_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval Repeats:(BOOL)repeats Block:(void(^)(NSTimer * timer))block RunLoopMode:(NSRunLoopMode)mode{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:inerval target:self selector:@selector(runLoopblcokInvoke:) userInfo:[block copy] repeats:repeats];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:mode];
    return timer;
}
+ (void)runLoopblcokInvoke:(NSTimer*)timer{
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) block(timer);
}
/// 开启一个需添加到线程的可重复执行的NSTimer对象
+ (NSTimer *)kj_timerWithTimeInterval:(NSTimeInterval)inerval Repeats:(BOOL)repeats Block:(void(^)(NSTimer * timer))block{
    return [NSTimer timerWithTimeInterval:inerval target:self selector:@selector(xxxblcokInvoke:) userInfo:[block copy] repeats:repeats];
}
+ (void)xxxblcokInvoke:(NSTimer*)timer{
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) block(timer);
}
/// 立刻执行
- (void)kj_immediatelyTimer{
    if (![self isValid]) return;
    [self fire];
}
/// 暂停
- (void)kj_pauseTimer{
    if (![self isValid]) return;
    [self setFireDate:[NSDate distantFuture]];
}
/// 继续
- (void)kj_resumeTimer{
    if (![self isValid]) return;
    [self setFireDate:[NSDate date]];
}
/// 延时执行
- (void)kj_resumeTimerAfterTimeInterval:(NSTimeInterval)interval{
    if (![self isValid]) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}
/// 释放计时器
+ (void)kj_invalidateTimer:(NSTimer *)timer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
