//
//  KJSelectControl.m
//  Demo
//
//  Created by 杨科军 on 2018/7/25.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "KJSelectControl.h"

static CGFloat finalStrokeEndWithHook = 0.85;
static CGFloat finalStrokeStartWithHook = 0.3;
static CGFloat hookBounceAmount = 0.1;

@interface KJSelectControl (){
    CAShapeLayer *tempCircle, *circle, *hook; /// 中转圆, 圆, 勾勾
    CGPoint HookPoint;
    BOOL isSelect;
}

@end

@implementation KJSelectControl

- (instancetype)init{
    if (self = [super init]) {
        [self configure];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configure];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
}

- (void)configure{
    isSelect = NO;
    self.backgroundColor = UIColor.clearColor;
    tempCircle = [CAShapeLayer layer];
    circle = [CAShapeLayer layer];
    hook = [CAShapeLayer layer];
    HookPoint = CGPointZero;
    _animationDuration = 0.3;
    self.lineWidth = 2.0;
    self.selectHookColor = UIColor.blueColor;
    _selectedLineColor = UIColor.blueColor;
    _unselectedLineColor = UIColor.blueColor;
    self.kType = KJSelectControlTypeHook;
    /// 临时圆
    tempCircle.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:tempCircle];
    /// 外圈圆
    circle.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:circle];
    /// 内部
    [self.layer addSublayer:hook];
    [self addTarget:self action:@selector(kTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - getter/setter
- (BOOL)isSelected{
    return isSelect;
}
- (void)setSelected:(BOOL)selected{
    [self setSelected:selected animated:NO];
    self.selectedLineColor = _selectedLineColor;
    self.unselectedLineColor = _unselectedLineColor;
}

#pragma mark - xib setters
- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    circle.lineWidth = lineWidth;
    tempCircle.lineWidth = lineWidth;
    hook.lineWidth = lineWidth;
}
- (void)setSelectHookColor:(UIColor *)selectHookColor{
    _selectHookColor = selectHookColor;
    hook.strokeColor = selectHookColor.CGColor;
}
- (void)setSelectedLineColor:(UIColor *)selectedLineColor{
    _selectedLineColor = selectedLineColor;
    if (isSelect) {
        circle.strokeColor = selectedLineColor.CGColor;
        tempCircle.strokeColor = selectedLineColor.CGColor;
    }
}
- (void)setUnselectedLineColor:(UIColor *)unselectedLineColor{
    _unselectedLineColor = unselectedLineColor;
    if (!isSelect) {
        circle.strokeColor = unselectedLineColor.CGColor;
        tempCircle.strokeColor = unselectedLineColor.CGColor;
    }
}
- (void)setKType:(KJSelectControlType)kType{
    _kType = kType;
    CGPoint offset = CGPointZero;
    CGFloat radius = fmin(self.bounds.size.width, self.bounds.size.height) / 2;
    offset.x = self.bounds.size.width / 2 - radius;
    offset.y = self.bounds.size.height / 2 - radius;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGRect circleRect = CGRectMake(offset.x, offset.y, radius * 2, radius * 2);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    tempCircle.path = circlePath.CGPath;
    circle.transform = CATransform3DIdentity;
    circle.frame = self.bounds;
    circle.path = [UIBezierPath bezierPathWithOvalInRect:circleRect].CGPath;
    circle.transform = CATransform3DMakeRotation((CGFloat)(212 * M_PI / 180), 0, 0, 1);
    
    if (_kType == KJSelectControlTypeHook) {
        CGPoint origin = CGPointMake(offset.x + radius, offset.y + radius);
        CGPoint HookStartPoint = CGPointZero;
        HookStartPoint.x = origin.x + radius * cos(212 * M_PI / 180.0);
        HookStartPoint.y = origin.y + radius * sin(212 * M_PI / 180.0);
        UIBezierPath *HookPath = [UIBezierPath bezierPath];
        [HookPath moveToPoint:HookStartPoint];
        HookPoint = CGPointMake(offset.x + radius * 0.9, offset.y + radius * 1.4);
        [HookPath addLineToPoint:HookPoint];
        CGPoint HookEndPoint = CGPointZero;
        HookEndPoint.x = origin.x + radius * cos(320 * M_PI / 180.0);
        HookEndPoint.y = origin.y + radius * sin(320 * M_PI / 180.0);
        [HookPath addLineToPoint:HookEndPoint];
        hook.frame = self.bounds;
        hook.path = HookPath.CGPath;
        hook.fillColor = [UIColor clearColor].CGColor;
    }
    else if (_kType == KJSelectControlTypeSolidCircle){
        CGFloat HookRadius = radius * 0.75;
        CGRect HookRect = CGRectMake(self.bounds.size.width / 2 - HookRadius, self.bounds.size.height / 2  - HookRadius, HookRadius * 2, HookRadius * 2);
        hook.frame = self.bounds;
        hook.path = [UIBezierPath bezierPathWithOvalInRect:HookRect].CGPath;
        hook.fillColor = _selectHookColor.CGColor;
        hook.lineWidth = 0;
    }
    [CATransaction commit];
}

#pragma mark - 内部方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    isSelect = selected;
    [hook removeAllAnimations];
    [circle removeAllAnimations];
    [tempCircle removeAllAnimations];
    [self resetValues:animated];
    if (animated) {
        [self addAnimationsForSelected:isSelect];
    }
}
- (void)resetValues:(BOOL)animated{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if ((isSelect && animated) || (isSelect == NO && animated == NO))  {
        hook.strokeEnd = 0.0;
        hook.strokeStart = 0.0;
        tempCircle.opacity = 0.0;
        circle.strokeStart = 0.0;
        circle.strokeEnd = 1.0;
        circle.strokeColor = _selectedLineColor.CGColor;
        tempCircle.strokeColor = _selectedLineColor.CGColor;
    }
    else{
        hook.strokeEnd = finalStrokeEndWithHook;
        hook.strokeStart = finalStrokeStartWithHook;
        tempCircle.opacity = 1.0;
        circle.strokeStart = 0.0;
        circle.strokeEnd = 0.0;
        circle.strokeColor = _unselectedLineColor.CGColor;
        tempCircle.strokeColor = _unselectedLineColor.CGColor;
    }
    [CATransaction commit];
}

/// 修改动画实现
- (void)addAnimationsForSelected:(BOOL)selected{
    /// 外圈圆动画
    CFTimeInterval circleAnimationDuration = self.animationDuration * 0.5;
    CAAnimationGroup *circleAnimationGroup = [CAAnimationGroup animation];
    circleAnimationGroup.duration = self.animationDuration;
    circleAnimationGroup.removedOnCompletion = false;
    circleAnimationGroup.fillMode = kCAFillModeForwards;
    circleAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *circleStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleStrokeEnd.duration = circleAnimationDuration;
    if (selected) {
        circleStrokeEnd.beginTime = 0.0;
        circleStrokeEnd.fromValue = [NSNumber numberWithFloat:1.0];
        circleStrokeEnd.toValue = [NSNumber numberWithFloat: -0.1];
    }
    else {
        circleStrokeEnd.beginTime = self.animationDuration - circleAnimationDuration;
        circleStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0];
        circleStrokeEnd.toValue = [NSNumber numberWithFloat:1.0];
    }
    circleStrokeEnd.removedOnCompletion = false;
    circleStrokeEnd.fillMode = kCAFillModeForwards;
    
    circleAnimationGroup.animations = @[circleStrokeEnd];
    [circle addAnimation:circleAnimationGroup forKey:@"circleStrokeEnd"];
    
    CABasicAnimation *tempCircleColor = [CABasicAnimation animationWithKeyPath:@"opacity"];
    tempCircleColor.duration = self.animationDuration;
    if (selected) {
        tempCircleColor.fromValue = [NSNumber numberWithFloat:0.0];
        tempCircleColor.toValue = [NSNumber numberWithFloat:1.0];
    } else {
        tempCircleColor.fromValue = [NSNumber numberWithFloat:1.0];
        tempCircleColor.toValue = [NSNumber numberWithFloat:0.0];
    }
    tempCircleColor.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    tempCircleColor.fillMode = kCAFillModeForwards;
    tempCircleColor.removedOnCompletion = false;
    [tempCircle addAnimation:tempCircleColor forKey:@"trailCircleColor"];
    
    if (_kType == KJSelectControlTypeHook) {
        /// 打勾勾动画
        CFTimeInterval hookEndDuration = self.animationDuration * 0.8;
        CFTimeInterval hookStartDuration = hookEndDuration - circleAnimationDuration;
        CFTimeInterval hookBounceDuration = self.animationDuration - hookEndDuration;
        
        CAAnimationGroup *hookAnimationGroup = [CAAnimationGroup animation];
        hookAnimationGroup.removedOnCompletion = false;
        hookAnimationGroup.fillMode = kCAFillModeForwards;
        hookAnimationGroup.duration = self.animationDuration;
        hookAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAKeyframeAnimation *HookStrokeEnd = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        HookStrokeEnd.duration = hookEndDuration + hookBounceDuration;
        HookStrokeEnd.removedOnCompletion = false;
        HookStrokeEnd.fillMode = kCAFillModeForwards;
        HookStrokeEnd.calculationMode = kCAAnimationPaced;
        
        if (selected) {
            HookStrokeEnd.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:finalStrokeEndWithHook + hookBounceAmount], [NSNumber numberWithFloat:finalStrokeEndWithHook], nil];
            HookStrokeEnd.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithDouble:0.0], [NSNumber numberWithDouble:hookEndDuration], [NSNumber numberWithDouble:hookEndDuration + hookBounceDuration], nil];
        } else {
            HookStrokeEnd.values = [NSArray arrayWithObjects:  [NSNumber numberWithFloat:finalStrokeEndWithHook], [NSNumber numberWithFloat:finalStrokeEndWithHook + hookBounceAmount], [NSNumber numberWithFloat:-0.1], nil];
            HookStrokeEnd.keyTimes = [NSArray arrayWithObjects:  [NSNumber numberWithDouble:0.0], [NSNumber numberWithDouble:hookBounceDuration], [NSNumber numberWithDouble:hookEndDuration + hookBounceDuration], nil];
        }
        
        CAKeyframeAnimation *HookStrokeStart = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
        HookStrokeStart.duration = hookStartDuration + hookBounceDuration;
        HookStrokeStart.removedOnCompletion = false;
        HookStrokeStart.fillMode = kCAFillModeForwards;
        HookStrokeStart.calculationMode = kCAAnimationPaced;
        
        if (selected) {
            HookStrokeStart.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:finalStrokeStartWithHook + hookBounceAmount], [NSNumber numberWithFloat:finalStrokeStartWithHook], nil];
            HookStrokeStart.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithDouble:0.0], [NSNumber numberWithDouble:hookStartDuration], [NSNumber numberWithDouble:hookStartDuration + hookBounceDuration], nil];
        }
        else {
            HookStrokeStart.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:finalStrokeStartWithHook], [NSNumber numberWithFloat:finalStrokeStartWithHook + hookBounceAmount], [NSNumber numberWithFloat:0.0], nil];
            HookStrokeStart.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithDouble:0.0], [NSNumber numberWithDouble:hookBounceDuration], [NSNumber numberWithDouble:hookStartDuration + hookBounceDuration], nil];
        }
        if (selected) {
            HookStrokeStart.beginTime = circleAnimationDuration;
        }
        
        hookAnimationGroup.animations = @[HookStrokeEnd, HookStrokeStart];
        [hook addAnimation:hookAnimationGroup forKey:@"checkmarkAnimation"];
    }
    else if (_kType == KJSelectControlTypeSolidCircle){
        CABasicAnimation *solidCircleColor = [CABasicAnimation animationWithKeyPath:@"opacity"];
        solidCircleColor.duration = self.animationDuration * 0.5;
        if (!selected) {
            solidCircleColor.fromValue = [NSNumber numberWithFloat:1.0];
            solidCircleColor.toValue = [NSNumber numberWithFloat:0.0];
        } else {
            solidCircleColor.fromValue = [NSNumber numberWithFloat:0.0];
            solidCircleColor.toValue = [NSNumber numberWithFloat:1.0];
        }
        solidCircleColor.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        solidCircleColor.fillMode = kCAFillModeForwards;
        solidCircleColor.removedOnCompletion = false;
        [hook addAnimation:solidCircleColor forKey:@"trailCircleColor"];
    }
}

#pragma mark - Actions
- (void)kTouchUpInside{
    BOOL cs = !self.selected;
    [self setSelected:cs animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (self.delegate || [self.delegate respondsToSelector:@selector(kj_selectActionWithControl:selected:)]) {
        [self.delegate kj_selectActionWithControl:self selected:cs];
    }
}

@end

