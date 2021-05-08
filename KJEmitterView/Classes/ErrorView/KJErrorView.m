//
//  KJErrorView.m
//  GuessWho
//
//  Created by 杨科军 on 2018/11/20.
//  Copyright © 2018 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "KJErrorView.h"

@interface KJErrorView ()<CAAnimationDelegate>{
    
}

@end

static CGFloat obj_w = 0.0;
static CGFloat obj_h = 0.0;
@implementation KJErrorView

- (void)_config{
    /// 默认显示错误时间
    self.delayTime = 0.5;
    obj_w = self.frame.size.width;
    obj_h = self.frame.size.height;
}

+ (instancetype)createErrorView:(void(^)(KJErrorView *obj))block{
    KJErrorView *obj = [[self alloc] init];
    if (block) {
        block(obj);
    }
    
    [obj _config];
    
    // 初始化背景渐变的天空
    [obj initBackgroundSky];
    
    UIImageView *errView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    errView.center = CGPointMake(obj_w/2, obj_h/2);
    errView.image = [UIImage imageNamed:@"KJErrorView.bundle/error"];
    [obj addSubview:errView];
    
    // 闪烁渐变效果
    [obj viewAnimationOpacity:obj Alpha:0.5 Duration:0.3 TransCount:4 isFlash:YES];
    
    return obj;
}

// 初始化背景天空渐变色
- (void)initBackgroundSky{
    [self GradientLayerDirection:@"top"];
    [self GradientLayerDirection:@"bottom"];
    [self GradientLayerDirection:@"left"];
    [self GradientLayerDirection:@"right"];
}

- (void)GradientLayerDirection:(NSString*)direction{
    CAGradientLayer *backgroundLayer = [[CAGradientLayer alloc] init];
    UIColor *darkColor = UIColor.whiteColor;
    UIColor *lightColor = [UIColor.redColor colorWithAlphaComponent:0.8];
    backgroundLayer.colors = @[(__bridge id)lightColor.CGColor,(__bridge id)darkColor.CGColor];
    if ([direction isEqualToString:@"top"]) {
        backgroundLayer.frame = CGRectMake(0, 0, obj_w/2, obj_h/2);
        backgroundLayer.startPoint = CGPointMake(0, 0);
        backgroundLayer.endPoint = CGPointMake(1, 1);
    }else if ([direction isEqualToString:@"bottom"]) {
        backgroundLayer.frame = CGRectMake(obj_w/2, obj_h/2, obj_w/2, obj_h/2);
        backgroundLayer.endPoint = CGPointMake(0, 0);
        backgroundLayer.startPoint = CGPointMake(1, 1);
    }else if ([direction isEqualToString:@"left"]) {
        backgroundLayer.frame = CGRectMake(0, obj_h/2, obj_w/2, obj_h/2);
        backgroundLayer.startPoint = CGPointMake(0, 1);
        backgroundLayer.endPoint = CGPointMake(1, 0);
    }else if ([direction isEqualToString:@"right"]) {
        backgroundLayer.frame = CGRectMake(obj_w/2, 0, obj_w/2, obj_h/2);
        backgroundLayer.endPoint = CGPointMake(0, 1);
        backgroundLayer.startPoint = CGPointMake(1, 0);
    }
    [self.layer addSublayer:backgroundLayer];
}

// 渐隐  isAlpha:是否为隐藏, Alpha:隐藏系数 Duration:移动持续时间, TransCount:重复次数(0:表示一直转)
- (void)viewAnimationOpacity:(UIView*)myView Alpha:(CGFloat)kj_a Duration:(CGFloat)duration TransCount:(int)num isFlash:(BOOL)flash{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = duration;
    animation.delegate = self;
    animation.repeatCount = num == 0 ? CGFLOAT_MAX : num;
    if (flash) animation.autoreverses = YES;
    animation.toValue = [NSNumber numberWithFloat:kj_a];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    [myView.layer addAnimation:animation forKey:@"op"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, _delayTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - 链接编程设置View的一些属性
- (KJErrorView *(^)(CGRect))KJFrame {
    return ^(CGRect frame) {
        self.frame = frame;
        return self;
    };
}
- (KJErrorView *(^)(UIColor *))KJBackgroundColor {
    return ^(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}
- (KJErrorView *(^)(NSInteger))KJTag {
    return ^(NSInteger tag){
        self.tag = tag;
        return self;
    };
}
- (KJErrorView *(^)(UIView*))KJAddView {
    return ^(UIView *superView){
        [superView addSubview:self];
        return self;
    };
}

@end
