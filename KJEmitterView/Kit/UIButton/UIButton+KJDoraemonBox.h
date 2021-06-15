//
//  UIButton+KJDoraemonBox.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/15.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  按钮粒子效果

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (KJDoraemonBox)
#pragma mark - 粒子效果
/// 是否开启粒子效果
@property(nonatomic,assign)BOOL openEmitter;
/// 粒子，备注 name 属性不要更改
@property(nonatomic,strong,readonly)CAEmitterCell *emitterCell;
/// 设置粒子效果
- (void)kj_buttonSetEmitterImage:(UIImage*_Nullable)image OpenEmitter:(BOOL)open;

#pragma mark - 倒计时
/// 倒计时结束的回调
@property(nonatomic,copy,readwrite)void(^kButtonCountDownStop)(void);
/// 设置倒计时的间隔和倒计时文案，默认为 @"%zd秒"
- (void)kj_startTime:(NSInteger)timeout CountDownFormat:(NSString*)format;
/// 取消倒计时
- (void)kj_cancelTimer;

#pragma mark - 指示器(系统自带菊花)
/// 按钮是否正在提交中
@property(nonatomic,assign,readonly)bool submitting;
/// 指示器和文字间隔，默认5px
@property(nonatomic,assign)CGFloat indicatorSpace;
/// 指示器颜色，默认白色
@property(nonatomic,assign)UIActivityIndicatorViewStyle indicatorType;
/// 开始提交，指示器跟随文字
- (void)kj_beginSubmitting:(NSString*)title;
/// 结束提交
- (void)kj_endSubmitting;
/// 显示指示器
- (void)kj_showIndicator;
/// 隐藏指示器
- (void)kj_hideIndicator;

@end

NS_ASSUME_NONNULL_END
