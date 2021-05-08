//
//  NSDictionary+KJExtension.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/6.
//  https://github.com/yangKJ/KJEmitterView

#import "NSDictionary+KJExtension.h"

@implementation NSDictionary (KJExtension)
- (BOOL)isEmpty{
    return (self == nil || [self isKindOfClass:[NSNull class]] || self.allKeys == 0);
}
- (NSString*)jsonString{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
}
/// 是否包含某个key，内部哈西算法实现
- (BOOL)kj_containsKey:(NSString*)key{
    if (!key) return NO;
    return self[key] != nil;
}
/// 字典键名数组
- (NSArray<NSString*>*)kj_keysSorted{
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end
