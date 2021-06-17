//
//  UITextView+KJBackout.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/10.
//  https://github.com/yangKJ/KJEmitterView

#import "UITextView+KJBackout.h"
#import <objc/runtime.h>

@implementation UITextView (KJBackout)
/// 撤销输入，相当于 command + z
- (void)kj_textViewBackout{
    NSInteger count = self.textTemps.count;
    if (count == 0) return;
    if (count > 1) {
        [self.textTemps removeLastObject];
    }
    self.text = self.textTemps.lastObject;
}

- (bool)kOpenBackout{
    return [objc_getAssociatedObject(self,@selector(kOpenBackout)) boolValue];
}
- (void)setKOpenBackout:(bool)kOpenBackout{
    objc_setAssociatedObject(self,@selector(kOpenBackout),[NSNumber numberWithBool:kOpenBackout],OBJC_ASSOCIATION_ASSIGN);
    [self config];
}
- (NSMutableArray*)textTemps{
    NSMutableArray *temps = objc_getAssociatedObject(self, @selector(textTemps));
    if (temps == nil) {
        temps = [NSMutableArray array];
        objc_setAssociatedObject(self, @selector(textTemps), temps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return temps;
}
- (void)config{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")), class_getInstanceMethod(self.class, @selector(kj_backout_dealloc)));
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kj_backoutTextViewNotification:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kj_backoutTextViewNotification:) name:UITextViewTextDidChangeNotification object:self];
}
- (void)kj_backout_dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [self.textTemps removeAllObjects];
    [self kj_backout_dealloc];
}
/// 加入数组
- (void)kj_backoutTextViewChangeText:(NSString *)text{
    if (text) {
        if ([self.textTemps.lastObject isEqualToString:text]) return;
        [self.textTemps addObject:text];
    }
}

#pragma mark - NSNotification
- (void)kj_backoutTextViewNotification:(NSNotification*)notification{
    if ([notification.name isEqualToString:UITextViewTextDidBeginEditingNotification]) {
        if (self.textTemps.count == 0) [self kj_backoutTextViewChangeText:self.text];
    }else if ([notification.name isEqualToString:UITextViewTextDidChangeNotification]) {
        if ([self.textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextPosition *position = [self positionFromPosition:self.markedTextRange.start offset:0];
            if (position == nil) [self kj_backoutTextViewChangeText:self.text];
        }else {
            [self kj_backoutTextViewChangeText:self.text];
        }
    }
}

@end
