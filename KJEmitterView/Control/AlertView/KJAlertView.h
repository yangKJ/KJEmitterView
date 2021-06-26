//
//  KJAlertView.h
//  MoLiao
//
//  Created by 杨科军 on 2018/7/25.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  提示,确认框

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger, KJAlertViewType){
    KJAlertViewTypeCenter = 0,// 中间位置
    KJAlertViewTypeBottom = 1,// 底部位置
};
typedef void(^KJAlertBlock)(NSInteger index);
@interface KJAlertView : UIView
/// 初始化
/// @param type 显示位置
/// @param title 标题
/// @param content 内容
/// @param array 数据源
/// @param alertBlock 配置其他信息回调
/// @param block 点击回调
+ (instancetype)createAlertViewWithType:(KJAlertViewType)type
                                  title:(NSString *)title
                                content:(NSString *)content
                              dataArray:(NSArray *)array
                             alertBlock:(void(^)(KJAlertView *obj))alertBlock
                              withBlock:(KJAlertBlock)block;

/// 移出
- (void)kj_Dissmiss;

/// 是否关闭BottomTableScroll 默认关闭
@property (nonatomic,assign) BOOL isOpenBottomTableScroll;
@property(nonatomic,strong,readonly) KJAlertView *(^KJBgColor)(UIColor *bgColor);
@property(nonatomic,strong,readonly) KJAlertView *(^KJAddView)(UIView *addView);

/* ************************ 颜色属性，以下属性均有默认值 **************************/
/* 公共颜色属性 */
@property(nonatomic,strong,readonly) KJAlertView *(^KJComColor)(UIColor *lineColor,UIColor *titleColor,UIColor *textColor,UIColor *cancleColor);
/* Center相关颜色属性 */
@property(nonatomic,strong,readonly) KJAlertView *(^KJCenterColor)(UIColor *centerViewColor);
/* Bottom相关属性 */
@property(nonatomic,strong,readonly) KJAlertView *(^KJBottomColor)(UIColor *bottomViewColor,UIColor *spaceColor);
@property(nonatomic,strong,readonly) KJAlertView *(^KJBottomTableH)(CGFloat maxH,CGFloat cellH);

@end

NS_ASSUME_NONNULL_END
