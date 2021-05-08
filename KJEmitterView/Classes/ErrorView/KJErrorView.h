//
//  KJErrorView.h
//  GuessWho
//
//  Created by 杨科军 on 2018/11/20.
//  Copyright © 2018 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  错误提示框

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJErrorView : UIView

+ (instancetype)createErrorView:(void(^)(KJErrorView *obj))block;

@property(nonatomic,assign) CGFloat delayTime;
// 链接式设置属性
@property(nonatomic,strong,readonly) KJErrorView *(^KJTag)(NSInteger);
@property(nonatomic,strong,readonly) KJErrorView *(^KJFrame)(CGRect);//frame
@property(nonatomic,strong,readonly) KJErrorView *(^KJBackgroundColor)(UIColor *);//backgroundColor
@property(nonatomic,strong,readonly) KJErrorView *(^KJAddView)(UIView *);

@end

NS_ASSUME_NONNULL_END
