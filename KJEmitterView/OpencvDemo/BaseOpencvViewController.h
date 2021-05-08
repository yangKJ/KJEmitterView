//
//  BaseOpencvViewController.h
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView

#import <UIKit/UIKit.h>
#import "UIImage+KJOpencv.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseOpencvViewController : UIViewController
@property(nonatomic,strong)UIImageView *orignalImageView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UISlider *slider;
@property(nonatomic,strong)UISlider *slider2;
@property(nonatomic,copy,readwrite)void(^kSliderMoving)(CGFloat value);
@property(nonatomic,copy,readwrite)void(^kSliderMoveEnd)(CGFloat value);
@property(nonatomic,copy,readwrite)void(^kSlider2Moving)(CGFloat value);
@property(nonatomic,copy,readwrite)void(^kSlider2MoveEnd)(CGFloat value);
@property(nonatomic,copy,readwrite)void(^kButtonAction)(void);
@end

NS_ASSUME_NONNULL_END
