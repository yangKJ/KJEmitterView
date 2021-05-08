//
//  NSString+KJExtension.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/4.
//  https://github.com/yangKJ/KJEmitterView

#import "NSString+KJExtension.h"

@implementation NSString (KJExtension)
/// 是否为空
- (BOOL)isEmpty{
    if (self == nil || self == NULL || [self length] == 0 ||
        [self isKindOfClass:[NSNull class]] ||
        [self isEqualToString:@"(null)"] ||
        [self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
/// 转换为URL
- (NSURL*)URL{ return [NSURL URLWithString:self];}
/// 获取图片
- (UIImage*)image{ return [UIImage imageNamed:self];}
/// 取出HTML
- (NSString*)HTMLString{
    if (self == nil) return nil;
    NSString *html = self;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd] == NO){
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}
/// 生成竖直文字
- (NSString*)verticalText{
    NSMutableString *text = [[NSMutableString alloc] initWithString:self];
    NSInteger count = text.length;
    for (int i = 1; i < count; i ++) {
        [text insertString:@"\n" atIndex:i*2-1];
    }
    return text;
}
#pragma mark - Json相关
/// Josn字符串转字典
- (NSDictionary*)jsonDict{
    if (self == nil) return nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) return nil;
    return dic;
}
/// 字典转Json字符串
NSString * kDictionaryToJson(NSDictionary *dict){
    NSString *jsonString = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
/// 数组转Json字符串
NSString * kArrayToJson(NSArray *array){
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonTemp;
}
/// Json字符串转字典
NSDictionary *kJsonToDictionary(NSString *string){
    if (string == nil) return nil;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) return nil;
    return dic;
}

#pragma mark - 汉字相关处理
/// 汉字转拼音
- (NSString*)pinYin{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str,NULL,kCFStringTransformMandarinLatin,NO);//先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL,kCFStringTransformStripDiacritics,NO);//再转换为不带声调的拼音
    return str;
}
/// 随机汉字
NSString * kRandomChinese(NSInteger count){
    NSMutableString *randomChineseString = @"".mutableCopy;
    for (NSInteger i = 0; i < count; i++) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
        NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);
        NSInteger number = (randomH<<8)+randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        NSString *string = [[NSString alloc]initWithData:data encoding:gbkEncoding];
        [randomChineseString appendString:string];
    }
    return randomChineseString.mutableCopy;
}
/// 查找数据，返回-1表示未查询到
- (int)kj_searchArray:(NSArray<NSString*>*)temps{
    unsigned index = (unsigned)CFArrayBSearchValues((CFArrayRef)temps, CFRangeMake(0, temps.count), (CFStringRef)self, (CFComparatorFunction)CFStringCompare, NULL);
    if (index < temps.count && [self isEqualToString:temps[index]]){
        return index;
    }else{
        return -1;
    }
}
/// 字母排序
NSArray * kDoraemonBoxAlphabetSort(NSArray * array){
    return [array sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - 谓词相关
//MARK: - 过滤空格
- (NSString*)kj_filterSpace{
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}
//MARK: - 检测输入内容是否为数字
- (BOOL)kj_validateNumber{
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < self.length){
        NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0){
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
//MARK: - 检测字符串中是否有特殊字符
- (BOOL)kj_validateHaveSpecialCharacter{
    NSString *regex = @".*[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？].*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
/// 过滤特殊字符
- (NSString*)kj_removeSpecialCharacter:(NSString*_Nullable)character{
    if (character == nil) {
        character = @"‘；：”“'。，、,.？、 ~￥#……&<>《》()[]{}【】^!@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€";
    }
    NSRange urgentRange = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:character]];
    if (urgentRange.location != NSNotFound){
        return [self kj_removeSpecialCharacter:[self stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return self;
}
//MARK: - 验证手机号码是否有效
- (BOOL)kj_validateMobileNumber{
    if (self.length != 11) return NO;
    NSString *mo = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    NSString *cm = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    NSString *cu = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    NSString *ct = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    NSPredicate *regexmo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mo];
    NSPredicate *regexcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cm];
    NSPredicate *regexcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cu];
    NSPredicate *regexct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ct];
    if ([regexmo evaluateWithObject:self] || [regexcm evaluateWithObject:self] || [regexct evaluateWithObject:self] || [regexcu evaluateWithObject:self]){
        return YES;
    }else{
        return NO;
    }
}
//MARK: - 验证邮箱格式是否正确
- (BOOL)kj_validateEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
//MARK: - 判断身份证是否是真实的
- (BOOL)kj_validateIDCardNumber{
    NSString *value = self;
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if (!value) {
        return NO;
    }else{
        length = value.length;
        if (length != 15 && length != 18) return NO;
    }
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray){
        if ([areaCode isEqualToString:valueStart2]){
            areaFlag = YES;
            break;
        }
    }
    if (areaFlag == NO) return NO;
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    NSInteger year = 0;
    switch (length){
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue + 1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];
            }else{
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];
            }
            return [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)] > 0 ? YES : NO;
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];
            }else{
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0){
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue)*7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue)*9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value  substringWithRange:NSMakeRange(12,1)].intValue)*10 + ([value  substringWithRange:NSMakeRange(3,1)].intValue + [value  substringWithRange:NSMakeRange(13,1)].intValue)*5 + ([value  substringWithRange:NSMakeRange(4,1)].intValue + [value  substringWithRange:NSMakeRange(14,1)].intValue)*8 + ([value  substringWithRange:NSMakeRange(5,1)].intValue + [value  substringWithRange:NSMakeRange(15,1)].intValue)*4 + ([value  substringWithRange:NSMakeRange(6,1)].intValue + [value  substringWithRange:NSMakeRange(16,1)].intValue)*2 + [value  substringWithRange:NSMakeRange(7,1)].intValue *1 + [value  substringWithRange:NSMakeRange(8,1)].intValue *6 + [value  substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];
                return [M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]];
            }else{
                return NO;
            }
        default:
            return NO;
    }
}
/// 验证银行卡
- (BOOL)kj_validateBankCardNumber{
    NSString * const BANKCARD = @"^(\\d{16}|\\d{19})$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", BANKCARD];
    return [predicate evaluateWithObject:self];
}

#pragma mark - 文本相关
/// 获取文本宽度
- (CGFloat)kj_maxWidthWithFont:(UIFont*)font Height:(CGFloat)height Alignment:(NSTextAlignment)alignment LinebreakMode:(NSLineBreakMode)linebreakMode LineSpace:(CGFloat)lineSpace{
    return [self kj_sizeWithFont:font Size:CGSizeMake(CGFLOAT_MAX, height) Alignment:alignment LinebreakMode:linebreakMode LineSpace:lineSpace].width;
}
/// 获取文本高度
- (CGFloat)kj_maxHeightWithFont:(UIFont*)font Width:(CGFloat)width Alignment:(NSTextAlignment)alignment LinebreakMode:(NSLineBreakMode)linebreakMode LineSpace:(CGFloat)lineSpace{
    return [self kj_sizeWithFont:font Size:CGSizeMake(width, CGFLOAT_MAX) Alignment:alignment LinebreakMode:linebreakMode LineSpace:lineSpace].height;
}
- (CGSize)kj_sizeWithFont:(UIFont*)font Size:(CGSize)size Alignment:(NSTextAlignment)alignment LinebreakMode:(NSLineBreakMode)linebreakMode LineSpace:(CGFloat)lineSpace{
    if (self.length == 0) return CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = linebreakMode;
    paragraphStyle.alignment = alignment;
    if (lineSpace > 0) paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize newSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:NULL].size;
    return CGSizeMake(ceil(newSize.width), ceil(newSize.height));
}
/// 文字转图片
- (UIImage*)kj_textBecomeImageWithSize:(CGSize)size BackgroundColor:(UIColor*)color TextAttributes:(NSDictionary*)attributes{
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, bounds);
    CGSize textSize = [self sizeWithAttributes:attributes];
    [self drawInRect:CGRectMake(bounds.size.width/2-textSize.width/2, bounds.size.height/2-textSize.height/2, textSize.width, textSize.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 复制数据至剪切板
- (void)kj_pasteboard{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self;
}
/// 取出剪切板数据

#pragma mark - 数学运算
/* 相加 */
NSString * kStringAdd(NSString *a, NSString *b){
    if (kBlank(a)) a = @"0";
    if (kBlank(b) || kStringCompare(b, @"0") == NSOrderedSame) b = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *result = [decimalA decimalNumberByAdding:decimalB];
    return [result stringValue];
}
/* 相减 */
NSString * kStringSubtract(NSString *a, NSString *b){
    if (kBlank(a)) a = @"0";
    if (kBlank(b)) b = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *result = [decimalA decimalNumberBySubtracting:decimalB];
    return [result stringValue];
}
/* 相乘 */
NSString * kStringMultiply(NSString *a, NSString *b){
    if (kBlank(a)) a = @"0";
    if (kBlank(b)) b = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *result = [decimalA decimalNumberByMultiplyingBy:decimalB];
    return [result stringValue];
}
/* 相除 */
NSString * kStringDivide(NSString *a, NSString *b){
    if (kBlank(a)) a = @"0";
    if (kBlank(b)) b = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *result = [decimalA decimalNumberByDividingBy:decimalB];
    return [result stringValue];
}
/* 取次方 */
void kStringPower(NSString * _Nonnull __strong * _Nonnull string, NSInteger oxff){
    NSString *temp = *string;
    if (kBlank(temp)) temp = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:temp];
    NSDecimalNumber *result = [decimalA decimalNumberByRaisingToPower:oxff];
    *string = [result stringValue];
}
/* 保留精度，不会补齐 */
void kStringFormatScale(NSString * _Nonnull __strong * _Nonnull string, NSInteger scale){
    NSString *temp = *string;
    if (kBlank(temp)) temp = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:temp];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *result = [decimalA decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    *string = [result stringValue];
}
/* 比较大小 */
NSComparisonResult kStringCompare(NSString *a, NSString *b){
    if (a.length <= 0) return NSOrderedAscending;
    if (kBlank(b)) b = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:b];
    return [decimalA compare:decimalB];
}
/// 是否为空
bool kBlank(NSString *string){
    NSString *trimed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimed.length <= 0;
}

@end
