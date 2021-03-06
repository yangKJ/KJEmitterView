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
        [self isEqualToString:@"null"] ||
        [self isEqualToString:@"<null>"] ||
        [self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
- (NSString *)safeString{
    if (self.isEmpty) {
        return @"";
    }
    return self;
}
/// 转换为URL
- (NSURL *)URL{ return [NSURL URLWithString:self];}
/// 获取图片
- (UIImage *)image{ return [UIImage imageNamed:self];}
/// 取出HTML
- (NSString *)HTMLString{
    if (self == nil) return nil;
    NSString *html = self;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while ([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}
/// 生成竖直文字
- (NSString *)verticalText{
    NSMutableString *text = [[NSMutableString alloc] initWithString:self];
    NSInteger count = text.length;
    for (int i = 1; i < count; i ++) {
        [text insertString:@"\n" atIndex:i*2-1];
    }
    return text;
}

#pragma mark - Json相关
/// Josn字符串转字典
- (NSDictionary *)jsonDict{
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
NSDictionary * kJsonToDictionary(NSString *string){
    if (string == nil) return nil;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) return nil;
    return dic;
}

#pragma mark - 汉字相关处理
/// 汉字转拼音
- (NSString *)pinYin{
    NSMutableString *string = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformMandarinLatin, NO);//先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformStripDiacritics, NO);//再转换为不带声调的拼音
    return string;
}
/// 随机汉字
NSString * kRandomChinese(NSInteger count){
    NSMutableString *randomChineseString = @"".mutableCopy;
    for (NSInteger i = 0; i < count; i++) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSInteger randomH = 0xA1 + arc4random()%(0xFE - 0xA1+1);
        NSInteger randomL = 0xB0 + arc4random()%(0xF7 - 0xB0+1);
        NSInteger number = (randomH<<8) + randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        NSString *string = [[NSString alloc]initWithData:data encoding:gbkEncoding];
        [randomChineseString appendString:string];
    }
    return randomChineseString.mutableCopy;
}
/// 查找数据，返回-1表示未查询到
- (int)kj_searchArray:(NSArray<NSString*>*)temps{
    unsigned index = (unsigned)CFArrayBSearchValues((CFArrayRef)temps,
                                                    CFRangeMake(0, temps.count),
                                                    (CFStringRef)self,
                                                    (CFComparatorFunction)CFStringCompare,
                                                    NULL);
    if (index < temps.count && [self isEqualToString:temps[index]]){
        return index;
    }else{
        return -1;
    }
}
/// 字母排序
NSArray<NSString*>* kDoraemonBoxAlphabetSort(NSArray<NSString*>* array){
    return [array sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - 谓词相关
//MARK: - 过滤空格
- (NSString *)kj_filterSpace{
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
- (NSString *)kj_removeSpecialCharacter:(NSString*_Nullable)character{
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
    if ([regexmo evaluateWithObject:self] ||
        [regexcm evaluateWithObject:self] ||
        [regexct evaluateWithObject:self] ||
        [regexcu evaluateWithObject:self]) {
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
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32",
                            @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45",
                            @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
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
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
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
                int S =
                ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue)*7 +
                ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue)*9 +
                ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue)*10 +
                ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue)*5 +
                ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue)*8 +
                ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue)*4 +
                ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue)*2 +
                [value  substringWithRange:NSMakeRange(7,1)].intValue * 1 +
                [value  substringWithRange:NSMakeRange(8,1)].intValue * 6 +
                [value  substringWithRange:NSMakeRange(9,1)].intValue * 3;
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

- (BOOL)kj_isNull{
    if (self == nil || self == NULL || self.length == 0 || [self isEqual:NSNull.null]) {
        return YES;
    }
    return NO;
}

- (BOOL)kj_isCharEqual{
    if (self.length == 0) return YES;
    NSString *character = [self substringWithRange:NSMakeRange(0, 1)];
    NSString *string = [self stringByReplacingOccurrencesOfString:character withString:@""];
    return !string.length;
}

- (BOOL)kj_isNumeric{
    if (self.length == 0) return NO;
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    return [regex evaluateWithObject:self];
}

#pragma mark - 密码强度判断
/// 密码强度等级
- (KJPasswordLevel)kj_passwordLevel{
    NSInteger level = [self kj_checkPasswordStrength];
    switch (level) {
        case 0:
        case 1:
        case 2:
        case 3:
            return KJPasswordLevelEasy;
        case 4:
        case 5:
        case 6:
            return KJPasswordLevelMidium;
        case 7:
        case 8:
        case 9:
            return KJPasswordLevelStrong;
        case 10:
        case 11:
        case 12:
            return KJPasswordLevelVeryStrong;
        default:
            return KJPasswordLevelExtremelyStrong;
    }
}
/// 检查密码强度
- (NSInteger)kj_checkPasswordStrength{
    if ([self kj_isNull] || [self kj_isCharEqual]) {
        return 0;
    }
    // 数字类型
    static int NUM = 1;
    // 小写字母
    static int SMALL_LETTER = 2;
    // 大写字母
    static int CAPITAL_LETTER = 3;
    // 其他字符
    static int OTHER_CHAR = 4;
    //按不同类型计算密码
    NSInteger(^kLetter)(NSString *, NSInteger) = ^NSInteger(NSString *password, NSInteger type){
        //检查字符的类型，包括数字、大写字母、小写字母等字符
        NSInteger(^checkCharacterType)(NSString *) = ^NSInteger(NSString *character){
            int asciiCode = [character characterAtIndex:0];
            if (asciiCode >= 48 && asciiCode <= 57) {
                return NUM;
            }
            if (asciiCode >= 65 && asciiCode <= 90) {
                return CAPITAL_LETTER;
            }
            if (asciiCode >= 97 && asciiCode <= 122) {
                return SMALL_LETTER;
            }
            return OTHER_CHAR;
        };
        int count = 0;
        if (password != nil && password.length) {
            for (NSUInteger i = 0; i < password.length; i ++) {
                NSString *character = [password substringWithRange:NSMakeRange(i, 1)];
                if (checkCharacterType(character) == type) {
                    count ++;
                }
            }
        }
        return count;
    };
    NSInteger len = self.length;
    __block NSInteger level = 0;
    if (kLetter(self, NUM) > 0) {
        level++;
    }
    if (kLetter(self, SMALL_LETTER) > 0) {
        level++;
    }
    if (len > 4 && kLetter(self, CAPITAL_LETTER) > 0) {
        level++;
    }
    if (len > 6 && kLetter(self, OTHER_CHAR) > 0) {
        level++;
    }
    if ((len > 4 && kLetter(self, NUM) > 0 && kLetter(self, SMALL_LETTER) > 0) ||
        (kLetter(self, NUM) > 0 && kLetter(self, CAPITAL_LETTER) > 0) ||
        (kLetter(self, NUM) > 0 && kLetter(self, OTHER_CHAR) > 0) ||
        (kLetter(self, SMALL_LETTER) > 0 && kLetter(self, CAPITAL_LETTER) > 0) ||
        (kLetter(self, SMALL_LETTER) > 0 && kLetter(self, OTHER_CHAR) > 0) ||
        (kLetter(self, CAPITAL_LETTER) > 0 && kLetter(self, OTHER_CHAR) > 0)) {
        level++;
    }
    
    if ((len > 6 && kLetter(self, NUM) > 0 && kLetter(self, SMALL_LETTER) > 0 && kLetter(self, CAPITAL_LETTER) > 0) ||
        (kLetter(self, NUM) > 0 && kLetter(self, SMALL_LETTER) > 0 && kLetter(self, OTHER_CHAR) > 0) ||
        (kLetter(self, NUM) > 0 && kLetter(self, CAPITAL_LETTER) > 0 && kLetter(self, OTHER_CHAR) > 0) ||
        (kLetter(self, SMALL_LETTER) > 0 && kLetter(self, CAPITAL_LETTER) > 0 && kLetter(self, OTHER_CHAR) > 0)) {
        level++;
    }
    
    if (len > 8 &&
        kLetter(self, NUM) > 0 &&
        kLetter(self, SMALL_LETTER) > 0 &&
        kLetter(self, CAPITAL_LETTER) > 0 &&
        kLetter(self, OTHER_CHAR) > 0) {
        level++;
    }
    
    if ((len > 6 && kLetter(self, NUM) >= 3 && kLetter(self, SMALL_LETTER) >= 3) ||
        (kLetter(self, NUM) >= 3 && kLetter(self, CAPITAL_LETTER) >= 3) ||
        (kLetter(self, NUM) >= 3 && kLetter(self, OTHER_CHAR) >= 2) ||
        (kLetter(self, SMALL_LETTER) >= 3 && kLetter(self, CAPITAL_LETTER) >= 3) ||
        (kLetter(self, SMALL_LETTER) >= 3 && kLetter(self, OTHER_CHAR) >= 2) ||
        (kLetter(self, CAPITAL_LETTER) >= 3 && kLetter(self, OTHER_CHAR) >= 2)) {
        level++;
    }
    
    if ((len > 8 && kLetter(self, NUM) >= 2 && kLetter(self, SMALL_LETTER) >= 2 && kLetter(self, CAPITAL_LETTER) >= 2) ||
        (kLetter(self, NUM) >= 2 && kLetter(self, SMALL_LETTER) >= 2 && kLetter(self, OTHER_CHAR) >= 2) ||
        (kLetter(self, NUM) >= 2 && kLetter(self, CAPITAL_LETTER) >= 2 && kLetter(self, OTHER_CHAR) >= 2) ||
        (kLetter(self, SMALL_LETTER) >= 2 && kLetter(self, CAPITAL_LETTER) >= 2 && kLetter(self, OTHER_CHAR) >= 2)) {
        level++;
    }
    
    if (len > 10 &&
        kLetter(self, NUM) >= 2 &&
        kLetter(self, SMALL_LETTER) >= 2 &&
        kLetter(self, CAPITAL_LETTER) >= 2 &&
        kLetter(self, OTHER_CHAR) >= 2) {
        level++;
    }
    
    if (kLetter(self, OTHER_CHAR) >= 3) {
        level++;
    }
    if (kLetter(self, OTHER_CHAR) >= 6) {
        level++;
    }
    
    if (len > 12) {
        level++;
        if (len >= 16) level++;
    }
    
    // decrease points
    if ([@"abcdefghijklmnopqrstuvwxyz" containsString:self] ||
        [@"ABCDEFGHIJKLMNOPQRSTUVWXYZ" containsString:self]) {
        level--;
    }
    if ([@"qwertyuiop" containsString:self] ||
        [@"asdfghjkl" containsString:self] ||
        [@"zxcvbnm" containsString:self]) {
        level--;
    }
    if (([self kj_isNumeric] && [@"01234567890" containsString:self]) ||
        [@"09876543210" containsString:self]) {
        level--;
    }
    if (kLetter(self, NUM) == len ||
        kLetter(self, SMALL_LETTER) == len ||
        kLetter(self, CAPITAL_LETTER) == len) {
        level--;
    }
    
    if (len % 2 == 0) { // aaabbb
        NSString *part1 = [self substringWithRange:NSMakeRange(0, len / 2)];
        NSString *part2 = [self substringFromIndex:len / 2];
        if ([part1 isEqualToString:part2]) {
            level--;
        }
        if ([part1 kj_isCharEqual] && [part2 kj_isCharEqual]) {
            level--;
        }
    }
    if (len % 3 == 0) { // ababab
        NSString *part1 = [self substringWithRange:NSMakeRange(0, len / 3)];
        NSString *part2 = [self substringWithRange:NSMakeRange(len / 3, len / 3)];
        NSString *part3 = [self substringFromIndex:len / 3];
        if ([part1 isEqualToString:part2] && [part2 isEqualToString:part3]) {
            level--;
        }
    }
    if ([self kj_isNumeric] && len >= 6) { // 19881010 or 881010
        NSInteger year = 0;
        if (len == 8 || len == 6) {
            year = [self substringToIndex:self.length - 4].integerValue;
        }
        NSInteger size = len - 4;
        NSInteger month = [self substringWithRange:NSMakeRange(size, 2)].integerValue;
        NSInteger day = [self substringWithRange:NSMakeRange(size + 2, 2)].integerValue;
        if ((year >= 1950 && year < 2050) && (month >= 1 && month <= 12) && (day >= 1 && day <= 31)) {
            level--;
        }
    }
    // 常用简易密码字典
    NSArray<NSString *> *commonUsers = @[@"password", @"abc123", @"iloveyou", @"adobe123", @"123123",
                                         @"sunshine", @"1314520", @"a1b2c3", @"123qwe", @"aaa111", @"qweasd", @"admin", @"passwd"];
    [commonUsers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:self] || [obj containsString:self]) {
            level --;
            *stop = YES;
        }
    }];
    if (len <= 6) {
        level--;
        if (len <= 4) {
            level--;
            if (len <= 3) {
                level = 0;
            }
        }
    }
    if (level < 0) {
        level = 0;
    }
    return level;
}

#pragma mark - 文本相关
/// 获取文本宽度
- (CGFloat)kj_maxWidthWithFont:(UIFont *)font
                        Height:(CGFloat)height
                     Alignment:(NSTextAlignment)alignment
                 LinebreakMode:(NSLineBreakMode)linebreakMode
                     LineSpace:(CGFloat)lineSpace{
    return [self kj_sizeWithFont:font
                            Size:CGSizeMake(CGFLOAT_MAX, height)
                       Alignment:alignment
                   LinebreakMode:linebreakMode
                       LineSpace:lineSpace].width;
}
/// 获取文本高度
- (CGFloat)kj_maxHeightWithFont:(UIFont *)font
                          Width:(CGFloat)width
                      Alignment:(NSTextAlignment)alignment
                  LinebreakMode:(NSLineBreakMode)linebreakMode
                      LineSpace:(CGFloat)lineSpace{
    return [self kj_sizeWithFont:font
                            Size:CGSizeMake(width, CGFLOAT_MAX)
                       Alignment:alignment
                   LinebreakMode:linebreakMode
                       LineSpace:lineSpace].height;
}
- (CGSize)kj_sizeWithFont:(UIFont *)font
                     Size:(CGSize)size
                Alignment:(NSTextAlignment)alignment
            LinebreakMode:(NSLineBreakMode)linebreakMode
                LineSpace:(CGFloat)lineSpace{
    if (self.length == 0) return CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = linebreakMode;
    paragraphStyle.alignment = alignment;
    if (lineSpace > 0) paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize newSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                     attributes:attributes context:NULL].size;
    return CGSizeMake(ceil(newSize.width), ceil(newSize.height));
}
/// 计算字符串高度尺寸，spacing为行间距
- (CGSize)kj_textSizeWithFont:(UIFont *)font superSize:(CGSize)size spacing:(CGFloat)spacing{
    if (self == nil) return CGSizeMake(0, 0);
    NSDictionary *dict = @{NSFontAttributeName : font};
    if (spacing > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:spacing];
        dict = @{NSFontAttributeName: font,
                 NSParagraphStyleAttributeName:paragraphStyle
        };
    }
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
    size = [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:dict
                              context:nil].size;
#else
    size = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#endif
    return size;
}

/// 文字转图片
- (UIImage *)kj_textBecomeImageWithSize:(CGSize)size BackgroundColor:(UIColor *)color TextAttributes:(NSDictionary *)attributes{
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, bounds);
    CGSize textSize = [self sizeWithAttributes:attributes];
    [self drawInRect:CGRectMake(bounds.size.width/2-textSize.width/2,
                                bounds.size.height/2-textSize.height/2,
                                textSize.width,
                                textSize.height) withAttributes:attributes];
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
/// 是否为空
NS_INLINE BOOL kStringBlank(NSString *string){
    NSString *trimed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimed.length <= 0;
}
/* 比较大小 */
- (NSComparisonResult)kj_compare:(NSString *)string{
    if (self.length <= 0) return NSOrderedAscending;
    if (kStringBlank(string)) string = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    return [decimalA compare:decimalB];
}
/* 相加 */
- (NSString *)kj_adding:(NSString *)string{
    if (kStringBlank(string) || [string kj_compare:@"0"] == NSOrderedSame) string = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *result = [decimalA decimalNumberByAdding:decimalB];
    return [result stringValue];
}
/* 相减 */
- (NSString *)kj_subtract:(NSString *)string{
    if (kStringBlank(string)) string = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *result = [decimalA decimalNumberBySubtracting:decimalB];
    return [result stringValue];
}
/* 相乘 */
- (NSString *)kj_multiply:(NSString *)string{
    if (kStringBlank(string)) string = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *result = [decimalA decimalNumberByMultiplyingBy:decimalB];
    return [result stringValue];
}
/* 相除 */
- (NSString *)kj_divide:(NSString *)string{
    if (kStringBlank(string) || ![string floatValue]) return @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *result = [decimalA decimalNumberByDividingBy:decimalB];
    return [result stringValue];
}
/// 指数运算
- (NSString *)kj_multiplyingByPowerOf10:(NSInteger)oxff{
    NSString *temp = self;
    if (kStringBlank(temp)) temp = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:temp];
    NSDecimalNumber *result = [decimalA decimalNumberByMultiplyingByPowerOf10:oxff];
    return [result stringValue];
}
/// 次方运算
- (NSString *)kj_raisingToPower:(NSInteger)oxff{
    NSString *temp = self;
    if (kStringBlank(temp)) temp = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:temp];
    NSDecimalNumber *result = [decimalA decimalNumberByRaisingToPower:oxff];
    return [result stringValue];
}
/// 转成小数
- (double)kj_calculateDoubleValue{
    NSDecimalNumber * num = [NSDecimalNumber decimalNumberWithString:self];
    return [num doubleValue];
}
/// 保留整数部分，100.0130 -- > 100
- (NSString *)kj_retainInteger{
    if (![self containsString:@"."]) {
        return self;
    } else {
        NSArray *array = [self componentsSeparatedByString:@"."];
        return array.firstObject;
    }
}
/// 去掉尾巴是0或者.的位数，10.000 -- > 10 或者 10.100 -- > 10.1
- (NSString *)kj_removeTailZero{
    NSString * string = self;
    if (![string containsString:@"."]) {
        return string;
    }else if ([string hasSuffix:@"0"]) {
        return [[string substringToIndex:string.length - 1] kj_removeTailZero];
    }else if ([string hasSuffix:@"."]) {
        return [string substringToIndex:string.length - 1];
    }else{
        return string;
    }
}
/// 保留几位小数，四舍五入保留两位则，10.00001245 -- > 10.00  或者 120.026 -- > 120.03
NSString * kStringFractionDigits(NSDecimalNumber * number, NSUInteger digits){
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:digits];
    [formatter setMinimumFractionDigits:0];
    [formatter setMinimumIntegerDigits:1];
    return [formatter stringFromNumber:number];
}
+ (NSString *)kj_fractionDigits:(double)value digits:(NSUInteger)digits{
    NSNumber * number = [NSNumber numberWithDouble:value];
    NSDecimalNumber * decNum = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    return kStringFractionDigits(decNum, digits);
}
/// 保留小数，直接去掉小数多余部分
+ (NSString *)kj_retainDigits:(double)value digits:(int)digits{
    NSString * string = [self kj_doublePrecisionReviseWithDouble:value];
    if (![string containsString:@"."]) {
        return string;
    } else {
        NSArray<NSString*> * array = [string componentsSeparatedByString:@"."];
        if (array.count < 2) {
            return string;
        }
        if (digits == 0) {
            return array.firstObject;
        } else {
            NSString * decimals = array.lastObject;
            if (decimals.length > digits) {
                decimals = [decimals substringToIndex:digits];
            }
            return [NSString stringWithFormat:@"%@.%@",array.firstObject, decimals];
        }
    }
    return string;
}
/// 保留几位有效小数位数，保留两位则，10.00001245 -- > 10.000012  或者 120.02 -- > 120.02 或者 10.000 -- > 10
NSString * kStringReservedValidDigit(NSDecimalNumber * value, NSInteger digit){
    NSString *string = [value stringValue];
    if (![string containsString:@"."]) {
        return string;
    }else{
        NSArray<NSString*>*array = [string componentsSeparatedByString:@"."];
        NSString *decimals = array[1];
        if (![decimals floatValue]) {
            string = array[0];
        }else{
            if (digit == 0) {
                return [NSString stringWithFormat:@"%@",array[0]];
            }
            if (decimals.length <= digit) {
                string = [NSString stringWithFormat:@"%@.%@",array[0],decimals];
            }else{
                int a = 0;
                while (true) {
                    if ([decimals hasPrefix:@"0"]) {
                        a++;
                        decimals = [decimals substringFromIndex:1];
                    }else{
                        if (decimals.length > digit) {
                            decimals = [decimals substringToIndex:digit];
                        }
                        break;
                    }
                }
                for (int i = 0; i < a; i++) {
                    decimals = [NSString stringWithFormat:@"0%@",decimals];
                }
                string = [NSString stringWithFormat:@"%@.%@",array[0],decimals];
            }
        }
    }
    return string;
}
+ (NSString *)kj_reservedValidDigit:(double)value digit:(int)digit{
    NSNumber * number = [NSNumber numberWithDouble:value];
    NSDecimalNumber * decNum = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    return kStringReservedValidDigit(decNum, digit);
}
/// Double精度丢失修复
- (NSString *)kj_doublePrecisionRevise{
    double conversionValue = [self doubleValue];
    return [NSString kj_doublePrecisionReviseWithDouble:conversionValue];
}
+ (NSString *)kj_doublePrecisionReviseWithDouble:(double)conversionValue{
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
