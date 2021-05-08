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

@end

NS_ASSUME_NONNULL_END
