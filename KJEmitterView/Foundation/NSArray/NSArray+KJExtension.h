//
//  NSArray+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/6.
//  https://github.com/yangKJ/KJEmitterView
//  对数组里面元素的相关处理
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (KJExtension)
/// 是否为空
@property(nonatomic,assign,readonly)BOOL isEmpty;
/// 倒序排列
- (NSArray *)kj_reverseArray;
/// 筛选数据
- (id)kj_detectArray:(BOOL(^)(id object, int index))block;
/// 多维数组筛选数据
- (id)kj_detectManyDimensionArray:(BOOL(^)(id object, BOOL * stop))recurse;
/// 归纳对比选择，最终返回经过对比之后的数据
- (id)kj_reduceObject:(id)object comparison:(id(^)(id obj1, id obj2))comparison;
/// 查找数据，返回-1表示未查询到
- (NSInteger)kj_searchObject:(id)object;
/// 映射，取出某种数据
- (NSArray *)kj_mapArray:(id(^)(id object))map;
/// 映射，是否倒序
- (NSArray *)kj_mapArray:(id(^)(id object))map reverse:(BOOL)reverse;
/// 包含数据
- (BOOL)kj_containsObject:(BOOL(^)(id object, NSUInteger index))contains;
/// 指定位置之后是否包含数据
- (BOOL)kj_containsFromIndex:(NSInteger * _Nonnull)index contains:(BOOL(^)(id object))contains;
/// 替换数组指定元素，stop控制是否替换全部
- (NSArray *)kj_replaceObject:(id)object operation:(BOOL(^)(id object, NSUInteger index, BOOL * stop))operation;
/// 插入数据到目的位置
- (NSArray *)kj_insertObject:(id)object aim:(BOOL(^)(id object, int index))aim;
/// 判断两个数组包含元素是否一致
- (BOOL)kj_isEqualOtherArray:(NSArray *)otherArray;
/// 随机打乱数组
- (NSArray *)kj_disorganizeArray;
/// 删除数组当中的相同元素
- (NSArray *)kj_deleteArrayEquelObject;
/// 生成一组不重复的随机数
- (NSArray *)kj_noRepeatRandomArrayWithMinNum:(NSInteger)min maxNum:(NSInteger)max count:(NSInteger)count;
/// 二分查找，当数据量很大适宜采用该方法
- (NSInteger)kj_binarySearchTarget:(NSInteger)target;
/// 冒泡排序
- (NSArray *)kj_bubbleSort;
/// 插入排序
- (NSArray *)kj_insertSort;
/// 选择排序
- (NSArray *)kj_selectionSort;

#pragma mark - 谓词工具
/// 数组计算交集
- (NSArray *)kj_intersectionWithOtherArray:(NSArray *)otherArray;
/// 数组计算差集
- (NSArray *)kj_subtractionWithOtherArray:(NSArray *)otherArray;
/// 删除数组相同部分然后追加不同部分
- (NSArray *)kj_deleteEqualObjectAndMergeWithOtherArray:(NSArray *)otherArray;
/// 过滤数组，排除不需要部分
- (NSArray *)kj_filterArrayExclude:(BOOL(^)(id object))block;
/// 过滤数组，获取需要部分
- (NSArray *)kj_filterArrayNeed:(BOOL(^)(id object))block;
/// 除去目标元素
- (NSArray *)kj_deleteTargetArray:(NSArray *)temp;
/// 按照某一属性的升序降序排列
- (NSArray *)kj_sortDescriptorWithKey:(NSString *)key Ascending:(BOOL)ascending;
/// 按照某些属性的升序降序排列
- (NSArray *)kj_sortDescriptorWithKeys:(NSArray *)keys Ascendings:(NSArray *)ascendings;
/// 匹配元素
- (NSArray *)kj_takeOutDatasWithKey:(NSString *)key Value:(NSString *)value;
/// 字符串比较运算符
- (NSArray *)kj_takeOutDatasWithOperator:(NSString *)ope Key:(NSString *)key Value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
