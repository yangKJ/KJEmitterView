//
//  UIViewController+KJFullScreen.h
//  Winpower
//
//  Created by 杨科军 on 2019/10/10.
//  Copyright © 2019 cq. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  充满全屏处理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (KJFullScreen)<UINavigationControllerDelegate>
/// 顶部控制器
@property(nonatomic,strong,class,readonly)UIViewController *topViewController;
/// 是否开启侧滑返回手势
- (void)kj_openPopGesture:(BOOL)open viewController:(UIViewController*)vc;
/// 跳转回指定控制器
- (BOOL)kj_popTargetViewController:(Class)clazz block:(void(^)(UIViewController *vc))block;
/// 切换根视图控制器
- (void)kj_changeRootViewController:(void(^)(BOOL success))complete;
/// 系统自带分享
- (UIActivityViewController*)kj_shareActivityWithItems:(NSArray*)items complete:(void(^)(BOOL success))complete;

@end

NS_ASSUME_NONNULL_END
