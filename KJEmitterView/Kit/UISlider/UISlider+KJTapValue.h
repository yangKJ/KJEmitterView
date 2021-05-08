//
//  UISlider+KJTapValue.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/9/17.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  滑杆点击改值

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISlider (KJTapValue)
/// 是否开启滑杆点击修改值
@property(nonatomic,assign) bool kTapValue;
@end

NS_ASSUME_NONNULL_END
