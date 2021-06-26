//
//  NSBundle+KJLanguage.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/2.
//  https://github.com/yangKJ/KJEmitterView

#import <Foundation/Foundation.h>
#import "KJLoadLanguageViewController.h"

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface NSBundle (KJLanguage)
/// 自定义strings文件，默认Localizable.strings
@property(nonatomic,strong,class)NSString *customStringsName;
/// 当前语言
@property(nonatomic,strong,readonly,class)NSString *currentLanguage;
/// 开启动态继承，必须在使用到多语言之前开启
+ (void)kj_openDynamicInherit;
/// 设置语言，传nil恢复系统默认语言
+ (void)kj_setCurrentLanguage:(NSString * _Nullable)language complete:(void(^_Nullable)(void))complete;
/// 切换动画，备注Xib设置的多语言会自动切换
+ (void)kj_switchoverLanguage:(UIViewController * (^_Nullable)(KJLoadLanguageViewController *loadvc))block
                     complete:(void(^_Nullable)(void))complete;

@end


@interface UIButton (KJLanguage)

@property(nonatomic,strong)IBInspectable NSString *LocalizedKey;
@property(nonatomic,strong)IBInspectable NSString *SelectedKey;
@property(nonatomic,strong)NSString *DisabledKey;
@property(nonatomic,strong)NSString *HighlightedKey;

@end


@interface UILabel (KJLanguage)

@property(nonatomic,strong)IBInspectable NSString *LocalizedKey;

@end


@interface UITextField (KJLanguage)

@property(nonatomic,strong)IBInspectable NSString *LocalizedKey;

@end

NS_ASSUME_NONNULL_END
