//
//  KJSwitchControl.h
//  Demo
//
//  Created by 杨科军 on 2018/7/25.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  一款可爱的笑脸动画Switch控件

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
NS_ASSUME_NONNULL_BEGIN
@protocol KJSwitchControlDelegate;
@interface KJSwitchControl : UIControl

/// 打开颜色,默认蓝色
@property(nonatomic,strong) IBInspectable UIColor *onColor;
/// 关闭颜色,默认灰色
@property(nonatomic,strong) IBInspectable UIColor *offColor;
/// 笑脸颜色,默认白色
@property(nonatomic,strong) IBInspectable UIColor *faceColor;
/// 动画持续时间,默认1.2秒
@property(nonatomic,assign) IBInspectable CGFloat animationDuration;
/// 控件状态,默认关闭
@property(nonatomic,assign) IBInspectable BOOL on;
/// 委托代理
@property(nonatomic,weak) id <KJSwitchControlDelegate> delegate;
/// 设置控件动态状态
- (void)setSwitchControlIsOn:(BOOL)on animated:(BOOL)animated;

@end

#pragma mark - KJSwitchControlDelegate
@protocol KJSwitchControlDelegate <NSObject>
@optional
/// 动画开始
- (void)kAnimationStartSwitchControl:(KJSwitchControl *)kSwitch;
/// 动画结束
- (void)kAnimationDidStopWithKSwitchControl:(KJSwitchControl *)kSwitch;
/// 状态改变
- (void)kValueDidChangedWithSwitchControl:(KJSwitchControl *)kSwitch on:(BOOL)on;

@end

NS_ASSUME_NONNULL_END
