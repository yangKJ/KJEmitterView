//
//  NSArray+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/6.
//  https://github.com/yangKJ/KJEmitterView
//  对数组里面元素的相关处理
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// bindings参数:替换变量字典，字典必须包含接收器中所有变量的键值对
typedef BOOL (^kPredicateBlock)(id evaluatedObject, NSDictionary<NSString*,id> *bindings);
@interface NSArray (KJExtension)
/// 是否为空
@property(nonatomic,assign,readonly)BOOL isEmpty;
/// 筛选数据
- (id)kj_detectArray:(BOOL(^)(id object, int index))block;
/// 多维数组筛选数据
- (id)kj_detectManyDimensionArray:(BOOL(^)(id object, BOOL * stop))recurse;
/// 查找数据，返回-1表示未查询到
- (int)kj_searchObject:(id)object;
/// 映射，取出某种数据
- (NSArray*)kj_mapArray:(id(^)(id object))block;
/// 包含数据
- (BOOL)kj_containsObject:(BOOL(^)(id object, NSUInteger index))block;
/// 替换数组指定元素，stop控制是否替换全部
- (NSArray*)kj_replaceObject:(id)object operation:(BOOL(^)(id object, NSUInteger index, BOOL * stop))operation;
/// 插入数据到目的位置
- (NSArray*)kj_insertObject:(id)object aim:(BOOL(^)(id object, int index))block;
/// 数组计算交集
- (NSArray*)kj_arrayIntersectionWithOtherArray:(NSArray*)otherArray;
/// 数组计算差集
- (NSArray*)kj_arrayMinusWithOtherArray:(NSArray*)otherArray;
/// 随机打乱数组
- (NSArray*)kj_disorganizeArray;
/// 删除数组当中的相同元素
- (NSArray*)kj_delArrayEquelObj;
/// 生成一组不重复的随机数
- (NSArray*)kj_noRepeatRandomArrayWithMinNum:(NSInteger)min maxNum:(NSInteger)max count:(NSInteger)count;
/// 二分查找，当数据量很大适宜采用该方法
- (NSInteger)kj_binarySearchTarget:(NSInteger)target;
/// 冒泡排序
- (NSArray*)kj_bubbleSort;
/// 插入排序
- (NSArray*)kj_insertSort;
/// 选择排序
- (NSArray*)kj_selectionSort;

#pragma mark - 谓词工具
/// 对比两个数组删除相同元素并合并
- (NSArray*)kj_mergeArrayAndDelEqualObjWithOtherArray:(NSArray*)temp;
/// 过滤数组
- (NSArray*)kj_filtrationDatasWithPredicateBlock:(kPredicateBlock)block;
/// 除去数组当中包含目标数组的数据
- (NSArray*)kj_delEqualDatasWithTargetTemps:(NSArray*)temp;
/// 按照某一属性的升序降序排列
- (NSArray*)kj_sortDescriptorWithKey:(NSString*)key Ascending:(BOOL)ascending;
/// 按照某些属性的升序降序排列
- (NSArray*)kj_sortDescriptorWithKeys:(NSArray*)keys Ascendings:(NSArray*)ascendings;
/// 匹配元素
- (NSArray*)kj_takeOutDatasWithKey:(NSString*)key Value:(NSString*)value;
/// 字符串比较运算符
- (NSArray*)kj_takeOutDatasWithOperator:(NSString*)ope Key:(NSString*)key Value:(NSString*)value;


@end

NS_ASSUME_NONNULL_END
