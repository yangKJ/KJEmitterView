//
//  UIButton+KJDoraemonBox.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/15.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UIButton+KJDoraemonBox.h"
#import <objc/runtime.h>

@interface UIButton ()
@property(nonatomic,strong)CAEmitterCell *emitterCell;
@end

@implementation UIButton (KJDoraemonBox)
/// 设置粒子效果
- (void)kj_buttonSetEmitterImage:(UIImage *)image OpenEmitter:(BOOL)open{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(setSelected:)), class_getInstanceMethod(self.class, @selector(kj_setSelected:)));
    });
    self.emitterImage = image?:[UIImage imageNamed:@"KJKit.bundle/button_sparkle"];
    self.openEmitter = open;
    [self setupLayer];
}
/// 方法交换
- (void)kj_setSelected:(BOOL)selected{
    [self kj_setSelected:selected];
    if (self.openEmitter) [self buttonAnimation];
}
#pragma mark - associated
- (UIImage *)emitterImage{
    return objc_getAssociatedObject(self, @selector(emitterImage));
}
- (void)setEmitterImage:(UIImage *)emitterImage{
    objc_setAssociatedObject(self, @selector(emitterImage), emitterImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)openEmitter{
    return [objc_getAssociatedObject(self, @selector(openEmitter)) intValue];
}
- (void)setOpenEmitter:(BOOL)openEmitter{
    objc_setAssociatedObject(self, @selector(openEmitter), @(openEmitter), OBJC_ASSOCIATION_ASSIGN);
}
- (CAEmitterLayer*)explosionLayer{
    return objc_getAssociatedObject(self, @selector(explosionLayer));
}
- (void)setExplosionLayer:(CAEmitterLayer*)explosionLayer{
    objc_setAssociatedObject(self, @selector(explosionLayer), explosionLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CAEmitterCell*)emitterCell{
    return objc_getAssociatedObject(self, @selector(emitterCell));
}
- (void)setEmitterCell:(CAEmitterCell*)emitterCell{
    objc_setAssociatedObject(self, @selector(emitterCell), emitterCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 粒子效果相关
- (void)setupLayer{
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.name = @"name";
    emitterCell.alphaRange = 0.10;
    emitterCell.lifetime = 0.7;
    emitterCell.lifetimeRange = 0.3;
    emitterCell.velocity = 40.00;
    emitterCell.velocityRange = 10.00;
    emitterCell.scale = 0.04;
    emitterCell.scaleRange = 0.02;
    emitterCell.contents = (id)self.emitterImage.CGImage;
    self.emitterCell = emitterCell;
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.name = @"emitterLayer";
    emitterLayer.emitterShape = kCAEmitterLayerCircle;
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    emitterLayer.emitterSize = CGSizeMake(10, 0);
    emitterLayer.emitterCells = @[emitterCell];
    emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    emitterLayer.position = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    emitterLayer.zPosition = -1;
    [self.layer addSublayer:emitterLayer];
    self.explosionLayer = emitterLayer;
}
/// 开始动画
- (void)buttonAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (self.selected) {
        animation.values = @[@1.5 ,@0.8, @1.0,@1.2,@1.0];
        animation.duration = 0.4;
        self.explosionLayer.beginTime = CACurrentMediaTime();
        [self.explosionLayer setValue:@2000 forKeyPath:@"emitterCells.name.birthRate"];
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.2];
    }else{
        animation.values = @[@0.8, @1.0];
        animation.duration = 0.2;
    }
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
}
/// 停止喷射
- (void)stop {
    [self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.name.birthRate"];
}

#pragma mark - 倒计时
- (void)kj_startTime:(NSInteger)timeout CountDownFormat:(NSString *)format{
    [self kj_cancelTimer];
    self.timeOut = timeout;
    self.xxtitle = self.titleLabel.text;
    NSDictionary *info = @{@"countDownFormat":format ?: @"%zd秒"};
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod:) userInfo:info repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTitle:[NSString stringWithFormat:format ?: @"%zd秒",timeout] forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;
    });
}
- (void)timerMethod:(NSTimer*)timer{
    NSDictionary *info = timer.userInfo;
    NSString *countDownFormat = info[@"countDownFormat"];
    if (self.timeOut <= 0){
        [self kj_cancelTimer];
    }else{
        self.timeOut--;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:[NSString stringWithFormat:countDownFormat,self.timeOut] forState:UIControlStateNormal];
            self.userInteractionEnabled = NO;
        });
    }
}
/// 取消倒计时
- (void)kj_cancelTimer{
    if (self.timer == nil) return;
    [self.timer invalidate];
    self.timer = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTitle:self.xxtitle forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        if (self.kButtonCountDownStop) { self.kButtonCountDownStop(); }
    });
}
#pragma mark - associated
- (NSTimer*)timer{
    return objc_getAssociatedObject(self, @selector(timer));
}
- (void)setTimer:(NSTimer*)timer{
    objc_setAssociatedObject(self, @selector(timer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)xxtitle{
    return objc_getAssociatedObject(self, @selector(xxtitle));
}
- (void)setXxtitle:(NSString *)xxtitle{
    objc_setAssociatedObject(self, @selector(xxtitle), xxtitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setKButtonCountDownStop:(void(^)(void))kButtonCountDownStop{
    objc_setAssociatedObject(self, @selector(kButtonCountDownStop), kButtonCountDownStop, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void(^)(void))kButtonCountDownStop{
    return objc_getAssociatedObject(self, @selector(kButtonCountDownStop));
}
- (NSInteger)timeOut{
    return [objc_getAssociatedObject(self, @selector(timeOut)) integerValue];
}
- (void)setTimeOut:(NSInteger)timeOut{
    objc_setAssociatedObject(self, @selector(timeOut), @(timeOut), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 指示器
static NSString *kIndicatorLastTitle = nil;
- (void)kj_beginSubmitting:(NSString *)title{
    [self kj_endSubmitting];
    kSubmitting = true;
    kIndicatorLastTitle = self.titleLabel.text;
    self.enabled = NO;
    [self setTitle:@"" forState:UIControlStateNormal];
    
    self.indicatorType = self.indicatorType?:UIActivityIndicatorViewStyleWhite;
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.indicatorType];
    [self addSubview:self.indicatorView];
    
    self.indicatorSpace = self.indicatorSpace?:5;
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat sp = w / 2.;
    if (![title isEqualToString:@""]) {
        self.indicatorLabel = [[UILabel alloc] init];
        self.indicatorLabel.text = title;
        self.indicatorLabel.font = self.titleLabel.font;
        self.indicatorLabel.textColor = self.titleLabel.textColor;
        [self addSubview:self.indicatorLabel];
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT,0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
        sp = ((w-self.indicatorSpace-size.width)*.5)?:0.0;
        self.indicatorLabel.frame = CGRectMake(sp+self.indicatorSpace+self.indicatorView.frame.size.width/2, 0, size.width, h);
    }
    
    self.indicatorView.center = CGPointMake(sp, h/2);
    [self.indicatorView startAnimating];
}

- (void)kj_endSubmitting {
    [self kj_hideIndicator];
    self.indicatorView = nil;
    self.indicatorLabel = nil;
}

- (void)kj_showIndicator {
    if (self.indicatorView && self.indicatorView.superview == nil) {
        [self addSubview:self.indicatorView];
        [self.indicatorView startAnimating];
    }
    if (self.indicatorLabel && self.indicatorLabel.superview == nil) {
        [self addSubview:self.indicatorLabel];
        [self setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)kj_hideIndicator {
    kSubmitting = false;
    self.enabled = YES;
    
    [self.indicatorView removeFromSuperview];
    [self.indicatorLabel removeFromSuperview];
    
    if (self.indicatorLabel) {
        [self setTitle:kIndicatorLastTitle forState:UIControlStateNormal];
    }
    if (self.indicatorView) {
        [self.indicatorView stopAnimating];
        [self setTitle:kIndicatorLastTitle forState:UIControlStateNormal];
    }
}

#pragma mark - associated
static bool kSubmitting = false;
- (bool)submitting{
    return kSubmitting;
}
- (CGFloat)indicatorSpace{
    return [objc_getAssociatedObject(self, @selector(indicatorSpace)) floatValue];
}
- (void)setIndicatorSpace:(CGFloat)indicatorSpace{
    objc_setAssociatedObject(self, @selector(indicatorSpace), @(indicatorSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIActivityIndicatorViewStyle)indicatorType{
    return (UIActivityIndicatorViewStyle)[objc_getAssociatedObject(self, @selector(indicatorType)) intValue];
}
- (void)setIndicatorType:(UIActivityIndicatorViewStyle)indicatorType{
    objc_setAssociatedObject(self, @selector(indicatorType), @(indicatorType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIActivityIndicatorView*)indicatorView{
    return objc_getAssociatedObject(self, @selector(indicatorView));
}
- (void)setIndicatorView:(UIActivityIndicatorView*)indicatorView{
    objc_setAssociatedObject(self, @selector(indicatorView), indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel*)indicatorLabel{
    return objc_getAssociatedObject(self, @selector(indicatorLabel));
}
- (void)setIndicatorLabel:(UILabel*)indicatorLabel{
    objc_setAssociatedObject(self, @selector(indicatorLabel), indicatorLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
