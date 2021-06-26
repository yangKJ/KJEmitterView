//
//  NSString+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/4.
//  https://github.com/yangKJ/KJEmitterView
//  字符串扩展属性

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 密码强度等级
typedef NS_ENUM(NSUInteger, KJPasswordLevel) {
    KJPasswordLevelEasy = 0,//简单
    KJPasswordLevelMidium,//中等
    KJPasswordLevelStrong,//强
    KJPasswordLevelVeryStrong,//非常强
    KJPasswordLevelExtremelyStrong,//超级强
};
@interface NSString (KJExtension)
/// 是否为空
@property(nonatomic,assign,readonly)BOOL isEmpty;
/// 非空安全处理
@property(nonatomic,assign,readonly)NSString *safeString;
/// 转换为URL
@property(nonatomic,strong,readonly)NSURL *URL;
/// 获取图片
@property(nonatomic,strong,readonly)UIImage *image;
/// 取出HTML
@property(nonatomic,strong,readonly)NSString *HTMLString;
/// 生成竖直文字
@property(nonatomic,strong,readonly)NSString *verticalText;
/// Josn字符串转字典
@property(nonatomic,strong,readonly)NSDictionary *jsonDict;
/// 字典转Json字符串
extern NSString * kDictionaryToJson(NSDictionary *dict);
/// 数组转Json字符串
extern NSString * kArrayToJson(NSArray *array);
/// Json字符串转字典
extern NSDictionary * kJsonToDictionary(NSString *string);

#pragma mark - 汉字相关处理
/// 汉字转拼音
@property(nonatomic,strong,readonly)NSString *pinYin;
/// 随机汉字
extern NSString * kRandomChinese(NSInteger count);
/// 字母排序
extern NSArray<NSString*> * kDoraemonBoxAlphabetSort(NSArray<NSString*>* array);
/// 查找数据，返回-1表示未查询到
- (int)kj_searchArray:(NSArray<NSString*>*)temps;

#pragma mark - 谓词相关
/// 过滤空格
- (NSString *)kj_filterSpace;
/// 验证数字
- (BOOL)kj_validateNumber;
/// 验证字符串中是否有特殊字符
- (BOOL)kj_validateHaveSpecialCharacter;
/// 过滤特殊字符
- (NSString *)kj_removeSpecialCharacter:(NSString * _Nullable)character;
/// 验证手机号码
- (BOOL)kj_validateMobileNumber;
/// 验证邮箱格式
- (BOOL)kj_validateEmail;
/// 验证身份证
- (BOOL)kj_validateIDCardNumber;
/// 验证银行卡
- (BOOL)kj_validateBankCardNumber;
/// 判断字符串是 空格、空("")、null
- (BOOL)kj_isNull;
/// 判断字符串中的每个字符是否相等
- (BOOL)kj_isCharEqual;
/// 确定字符串是否为数字
- (BOOL)kj_isNumeric;
/// 密码强度等级
- (KJPasswordLevel)kj_passwordLevel;

#pragma mark - 文本相关
/// 获取文本宽度
- (CGFloat)kj_maxWidthWithFont:(UIFont *)font
                        Height:(CGFloat)height
                     Alignment:(NSTextAlignment)alignment
                 LinebreakMode:(NSLineBreakMode)linebreakMode
                     LineSpace:(CGFloat)lineSpace;
/// 获取文本高度
- (CGFloat)kj_maxHeightWithFont:(UIFont *)font
                          Width:(CGFloat)width
                      Alignment:(NSTextAlignment)alignment
                  LinebreakMode:(NSLineBreakMode)linebreakMode
                      LineSpace:(CGFloat)lineSpace;
/// 计算字符串高度尺寸，spacing为行间距
- (CGSize)kj_textSizeWithFont:(UIFont *)font
                    superSize:(CGSize)size
                      spacing:(CGFloat)spacing;
/// 文字转图片
- (UIImage *)kj_textBecomeImageWithSize:(CGSize)size
                        BackgroundColor:(UIColor *)color
                         TextAttributes:(NSDictionary *)attributes;

/// 复制数据至剪切板
- (void)kj_pasteboard;

#pragma mark - 数学运算
/// 比较大小
- (NSComparisonResult)kj_compare:(NSString *)string;
/// 加法运算
- (NSString *)kj_adding:(NSString *)string;
/// 减法运算
- (NSString *)kj_subtract:(NSString *)string;
/// 乘法运算量
- (NSString *)kj_multiply:(NSString *)string;
/// 除法运算
- (NSString *)kj_divide:(NSString *)string;
/// 指数运算
- (NSString *)kj_multiplyingByPowerOf10:(NSInteger)oxff;
/// 次方运算
- (NSString *)kj_raisingToPower:(NSInteger)oxff;
/// 转成小数
- (double)kj_calculateDoubleValue;
/// 保留整数部分，100.0130 -- > 100
- (NSString *)kj_retainInteger;
/// 去掉尾巴是0或者.的位数，10.000 -- > 10 或者 10.100 -- > 10.1
- (NSString *)kj_removeTailZero;

/// 保留几位小数，四舍五入保留两位则，10.00001245 -- > 10.00  或者 120.026 -- > 120.03
extern NSString * kStringFractionDigits(NSDecimalNumber * number, NSUInteger digits);
+ (NSString *)kj_fractionDigits:(double)value digits:(NSUInteger)digits;

/// 保留小数，直接去掉小数多余部分
+ (NSString *)kj_retainDigits:(double)value digits:(int)digits;

/// 保留几位有效小数位数，保留两位则，10.00001245 -- > 10.000012  或者 120.02 -- > 120.02 或者 10.000 -- > 10
extern NSString * kStringReservedValidDigit(NSDecimalNumber * value, NSInteger digit);
+ (NSString *)kj_reservedValidDigit:(double)value digit:(int)digit;

/// Double精度丢失修复
- (NSString *)kj_doublePrecisionRevise;
+ (NSString *)kj_doublePrecisionReviseWithDouble:(double)conversionValue;

@end

NS_ASSUME_NONNULL_END
