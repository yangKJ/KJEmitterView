//
//  KJSelectControl.h
//  Demo
//
//  Created by 杨科军 on 2018/7/25.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  自定义一款动画选中控件

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger, KJSelectControlType){
    KJSelectControlTypeHook = 0,  // 打勾勾
    KJSelectControlTypeSolidCircle,  // 实心圆
};
@class KJSelectControl;
typedef void(^KJSelectControlBlock)(KJSelectControl*control, BOOL selected);
@protocol KJSelectControlDelegate <NSObject>
@optional
/// 选中状态改变调用
- (void)kj_selectActionWithControl:(KJSelectControl*)control selected:(BOOL)selected;

@end

@interface KJSelectControl : UIControl
/* 内部类型，默认打勾勾 */
@property(nonatomic,assign) KJSelectControlType kType;
/* 委托 */
@property(nonatomic,weak) id <KJSelectControlDelegate> delegate;

/* ********************* 可在Xib上设置的属性 ************************/
/* 动画持续时间，默认0.3秒 */
@property(nonatomic,assign) IBInspectable CGFloat animationDuration;
/* 线条宽度，默认为2.0 */
@property(nonatomic,assign) IBInspectable CGFloat lineWidth;
/* 选中勾勾的颜色，默认蓝色 */
@property(nonatomic,strong) IBInspectable UIColor *selectHookColor;
/* 选中线条颜色，默认蓝色 */
@property(nonatomic,strong) IBInspectable UIColor *selectedLineColor;
/* 未选中线条颜色，默认蓝色 */
@property(nonatomic,strong) IBInspectable UIColor *unselectedLineColor;
/* 选中状态，默认NO */
@property(nonatomic,assign,getter=isSelected) IBInspectable BOOL selected;

@end

NS_ASSUME_NONNULL_END
