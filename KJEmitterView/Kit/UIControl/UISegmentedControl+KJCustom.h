//
//  UISegmentedControl+KJCustom.h
//  Winpower
//
//  Created by 杨科军 on 2019/10/12.
//  Copyright © 2019 cq. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISegmentedControl (KJCustom)
/// 解决修改背景色和文字颜色
- (void)kj_ensureBackgroundAndTintColor;

@end

NS_ASSUME_NONNULL_END
