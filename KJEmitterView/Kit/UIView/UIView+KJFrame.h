//
//  UIView+KJFrame.h
//  CategoryDemo
//
//  Created by 杨科军 on 2018/7/12.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  轻量级布局

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KJFrame)
@property(nonatomic,assign)CGSize  size;// 大小
@property(nonatomic,assign)CGPoint origin;// 位置
@property(nonatomic,assign)CGFloat x;// x坐标
@property(nonatomic,assign)CGFloat y;// y坐标
@property(nonatomic,assign)CGFloat width;// 宽度
@property(nonatomic,assign)CGFloat height;// 高度
@property(nonatomic,assign)CGFloat centerX;// 中心点x
@property(nonatomic,assign)CGFloat centerY;// 中心点y
@property(nonatomic,assign)CGFloat left;// 左边距离
@property(nonatomic,assign)CGFloat right;// 右边距离
@property(nonatomic,assign)CGFloat top;// 顶部距离
@property(nonatomic,assign)CGFloat bottom;// 底部距离
@property(nonatomic,assign,readonly)CGFloat maxX;// x + width
@property(nonatomic,assign,readonly)CGFloat maxY;// y + height
@property(nonatomic,assign,readonly)CGFloat subviewMaxX;// 获取子视图的最高X
@property(nonatomic,assign,readonly)CGFloat subviewMaxY;// 获取子视图的最高Y
@property(nonatomic,assign,readonly)CGFloat masonryX;// 自动布局x
@property(nonatomic,assign,readonly)CGFloat masonryY;// 自动布局y
@property(nonatomic,assign,readonly)CGFloat masonryWidth;// 自动布局宽度
@property(nonatomic,assign,readonly)CGFloat masonryHeight;// 自动布局高度
@property(nonatomic,strong,readonly)UIViewController *viewController;// 当前控制器
@property(nonatomic,assign,readonly)BOOL showKeyWindow;// 是否显示在主窗口
/// 将视图中心置于其父视图，支持旋转方向后处理
- (void)kj_centerToSuperview;
/// 距父视图右边距离
- (void)kj_rightToSuperview:(CGFloat)right;
/// 距父视图下边距离
- (void)kj_bottomToSuperview:(CGFloat)bottom;

/// 隐藏/显示所有子视图
- (void)kj_hideSubviews:(BOOL)hide operation:(BOOL(^)(UIView *subview))operation;
/// 寻找子视图
- (UIView*)kj_findSubviewRecursively:(BOOL(^)(UIView *subview, BOOL * stop))recurse;
/// 移除所有子视图
- (void)kj_removeAllSubviews;
/// 更新尺寸，使用autolayout布局时需要刷新约束才能获取到真实的frame
- (void)kj_updateFrame;

@end

NS_ASSUME_NONNULL_END
