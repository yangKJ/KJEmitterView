//
//  UIButton+KJBlock.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/4/4.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UIButton+KJBlock.h"
#import <objc/runtime.h>
@implementation UIButton (KJBlock)
static NSString * const _Nonnull KJButtonControlEventsStringMap[] = {
    [UIControlEventTouchDown]        = @"KJ_X_UIControlEventTouchDown",
    [UIControlEventTouchDownRepeat]  = @"KJ_X_UIControlEventTouchDownRepeat",
    [UIControlEventTouchDragInside]  = @"KJ_X_UIControlEventTouchDragInside",
    [UIControlEventTouchDragOutside] = @"KJ_X_UIControlEventTouchDragOutside",
    [UIControlEventTouchDragEnter]   = @"KJ_X_UIControlEventTouchDragEnter",
    [UIControlEventTouchDragExit]    = @"KJ_X_UIControlEventTouchDragExit",
    [UIControlEventTouchUpInside]    = @"KJ_X_UIControlEventTouchUpInside",
    [UIControlEventTouchUpOutside]   = @"KJ_X_UIControlEventTouchUpOutside",
    [UIControlEventTouchCancel]      = @"KJ_X_UIControlEventTouchCancel",
};
#define KJButtonAction(name) \
- (void)kj_action##name{ \
KJButtonBlock block = objc_getAssociatedObject(self, _cmd);\
if (block) block(self);\
}
/// 事件响应方法
KJButtonAction(KJ_X_UIControlEventTouchDown);
KJButtonAction(KJ_X_UIControlEventTouchDownRepeat);
KJButtonAction(KJ_X_UIControlEventTouchDragInside);
KJButtonAction(KJ_X_UIControlEventTouchDragOutside);
KJButtonAction(KJ_X_UIControlEventTouchDragEnter);
KJButtonAction(KJ_X_UIControlEventTouchDragExit);
KJButtonAction(KJ_X_UIControlEventTouchUpInside);
KJButtonAction(KJ_X_UIControlEventTouchUpOutside);
KJButtonAction(KJ_X_UIControlEventTouchCancel);

/// 添加点击事件，默认UIControlEventTouchUpInside
- (void)kj_addAction:(KJButtonBlock)block{
    [self kj_addAction:block forControlEvents:UIControlEventTouchUpInside];
}
/// 添加事件
- (void)kj_addAction:(KJButtonBlock)block forControlEvents:(UIControlEvents)controlEvents{
    if (block == nil || controlEvents > (1<<8)) return;
    if (controlEvents != UIControlEventTouchDown && (controlEvents&1)) return;
    NSString *actionName = [@"kj_action" stringByAppendingFormat:@"%@",KJButtonControlEventsStringMap[controlEvents]];
    SEL selector = NSSelectorFromString(actionName);
    objc_setAssociatedObject(self, selector, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:selector forControlEvents:controlEvents];
}


#pragma mark - 时间相关方法交换
/// 交换方法后实现
- (void)kj_sendAction:(SEL)action to:(id)target forEvent:(UIEvent*)event{
    if (self.timeInterval <= 0) {
        [self kj_sendAction:action to:target forEvent:event];
        return;
    }
    NSTimeInterval time = CFAbsoluteTimeGetCurrent();
    if ((time - self.lastTime >= self.timeInterval)) {
        self.lastTime = time;
        [self kj_sendAction:action to:target forEvent:event];
    }
}
#pragma mark - associated
- (CGFloat)timeInterval{
    return [objc_getAssociatedObject(self, @selector(timeInterval)) doubleValue];
}
- (void)setTimeInterval:(CGFloat)timeInterval{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_ASSIGN);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kExceptionMethodSwizzling([self class], @selector(sendAction:to:forEvent:), @selector(kj_sendAction:to:forEvent:));
    });
}
- (NSTimeInterval)lastTime{
    return [objc_getAssociatedObject(self, @selector(lastTime)) doubleValue];
}
- (void)setLastTime:(NSTimeInterval)lastTime{
    objc_setAssociatedObject(self, @selector(lastTime), @(lastTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/// 交换实例方法的实现
static void kExceptionMethodSwizzling(Class clazz, SEL original, SEL swizzled){
    Method originalMethod = class_getInstanceMethod(clazz, original);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzled);
    if (class_addMethod(clazz, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(clazz, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
