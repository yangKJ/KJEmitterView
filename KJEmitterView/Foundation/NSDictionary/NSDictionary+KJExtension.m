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
- (NSString *)jsonString{
    NSError *error;
#ifdef DEBUG
    NSJSONWritingOptions options = NSJSONWritingPrettyPrinted;
#else
    NSJSONWritingOptions options = 0;
#endif
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:options error:&error];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
}
/// 是否包含某个key，内部哈西算法实现
- (BOOL)kj_containsKey:(NSString *)key{
    if (!key) return NO;
    return self[key] != nil;
}
/// 字典键名数组
- (NSArray<NSString*> *)kj_keysSorted{
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}
- (NSDictionary *)kj_keySortOptions:(NSSortOptions)options{
    return self;
}

#pragma mark - NSDictionary
- (unsigned long long)unsignedLongLongForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [number unsignedLongLongValue];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [number longLongValue];
    return UINT64_MAX;
}

- (unsigned long)unsignedLongForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [number unsignedLongValue];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [number intValue];
    return UINT32_MAX;
}

- (unsigned int)unsignedIntForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [number unsignedIntValue];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [number intValue];
    return UINT32_MAX;
}

- (unsigned short)unsignedShortForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [number unsignedShortValue];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [number intValue];
    return UINT16_MAX;
}

- (int)intForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [number intValue];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [number intValue];
    return INT32_MAX;
}

- (BOOL)boolForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [number boolValue];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [number boolValue];
    return NO;
}

- (unsigned char)unsignedCharForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [number unsignedCharValue];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [number intValue];
    return UINT8_MAX;
}

- (char)charForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [number charValue];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [number intValue];
    return INT8_MAX;
}

- (float)floatForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [number floatValue];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [number floatValue];
    return 0.0f;
}

- (NSDate *)dateForKey:(NSString *)key{
    NSNumber * number = [self objectForKey:key];
    if (number != nil && [number isKindOfClass:[NSNumber class]])
        return [NSDate dateWithTimeIntervalSince1970:[number unsignedIntValue]];
    if (number != nil && [number isKindOfClass:[NSString class]])
        return [NSDate dateWithTimeIntervalSince1970:[number integerValue]];
    return nil;
}

- (NSArray *)arrayForKey:(NSString *)key{
    id object = [self objectForKey:key];
    if (object != nil && [object isKindOfClass:[NSArray class]])
        return object;
    if (object != nil && [object isKindOfClass:[NSString class]]) {
        NSData *JSONData = [object dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
        if (error == nil || [json isKindOfClass:[NSArray class]]) {
            return json;
        }
    }
    return nil;
}

#pragma mark - NSMutableDictionary
- (void)setUnsignedLongLong:(unsigned long long)value forKey:(id)aKey{
    NSNumber * number = [NSNumber numberWithUnsignedLongLong:value];
    [self setValue:number forKey:aKey];
}

- (void)setUnsignedLong:(unsigned long)value forKey:(id)aKey{
    NSNumber * number = [NSNumber numberWithUnsignedLong:value];
    [self setValue:number forKey:aKey];
}

- (void)setUnsignedInt:(unsigned int)value forKey:(id)aKey{
    NSNumber * number = [NSNumber numberWithUnsignedInt:value];
    [self setValue:number forKey:aKey];
}

- (void)setInt:(int)value forKey:(id)aKey{
    NSNumber * number = [NSNumber numberWithInt:value];
    [self setValue:number forKey:aKey];
}

- (void)setBool:(BOOL)value forKey:(id)aKey{
    NSNumber * number = [NSNumber numberWithBool:value];
    [self setValue:number forKey:aKey];
}

- (void)setUnsignedShort:(unsigned short)value forKey:(id)aKey{
    NSNumber * number = [NSNumber numberWithUnsignedShort:value];
    [self setValue:number forKey:aKey];
}

- (void)setDateWithTimeIntervalSince1970:(unsigned long)value forKey:(id)aKey{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:value];
    [self setValue:date forKey:aKey];
}

- (void)setUnsignedChar:(unsigned char)value forKey:(id)aKey{
    NSNumber * number = [NSNumber numberWithUnsignedChar:value];
    [self setValue:number forKey:aKey];
}

- (void)setChar:(char)value forKey:(id)aKey{
    NSNumber * number = [NSNumber numberWithChar:value];
    [self setValue:number forKey:aKey];
}

- (void)setFloat:(float)value forKey:(id)aKey{
    NSNumber * number = [NSNumber numberWithFloat:value];
    [self setValue:number forKey:aKey];
}

- (void)setNSStringWithUTF8String:(const char*)value forKey:(id)aKey{
    NSString * string = [NSString stringWithUTF8String:value];
    if (string) [self setValue:string forKey:aKey];
}

- (void)setDate:(NSDate*)value forKey:(id)aKey{
    NSTimeInterval time = [value timeIntervalSince1970];
    NSNumber * number = [NSNumber numberWithDouble:time];
    [self setValue:number forKey:aKey];
}

@end
