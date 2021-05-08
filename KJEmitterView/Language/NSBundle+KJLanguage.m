//
//  NSBundle+KJLanguage.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/2.
//  https://github.com/yangKJ/KJEmitterView

#import "NSBundle+KJLanguage.h"
#import "KJLanguageManager.h"

@implementation NSBundle (KJLanguage)
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 动态继承修改[NSBundle mainBundle]对象的isa指针使其指向子类(KJLanguageManager)，便可以调用子类的方法
//        object_setClass([NSBundle mainBundle], [KJLanguageManager class]);
//    });
//}
+ (NSString*)customStringsName{
    return objc_getAssociatedObject(self, @selector(customStringsName));
}
+ (void)setCustomStringsName:(NSString*)customStringsName{
    objc_setAssociatedObject(self, @selector(customStringsName), customStringsName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    KJLanguageManager.customStringsName = customStringsName;
}
+ (NSString*)currentLanguage{
    return KJLanguageManager.currentLanguage;
}
/// 开启动态继承，必须在使用到多语言之前开启
+ (void)kj_openDynamicInherit{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [KJLanguageManager class]);
    });
}
/// 设置语言
+ (void)kj_setCurrentLanguage:(NSString*)language complete:(void(^)(void))complete{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (language) {
        [userDefaults setObject:language forKey:kAppLanguageKey];
    }else{
        [userDefaults removeObjectForKey:kAppLanguageKey];
    }
    [userDefaults synchronize];
    if (complete) complete();
}
/// 切换动画，自带菊花加载界面
+ (void)kj_switchoverLanguage:(UIViewController*(^)(KJLoadLanguageViewController *loadvc))block complete:(void(^)(void))complete{
    if (block) {
        KJLoadLanguageViewController *__vc = [KJLoadLanguageViewController new];
        __vc.time = .5;
        UIViewController *vc = block(__vc);
        if (vc) {
            __vc.loadEnd = ^{
                [vc.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[UIButton class]]) {
                        UIButton *button = (UIButton*)obj;
                        button.LocalizedKey = button.LocalizedKey;
                        button.SelectedKey = button.SelectedKey;
                        button.DisabledKey = button.DisabledKey;
                        button.HighlightedKey = button.HighlightedKey;
                    }else if ([obj isKindOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel*)obj;
                        label.LocalizedKey = label.LocalizedKey;
                    }else if ([obj isKindOfClass:[UITextField class]]) {
                        UITextField *textField = (UITextField*)obj;
                        textField.LocalizedKey = textField.LocalizedKey;
                    }
                }];
                if (complete) complete();
            };
//            __vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [vc presentViewController:__vc animated:NO completion:nil];
        }
    }
}

@end


@implementation UIButton (KJLanguage)
- (NSString*)LocalizedKey{
    return objc_getAssociatedObject(self, @selector(LocalizedKey));;
}
- (void)setLocalizedKey:(NSString*)LocalizedKey{
    objc_setAssociatedObject(self, @selector(LocalizedKey), LocalizedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (LocalizedKey == nil) return;
    if (KJLanguageManager.customStringsName) {
        [self setTitle:NSLocalizedStringFromTable(LocalizedKey,KJLanguageManager.customStringsName,nil) forState:UIControlStateNormal];
    }else{
        [self setTitle:NSLocalizedString(LocalizedKey, nil) forState:UIControlStateNormal];
    }
}
- (NSString*)HighlightedKey{
    return objc_getAssociatedObject(self, @selector(HighlightedKey));;
}
- (void)setHighlightedKey:(NSString*)HighlightedKey{
    objc_setAssociatedObject(self, @selector(HighlightedKey), HighlightedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (HighlightedKey == nil) return;
    if (KJLanguageManager.customStringsName) {
        [self setTitle:NSLocalizedStringFromTable(HighlightedKey,KJLanguageManager.customStringsName,nil) forState:UIControlStateHighlighted];
    }else{
        [self setTitle:NSLocalizedString(HighlightedKey, nil) forState:UIControlStateHighlighted];
    }
}
- (NSString*)SelectedKey{
    return objc_getAssociatedObject(self, @selector(SelectedKey));;
}
- (void)setSelectedKey:(NSString*)SelectedKey{
    objc_setAssociatedObject(self, @selector(SelectedKey), SelectedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (SelectedKey == nil) return;
    if (KJLanguageManager.customStringsName) {
        [self setTitle:NSLocalizedStringFromTable(SelectedKey,KJLanguageManager.customStringsName,nil) forState:UIControlStateSelected];
    }else{
        [self setTitle:NSLocalizedString(SelectedKey, nil) forState:UIControlStateSelected];
    }
}
- (NSString*)DisabledKey{
    return objc_getAssociatedObject(self, @selector(DisabledKey));;
}
- (void)setDisabledKey:(NSString*)DisabledKey{
    objc_setAssociatedObject(self, @selector(DisabledKey), DisabledKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (DisabledKey == nil) return;
    if (KJLanguageManager.customStringsName) {
        [self setTitle:NSLocalizedStringFromTable(DisabledKey,KJLanguageManager.customStringsName,nil) forState:UIControlStateDisabled];
    }else{
        [self setTitle:NSLocalizedString(DisabledKey, nil) forState:UIControlStateDisabled];
    }
}

@end


@implementation UILabel (KJLanguage)
- (NSString*)LocalizedKey{
    return objc_getAssociatedObject(self, @selector(LocalizedKey));;
}
- (void)setLocalizedKey:(NSString*)LocalizedKey{
    objc_setAssociatedObject(self, @selector(LocalizedKey), LocalizedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (LocalizedKey == nil) return;
    if (KJLanguageManager.customStringsName) {
        self.text = NSLocalizedStringFromTable(LocalizedKey,KJLanguageManager.customStringsName,nil);
    }else{
        self.text = NSLocalizedString(LocalizedKey, nil);
    }
}

@end

@implementation UITextField (KJLanguage)
- (NSString*)LocalizedKey{
    return objc_getAssociatedObject(self, @selector(LocalizedKey));;
}
- (void)setLocalizedKey:(NSString*)LocalizedKey{
    objc_setAssociatedObject(self, @selector(LocalizedKey), LocalizedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (LocalizedKey == nil) return;
    if (KJLanguageManager.customStringsName) {
        self.placeholder = NSLocalizedStringFromTable(LocalizedKey,KJLanguageManager.customStringsName,nil);
    }else{
        self.placeholder = NSLocalizedString(LocalizedKey, nil);
    }
}

@end
