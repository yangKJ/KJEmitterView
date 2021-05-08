//
//  UINavigationBar+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/1.
//  Copyright © 2018 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  导航栏管理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (KJExtension)
/// 设置导航条标题颜色和字号
@property (nonatomic, copy, readonly) UINavigationBar * (^kChangeNavigationBarTitle)(UIColor *color, UIFont *font);
/// 设置导航栏背景色
@property (nonatomic, strong) UIColor *navgationBackground;
/// 设置图片背景导航栏
@property (nonatomic, strong) UIImage *navgationImage;
/// 设置自定义的返回按钮
@property (nonatomic, strong) NSString *navgationCustomBackImageName;
/// 隐藏导航条底部下划线
- (UINavigationBar *)kj_hiddenNavigationBarBottomLine;
/// 默认恢复成系统的颜色和下划线
- (void)kj_resetNavigationBarSystem;

//************************  自定义导航栏相关  ************************
/// 更改导航栏颜色和图片
- (instancetype)kj_customNavgationBackImage:(UIImage *_Nullable)image
                                 background:(UIColor *_Nullable)color;
/// 更改透明度
- (instancetype)kj_customNavgationAlpha:(CGFloat)alpha;
/// 导航栏背景高度，备注：这里并没有改导航栏高度，只是改了自定义背景高度
- (instancetype)kj_customNavgationHeight:(CGFloat)height;
/// 隐藏底线
- (instancetype)kj_customNavgationHiddenBottomLine:(BOOL)hidden;
/// 还原回系统导航栏
- (void)kj_customNavigationRestoreSystemNavigation;

@end

NS_ASSUME_NONNULL_END
