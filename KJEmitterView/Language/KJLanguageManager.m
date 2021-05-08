//
//  KJLanguageManager.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/21.
//  https://github.com/yangKJ/KJEmitterView

#import "KJLanguageManager.h"

@implementation KJLanguageManager
@dynamic currentLanguage;
+ (NSString*)currentLanguage{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:kAppLanguageKey];
    if (language == nil) {
        language = [[NSLocale preferredLanguages] firstObject];
    }
    return language;
}
static NSString *_customStringsName = nil;
+ (NSString*)customStringsName{
    return _customStringsName;
}
+ (void)setCustomStringsName:(NSString*)customStringsName{
    _customStringsName = customStringsName;
}
/// 国际化
- (NSString*)localizedStringForKey:(NSString*)key value:(NSString*)value table:(NSString*)tableName{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:KJLanguageManager.currentLanguage ofType:@"lproj"]];
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    }else{
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end
