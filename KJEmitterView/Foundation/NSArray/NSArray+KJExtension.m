//
//  NSArray+KJExtension.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/6.
//  https://github.com/yangKJ/KJEmitterView

#import "NSArray+KJExtension.h"

@implementation NSArray (KJExtension)
- (BOOL)isEmpty{
    return (self == nil || [self isKindOfClass:[NSNull class]] || self.count == 0);
}
//MARK: - 筛选数据
- (id)kj_detectArray:(BOOL(^)(id object, int index))block{
    for (int i = 0; i < self.count; i++) {
        id object = self[i];
        if (block(object,i)) return object;
    }
    return nil;
}
//MARK: - 多维数组筛选数据
- (id)kj_detectManyDimensionArray:(BOOL(^)(id object, BOOL * stop))recurse{
    for (id object in self) {
        BOOL stop = NO;
        if ([object isKindOfClass:[NSArray class]]) {
            return [(NSArray*)object kj_detectManyDimensionArray:recurse];
        }
        if (recurse(object, &stop)) {
            return object;
        }else if (stop) {
            return object;
        }
    }
    return nil;
}
// 查找数据，返回-1表示未查询到
- (int)kj_searchObject:(id)object{
    __block int idx = -1;
    [self kj_detectArray:^BOOL(id _Nonnull obj, int index) {
        if (obj == object) {
            idx = index;
            return YES;
        }
        return NO;
    }];
    return idx;
}
//MARK: - 映射
- (NSArray*)kj_mapArray:(id(^)(id object))block{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        [array addObject:block(object) ?: [NSNull null]];
    }
    return array.mutableCopy;
}
//MARK: - 包含数据
- (BOOL)kj_containsObject:(BOOL(^)(id object, NSUInteger index))block{
    @autoreleasepool {
        __block BOOL contains = NO;
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (block(obj, idx)) {
                contains = YES;
                *stop = YES;
            }
        }];
        return contains;
    }
}
/// 替换数组指定元素
- (NSArray*)kj_replaceObject:(id)object operation:(BOOL(^)(id object, NSUInteger index, BOOL * stop))operation{
    @autoreleasepool {
        NSMutableArray *temps = [NSMutableArray arrayWithArray:self];
        [temps enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL end = NO;
            if (operation(obj, idx, &end)) {
                [temps replaceObjectAtIndex:idx withObject:object];
            }else if (end) {
                *stop = YES;
            }
        }];
        return temps.mutableCopy;
    }
}
/// 插入数据到目的位置
- (NSArray*)kj_insertObject:(id)object aim:(BOOL(^)(id object, int index))block{
    @autoreleasepool {
        NSMutableArray *temps = [NSMutableArray array];
        BOOL stop = NO;
        for (int i = 0; i < self.count; i++) {
            id obj = self[i];
            [temps addObject:obj];
            if (block(obj, i)) {
                stop = YES;
                [temps addObject:object];
            }
        }
        if (stop == NO) [temps addObject:object];
        return temps.mutableCopy;
    }
}
/// 数组计算交集
- (NSArray*)kj_arrayIntersectionWithOtherArray:(NSArray*)otherArray{
    if (self.count == 0 || otherArray == nil) return nil;
    NSMutableArray *temps = [NSMutableArray array];
    for (id obj in self) {
        if (![otherArray containsObject:obj]) continue;
        [temps addObject:obj];
    }
    return temps.mutableCopy;
}
/// 数组计算差集
- (NSArray*)kj_arrayMinusWithOtherArray:(NSArray*)otherArray{
    if (self == nil) return nil;
    if (otherArray == nil) return self;
    NSMutableArray *temps = [NSMutableArray arrayWithArray:self];
    for (id obj in otherArray) {
        if (![self containsObject:obj]) continue;
        [temps removeObject:obj];
    }
    return temps.mutableCopy;
}
/// 随机打乱数组
- (NSArray*)kj_disorganizeArray{
    return [self sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return arc4random_uniform(2) ? [obj1 compare:obj2] : [obj2 compare:obj1];
    }];
}
// 删除数组当中的相同元素
- (NSArray*)kj_delArrayEquelObj{
    return [self valueForKeyPath:@"@distinctUnionOfObjects.self"];
}
/// 生成一组不重复的随机数
- (NSArray*)kj_noRepeatRandomArrayWithMinNum:(NSInteger)min maxNum:(NSInteger)max count:(NSInteger)count{
    NSMutableSet *set = [NSMutableSet setWithCapacity:count];
    while (set.count < count) {
        NSInteger value = arc4random() % (max-min+1) + min;
        [set addObject:[NSNumber numberWithInteger:value]];
    }
    return set.allObjects;
}
//MARK: - ---  二分查找
/* 当数据量很大适宜采用该方法 采用二分法查找时，数据需是排好序的
 基本思想：假设数据是按升序排序的，对于给定值x，从序列的中间位置开始比较，如果当前位置值等于x，则查找成功
 若x小于当前位置值，则在数列的前半段 中查找；若x大于当前位置值则在数列的后半段中继续查找，直到找到为止
 */
- (NSInteger)kj_binarySearchTarget:(NSInteger)target{
    if (self == nil) return -1;
    NSInteger start = 0;
    NSInteger end = self.count - 1;
    NSInteger mind = 0;
    while (start < end - 1){
        mind = start + (end - start)/2;
        if ([self[mind] integerValue] > target){
            end = mind;
        }else{
            start = mind;
        }
    }
    if ([self[start] integerValue] == target){
        return start;
    }
    if ([self[end] integerValue] == target){
        return end;
    }
    return -1;
}
//MARK: - --- 冒泡排序
/*
 1. 首先将所有待排序的数字放入工作列表中
 2. 从列表的第一个数字到倒数第二个数字，逐个检查：若某一位上的数字大于他的下一位，则将它与它的下一位交换
 3. 重复2号步骤(倒数的数字加1。例如：第一次到倒数第二个数字，第二次到倒数第三个数字，依此类推...)，直至再也不能交换
 */
- (NSArray *)kj_bubbleSort{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    NSInteger count = [array count];
    for (int i = 0; i < count - 1; ++i){
        for (int j = 0; j < count - i - 1; ++j){
            if (array[j] > array[j+1]){
                id temp = array[j];
                array[j] = array[j+1];
                array[j+1] = temp;
            }
        }
    }
    return array.mutableCopy;
}

//MARK: - --- 插入排序
/*
 1. 从第一个元素开始，认为该元素已经是排好序的
 2. 取下一个元素，在已经排好序的元素序列中从后向前扫描
 3. 如果已经排好序的序列中元素大于新元素，则将该元素往右移动一个位置
 4. 重复步骤3，直到已排好序的元素小于或等于新元素
 5. 在当前位置插入新元素
 6. 重复步骤2
 */
- (NSArray *)kj_insertSort{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    int j;
    for (int i = 1; i < [array count]; ++i){
        id temp = array[i];
        for (j = i; j > 0 && temp < array[j-1]; --j){
            array[j] = array[j-1];
        }
        array[j] = temp;
    }
    return array.mutableCopy;
}

//MARK: - ---  选择排序
/*
 1. 设数组内存放了n个待排数字，数组下标从1开始，到n结束
 2. i=1
 3. 从数组的第i个元素开始到第n个元素，逐一比较寻找最小的元素
 4. 将上一步找到的最小元素和第i位元素交换
 5. 如果i=n－1算法结束，否则回到第3步
 */
- (NSArray *)kj_selectionSort{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    NSInteger count = [array count];
    for (int i = 0; i < count; ++i){
        int min = i;
        for (int j = i+1; j < count; ++j){
            if (array[min] > array[j]) min = j;
        }
        if (min != i){
            id temp = array[min];
            array[min] = array[i];
            array[i] = temp;
        }
    }
    return array.mutableCopy;
}

#pragma mark - 谓词工具
//MARK: - 对比两个数组删除相同元素并合并
- (NSArray*)kj_mergeArrayAndDelEqualObjWithOtherArray:(NSArray*)temp{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self];
    NSArray *filteredTemps = [temp filteredArrayUsingPredicate:predicate];
    NSMutableArray *newTemps = [NSMutableArray arrayWithArray:self];
    [newTemps addObjectsFromArray:filteredTemps];
    return newTemps;
}
//MARK: - NSPredicate 不影响原数组，返回数组即为过滤结果
- (NSArray*)kj_filtrationDatasWithPredicateBlock:(kPredicateBlock)block{
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:block]];
}
//MARK: - NSPredicate 除去数组temps中包含的数组targetTemps元素
- (NSArray*)kj_delEqualDatasWithTargetTemps:(NSArray*)temp{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", temp];
    return [self filteredArrayUsingPredicate:predicate].mutableCopy;
}
//MARK: - 利用 NSSortDescriptor 对对象数组，按照某一属性的升序降序排列
- (NSArray*)kj_sortDescriptorWithKey:(NSString*)key Ascending:(BOOL)ascending{
    NSSortDescriptor *des = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    [array sortUsingDescriptors:@[des]];
    return array;
}
//MARK: - 利用 NSSortDescriptor 对对象数组，按照某些属性的升序降序排列
- (NSArray*)kj_sortDescriptorWithKeys:(NSArray*)keys Ascendings:(NSArray*)ascendings{
    NSMutableArray *desTemp = [NSMutableArray array];
    for (int i=0; i<keys.count; i++) {
        NSString *key = keys[i];
        BOOL boo = [ascendings[i] integerValue] ? YES : NO;
        NSSortDescriptor *des = [NSSortDescriptor sortDescriptorWithKey:key ascending:boo];
        [desTemp addObject:des];
    }
    NSMutableArray *array = self.mutableCopy;
    [array sortUsingDescriptors:desTemp];
    desTemp = nil;
    return array;
}
//MARK: - 利用 NSSortDescriptor 对对象数组，取出 key 中匹配 value 的元素
- (NSArray*)kj_takeOutDatasWithKey:(NSString*)key Value:(NSString*)value{
    NSString *string = [NSString stringWithFormat:@"%@ LIKE '%@'",key,value];
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:string]];
}
//MARK: - 字符串比较运算符 beginswith(以*开头)、endswith(以*结尾)、contains(包含)、like(匹配)、matches(正则)
//  beginswith(以*开头)、endswith(以*结尾)、contains(包含)、like(匹配)、matches(正则)，[c]不区分大小写 [d]不区分发音符号即没有重音符号 [cd] 既又
- (NSArray*)kj_takeOutDatasWithOperator:(NSString*)ope Key:(NSString*)key Value:(NSString*)value{
    NSString *string = [NSString stringWithFormat:@"%@ %@ '%@'",key,ope,value];
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:string]];
}


//MARK: - ------------------------ Predicate谓词的简单使用 ------------------------
/*
 // self 表示数组元素/字符串本身
 // 比较运算符 =/==(等于)、>=/=>(大于等于)、<=/=<(小于等于)、>(大于)、<(小于)、!=/<>(不等于)
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"self = %@",[people_arr lastObject]];//比较数组元素相等
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"address = %@",[(People *)[people_arr lastObject] address]];//比较数组元素中某属性相等
 ////NSPredicate *pre = [NSPredicate predicateWithFormat:@"age in {18,21}"];//比较数组元素中某属性值在这些值中
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"age between {18,21}"];//比较数组元素中某属性值大于等于左边的值，小于等于右边的值
 
 // 逻辑运算符 and/&&(与)、or/||(或)、not/!(非)
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"address = %@ && age between {19,22}",[(People *)[people_arr lastObject] address]];
 
 // 字符串比较运算符 beginswith(以*开头)、endswith(以*结尾)、contains(包含)、like(匹配)、matches(正则)
 // [c]不区分大小写 [d]不区分发音符号即没有重音符号 [cd]既 又
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name beginswith[cd] 'ja'"];
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name matches '^[a-zA-Z]{4}$'"];
 
 //集合运算符 some/any:集合中任意一个元素满足条件、all:集合中所有元素都满足条件、none:集合中没有元素满足条件、in:集合中元素在另一个集合中
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"all employees.employeeId in {7,8,9}"];
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"self in %@",filter_arr];
 // $K：用于动态传入属性名、%@：用于动态设置属性值(字符串、数字、日期对象)、$(value)：可以动态改变
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K > $age",@"age"];
 //pre = [pre predicateWithSubstitutionVariables:@{@"age":@21}];
 // NSCompoundPredicate 相当于多个NSPredicate的组合
 //NSCompoundPredicate *compPre = [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"age > 19"],[NSPredicate predicateWithFormat:@"age < 21"]]];
 // 暂时没找到用法
 //NSComparisonPredicate *compPre = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"name"] rightExpression:[NSExpression expressionForVariable:@"ja"] modifier:NSAnyPredicateModifier type:NSBeginsWithPredicateOperatorType options:NSNormalizedPredicateOption];
 //[people_arr filterUsingPredicate:compPre];

 */


@end
