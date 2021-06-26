//
//  _KJMacros.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/6/5.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#ifndef _KJMacros_h
#define _KJMacros_h

#pragma mark - ////////////////////////////// 宏相关 //////////////////////////////

#pragma mark ********** 1.缩写 ************
#define kApplication        [UIApplication sharedApplication]
#define kAppDelegate        [UIApplication sharedApplication].delegate // AppDelegate
#define kNotificationCenter [NSNotificationCenter defaultCenter] // 通知中心
#define kPostNotification(name,obj,info) [kNotificationCenter postNotificationName:name object:obj userInfo:info] // 发送通知
#define kMethodDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE("Please use " # instead " instead") // 方法失效
#define kKeyWindow \
({UIWindow *window;\
if (@available(iOS 13.0, *)) {\
window = [UIApplication sharedApplication].windows.firstObject;\
}else{\
window = [UIApplication sharedApplication].keyWindow;\
}\
window;})

#pragma mark ********** 2.自定义高效率的 NSLog ************
#ifdef DEBUG // 输出日志 (格式: [编译时间] [文件名] [方法名] [行号] [输出内容])
#define NSLog(FORMAT, ...) fprintf(stderr,"------- 🎈 给我点赞 🎈 -------\n编译时间:%s\n文件名:%s\n方法名:%s\n行号:%d\n打印信息:%s\n\n", __TIME__,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__func__,__LINE__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(FORMAT, ...) nil
#endif

#define kNSSTRING_NOT_NIL(value)  value ? value : @""
#define kNSARRAY_NOT_NIL(value)   value ? value : @[]
#define kNSDICTIONARY_NOT_NIL(value)  value ? value : @{}
#define kNSSTRING_VALUE_OPTIONAL(value)  [value isKindOfClass:[NSString class] ] ? value : nil

// 字符串拼接
#define kStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
// block相关宏
#define kBlockSafeRun(block,...) block ? block(__VA_ARGS__) : nil
// 版本判定 大于等于某个版本
#define kCurrentSystemVersion(version) ([[[UIDevice currentDevice] systemVersion] compare:@#version options:NSNumericSearch]!=NSOrderedAscending)
// 获取时间间隔宏
#define kTimeTick CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kTimeTock NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start);

#pragma mark ********** 3.弱引用 *********
#define _weakself __weak __typeof(&*self) weakself = self
#ifndef kWeakObject
#if DEBUG
#if __has_feature(objc_arc)
#define kWeakObject(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define kWeakObject(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define kWeakObject(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define kWeakObject(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef kStrongObject
#if DEBUG
#if __has_feature(objc_arc)
#define kStrongObject(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define kStrongObject(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define kStrongObject(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define kStrongObject(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#pragma mark ********** 5.iPhoneX系列尺寸布局   *********
// 判断是否为iPhone X 系列
#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 13.0, *)) {\
isPhoneX = [UIApplication sharedApplication].windows.firstObject.safeAreaInsets.bottom > 0.0;\
}else if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
// tabBar height
#define kTABBAR_HEIGHT (iPhoneX ? (49.f + 34.f) : 49.f)
// statusBar height
#define kSTATUSBAR_HEIGHT (iPhoneX ? 44.0f : 20.f)
// navigationBar height
#define kNAVIGATION_HEIGHT (44.f)
// (navigationBar + statusBar) height
#define kSTATUSBAR_NAVIGATION_HEIGHT (iPhoneX ? 88.0f : 64.f)
// tabar距底边高度
#define kBOTTOM_SPACE_HEIGHT (iPhoneX ? 34.0f : 0.0f)
// 屏幕尺寸
#define kScreenSize ([UIScreen mainScreen].bounds.size)
#define kScreenW    ([UIScreen mainScreen].bounds.size.width)
#define kScreenH    ([UIScreen mainScreen].bounds.size.height)
#define kScreenRect CGRectMake(0, 0, kScreenW, kScreenH)
// AutoSize
#define kAutoW(x)   (x * kScreenW / 375.0)
#define kAutoH(x)   (x * kScreenH / 667.0)
// 一个像素
#define kOnePixel   (1 / [UIScreen mainScreen].scale)

#pragma mark ********** 6.颜色和图片相关  *********
#define UIColorFromHEXA(hex,a)    [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0f green:((hex&0xFF00)>>8)/255.0f blue:(hex&0xFF)/255.0f alpha:a]
#define UIColorFromRGBA(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define UIColorHexFromRGB(hex)    UIColorFromHEXA(hex,1.0)
#define kRGBA(r,g,b,a)            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kRGB(r,g,b)               kRGBA(r,g,b,1.0f)
#define kColor(hex,a)             UIColorFromHEXA(hex,a)
// 设置图片
#define kGetImage(imageName) ([UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]])
// 通过图片获取图片颜色
#define kImageToColor(image) [UIColor colorWithPatternImage:image]

#pragma mark ********** 7.系统默认字体设置和自选字体设置    *********
#define kSystemFontSize(fontsize)       [UIFont systemFontOfSize:(fontsize)]
#define kFont(A)                        [UIFont systemFontOfSize:A]
#define kFont_Blod(A)                   [UIFont boldSystemFontOfSize:A]
#define kFont_Medium(A)                 [UIFont systemFontOfSize:A weight:UIFontWeightMedium]
#define kFont_Italic(A)                 [UIFont italicSystemFontOfSize:A]

#endif /* _KJMacros_h */
