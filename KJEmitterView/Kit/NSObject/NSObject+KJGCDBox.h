//
//  NSObject+KJGCDBox.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/3/17.
//  https://github.com/yangKJ/KJEmitterView
//  GCD盒子封装，常驻线程封装

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KJGCDBox)
/// 创建异步定时器，相比 NSTimer 和 CADisplayLink 更加精准（这两者都是基于runloop处理）
- (dispatch_source_t)kj_createGCDAsyncTimer:(BOOL)async
                                       Task:(void(^)(void))task
                                      start:(NSTimeInterval)start
                                   interval:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats;
/// 取消计时器
- (void)kj_gcdStopTimer:(dispatch_source_t)timer;
/// 暂停计时器
- (void)kj_gcdPauseTimer:(dispatch_source_t)timer;
/// 继续计时器
- (void)kj_gcdResumeTimer:(dispatch_source_t)timer;

/// 延时执行
- (void)kj_gcdAfterTask:(void(^)(void))task
                   time:(NSTimeInterval)time
                  Asyne:(BOOL)async;
/// 异步快速迭代
- (void)kj_gcdApplyTask:(BOOL(^)(size_t index))task
                  count:(NSUInteger)count;

#pragma mark - 常驻线程封装
/// 常驻线程，线程保活
- (void)kj_residentThreadBlock:(void(^)(void))block;
/// 停止常驻线程
- (void)kj_stopResidentThread;

#pragma mark - GCD 线程处理
/// 创建队列
FOUNDATION_EXPORT dispatch_queue_t kGCD_queue(void);
/// 主线程
FOUNDATION_EXPORT void kGCD_main(dispatch_block_t block);
/// 子线程
FOUNDATION_EXPORT void kGCD_async(dispatch_block_t block);
/// 异步并行队列，携带可变参数（需要nil结尾）
FOUNDATION_EXPORT void kGCD_group_notify(dispatch_block_t notify, dispatch_block_t block,...);
/// 栅栏
FOUNDATION_EXPORT dispatch_queue_t kGCD_barrier(dispatch_block_t block, dispatch_block_t barrier);
/// 栅栏实现多读单写操作，barrier当中完成写操作，携带可变参数（需要nil结尾）
FOUNDATION_EXPORT void kGCD_barrier_read_write(dispatch_block_t barrier, dispatch_block_t block,...);
/// 一次性
FOUNDATION_EXPORT void kGCD_once(dispatch_block_t block);
/// 延时执行
FOUNDATION_EXPORT void kGCD_after(int64_t delayInSeconds, dispatch_block_t block);
/// 主线程当中延时执行
FOUNDATION_EXPORT void kGCD_after_main(int64_t delayInSeconds, dispatch_block_t block);
/// 快速迭代
FOUNDATION_EXPORT void kGCD_apply(int iterations, void(^block)(size_t idx));
/// 快速遍历数组
FOUNDATION_EXPORT void kGCD_apply_array(NSArray * temp, void(^block)(id obj, size_t index));

@end

NS_ASSUME_NONNULL_END
