//
//  UIButton+KJBlock.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/4/4.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  点击事件ButtonBlock

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
typedef void(^KJButtonBlock)(UIButton *kButton);
@interface UIButton (KJBlock)
/// 添加点击事件，默认UIControlEventTouchUpInside
- (void)kj_addAction:(KJButtonBlock)block;
/// 添加事件，不支持多枚举形式
- (void)kj_addAction:(KJButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;

/// 点击事件间隔，设置非零取消间隔
@property(nonatomic,assign)IBInspectable CGFloat timeInterval;

@end

NS_ASSUME_NONNULL_END
