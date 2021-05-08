//
//  KJHomeEmitterView.h
//  MoLiao
//
//  Created by 杨科军 on 2018/7/30.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  首页 - 粒子效果背景

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, KJEmitterType){
    KJEmitterTypeFireworks = 0,// 烟花
    KJEmitterTypeBubble    = 1,// 气泡
    KJEmitterTypeStarrySky = 2,// 星空
    KJEmitterTypeSnowflake = 3,// 雪花
};

@interface KJEmitterView : UIView
// 初始化
+ (instancetype)createEmitterViewWithType:(KJEmitterType)type Block:(void(^_Nullable)(KJEmitterView *obj))block;
// 动画结束
@property(nonatomic,readwrite, copy)void(^EndAnimation)(void);
// 消失时间，默认1.0秒
@property(nonatomic,assign) CGFloat dissmissTime;
// 链接式设置属性
@property(nonatomic,strong,readonly) KJEmitterView *(^KJTag)(NSInteger);
@property(nonatomic,strong,readonly) KJEmitterView *(^KJFrame)(CGRect);//frame
@property(nonatomic,strong,readonly) KJEmitterView *(^KJBackgroundColor)(UIColor *);//backgroundColor
@property(nonatomic,strong,readonly) KJEmitterView *(^KJAddView)(UIView *);

@end

NS_ASSUME_NONNULL_END
