//
//  UINavigationItem+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/1.
//  Copyright © 2018 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  Item链式生成

#import <UIKit/UIKit.h>
#import "UIButton+KJBlock.h"

NS_ASSUME_NONNULL_BEGIN

@class KJNavigationItemInfo;
@interface UINavigationItem (KJExtension)
/// 标题显示成富文本
//- (void)kj_
/// 链式生成
- (instancetype)kj_makeNavigationItem:(void(^)(UINavigationItem *make))block;
/// 快捷生成方式
/// @param title 标题
/// @param color 标题文字颜色
/// @param image 图片
/// @param tintColor 可修改图片颜色
/// @param block 点击回调
/// @param bblock 返回内部按钮
- (UIBarButtonItem *)kj_barButtonItemWithTitle:(NSString *)title
                                    titleColor:(UIColor *)color
                                         image:(UIImage *)image
                                     tintColor:(UIColor *)tintColor
                                   buttonBlock:(KJButtonBlock)block
                                barButtonBlock:(void(^)(UIButton *))bblock;

#pragma mark - ExtendParameterBlock 扩展参数
@property(nonatomic,strong,readonly) UINavigationItem *(^kAddBarButtonItemInfo)(void(^)(KJNavigationItemInfo *info), KJButtonBlock);
@property(nonatomic,strong,readonly) UINavigationItem *(^kAddLeftBarButtonItem)(UIBarButtonItem*);
@property(nonatomic,strong,readonly) UINavigationItem *(^kAddRightBarButtonItem)(UIBarButtonItem*);

@end
/// 配置参数
@interface KJNavigationItemInfo : NSObject
@property(nonatomic,strong)NSString *imageName;
@property(nonatomic,strong)NSString *title;
/// 图片颜色，默认白色
@property(nonatomic,strong)UIColor *tintColor;
/// 文字颜色，默认白色
@property(nonatomic,strong)UIColor *color;
/// 是否为左边Item，默认yes
@property(nonatomic,assign)BOOL isLeft;
/// 内部按钮，供外界修改参数
@property(nonatomic,copy,readwrite)void(^barButton)(UIButton *barButton);
@end
NS_ASSUME_NONNULL_END
