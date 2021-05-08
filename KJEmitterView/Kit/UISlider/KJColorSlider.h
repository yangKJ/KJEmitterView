//
//  KJColorSlider.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/8/24.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  渐变色滑块

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJColorSlider : UISlider
/// 颜色数组，默认白色
@property(nonatomic,strong) NSArray<UIColor*>*colors;
/// 每个颜色对应的位置信息
@property(nonatomic,strong) NSArray<NSNumber*>*locations;
/// 颜色的高度，默认2.5px
@property(nonatomic,assign) CGFloat colorHeight;
/// 边框宽度，默认0px
@property(nonatomic,assign) CGFloat borderWidth;
/// 边框颜色，默认黑色
@property(nonatomic,strong) UIColor *borderColor;
/// 回调处理时间，默认为0
@property(nonatomic,assign) float timeSpan;
/// 当前进度，用于外界kvo
@property(nonatomic,assign,readonly) CGFloat progress;
/// 移动回调处理
@property(nonatomic,readwrite,copy) void(^kValueChangeBlock)(CGFloat progress);
/// 移动结束回调处理
@property(nonatomic,readwrite,copy) void(^kMoveEndBlock)(CGFloat progress);
/// 重新设置UI
- (void)kj_setUI;

@end

NS_ASSUME_NONNULL_END
