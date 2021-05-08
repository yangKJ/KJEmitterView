//
//  UIResponder+KJAdapt.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/14.
//  https://github.com/yangKJ/KJEmitterView
//  简单的屏幕比例适配

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 适配类型 设计图类型
typedef NS_ENUM(NSInteger, KJAdaptModelType) {
    KJAdaptTypeIPhone4 = 0, /// 3.5英寸，320 x 480pt
    KJAdaptTypeIPhone5,     /// 4.0英寸，320 x 568pt
    KJAdaptTypeIPhone6,     /// 4.7英寸，375 x 667pt
    KJAdaptTypeIPhone6P,    /// 5.5英寸，414 x 736pt
    KJAdaptTypeIPhoneX,     /// 5.8英寸，375 x 812pt
    KJAdaptTypeIPhoneXR,    /// 6.1英寸，414 x 896pt
    KJAdaptTypeIPhoneXSMax, /// 6.5英寸，414 x 896pt
//    KJAdaptTypeIPhone12Mini,/// 5.4英寸，
//    KJAdaptTypeIPhone12ProMax,/// 6.7英寸，
};
@protocol KJResponderAdaptProtocol <NSObject>
/// 设计图机型，只需要在最初的地方调用一次即可
+ (void)kj_adaptModelType:(KJAdaptModelType)type;
@end
@interface UIResponder (KJAdapt)<KJResponderAdaptProtocol>
/// 水平比例适配
CGFloat KJAdaptScaleLevel(CGFloat level);
/// 竖直比例适配，取值为水平比例适配
CGFloat KJAdaptScaleVertical(CGFloat vertical);
/// 适配CGpoint
CGPoint KJAdaptPointMake(CGFloat x, CGFloat y);
/// 适配CGSize
CGSize KJAdaptSizeMake(CGFloat width, CGFloat height);
/// 适配CGRect
CGRect KJAdaptRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
/// 适配UIEdgeInsets
UIEdgeInsets KJAdaptEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

/*
 在最初的地方AppDelegate里面调用 [UIResponder kj_adaptModelType:KJAdaptTypeIPhone6];
 然后在需要适配的地方 替换 CGRectMake 为 KJAdaptRectMake
 view.frame = CGRectMake(0, 0, 10, 10);
 view.frame = KJAdaptRectMake(0, 0, 10, 10);
 即可完成简单的屏幕比例适配
*/

#pragma mark - 响应链板块
/// 获取第一响应者
- (UIResponder*)kj_responderWithClass:(Class)clazz;
///
- (BOOL)kj_responderSendAction:(SEL)action Sender:(id)sender;


@end

NS_ASSUME_NONNULL_END
