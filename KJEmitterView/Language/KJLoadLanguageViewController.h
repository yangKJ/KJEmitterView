//
//  KJLoadLanguageViewController.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/3.
//  https://github.com/yangKJ/KJEmitterView

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJLoadLanguageViewController : UIViewController

@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;
@property(nonatomic,assign)CGFloat time;
@property(nonatomic,readwrite,copy)void(^loadEnd)(void);

@end

NS_ASSUME_NONNULL_END
