//
//  NSDictionary+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/6.
//  https://github.com/yangKJ/KJEmitterView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (KJExtension)
/// 是否为空
@property(nonatomic,assign,readonly)BOOL isEmpty;
/// 转换为Josn字符串
@property(nonatomic,strong,readonly)NSString *jsonString;
/// 是否包含某个key，内部哈西算法实现
- (BOOL)kj_containsKey:(NSString*)key;
/// 字典键名数组，升序排列
- (NSArray<NSString*>*)kj_keysSorted;
/// 字典按键名排序，TODO
- (NSDictionary*)kj_keySortOptions:(NSSortOptions)options;

#pragma mark - NSDictionary
- (unsigned long long)unsignedLongLongForKey:(NSString*)key;
- (unsigned long)unsignedLongForKey:(NSString*)key;
- (unsigned int)unsignedIntForKey:(NSString*)key;
- (unsigned short)unsignedShortForKey:(NSString*)key;
- (int)intForKey:(NSString*)key;
- (BOOL)boolForKey:(NSString*)key;
- (unsigned char)unsignedCharForKey:(NSString*)key;
- (char)charForKey:(NSString*)key;
- (float)floatForKey:(NSString*)key;
- (NSDate*)dateForKey:(NSString*)key;
- (NSArray*)arrayForKey:(NSString*)key;

#pragma mark - NSMutableDictionary
- (void)setUnsignedLongLong:(unsigned long long)value forKey:(id)aKey;
- (void)setUnsignedLong:(unsigned long)value forKey:(id)aKey;
- (void)setUnsignedInt:(unsigned int)value forKey:(id)aKey;
- (void)setInt:(int)value forKey:(id)aKey;
- (void)setBool:(BOOL)value forKey:(id)aKey;
- (void)setUnsignedShort:(unsigned short)value forKey:(id)aKey;
- (void)setDateWithTimeIntervalSince1970:(unsigned long)value forKey:(id)aKey;
- (void)setUnsignedChar:(unsigned char)value forKey:(id)aKey;
- (void)setChar:(char)value forKey:(id)aKey;
- (void)setFloat:(float)value forKey:(id)aKey;
- (void)setNSStringWithUTF8String:(const char*)value forKey:(id)aKey;
- (void)setDate:(NSDate*)value forKey:(id)aKey;

@end

NS_ASSUME_NONNULL_END
