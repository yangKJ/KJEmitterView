//
//  KJSwitchControl.m
//  Demo
//
//  Created by 杨科军 on 2018/7/25.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "KJSwitchControl.h"

NSString * const FaceMoveAnimationKey = @"FaceMoveAnimationKey";
NSString * const BackgroundColorAnimationKey = @"BackgroundColorAnimationKey";
NSString * const EyesMoveStartAnimationKey = @"EyesMoveStartAnimationKey";
NSString * const EyesMoveEndAnimationKey = @"EyesMoveEndAnimationKey";
NSString * const EyesMoveBackAnimationKey = @"EyesMoveBackAnimationKey";
NSString * const MouthFrameAnimationKey = @"MouthFrameAnimationKey";
NSString * const EyesCloseAndOpenAnimationKey = @"EyesCloseAndOpenAnimationKey";

/* ******************************** 笑脸Layer ************************************/
@interface KJFaceLayer : CALayer
@property(nonatomic,assign) CGRect eyeRect;
@property(nonatomic,assign) CGFloat eyeDistance;
@property(nonatomic,strong) UIColor *eyeColor;
@property(nonatomic,assign) BOOL isLiking;
@property(nonatomic,assign) CGFloat mouthOffSet;
@property(nonatomic,assign) CGFloat mouthY;

@end

@implementation KJFaceLayer

- (instancetype)init {
    if (self = [super init]) {
        // 默认属性
        _eyeRect = CGRectMake(0, 0, 0, 0);
        _mouthOffSet = 0.f;
    }
    return self;
}

- (instancetype)initWithLayer:(KJFaceLayer *)layer {
    if (self = [super initWithLayer:layer]) {
        self.eyeRect = layer.eyeRect;
        self.eyeDistance = layer.eyeDistance;
        self.eyeColor = layer.eyeColor;
        self.isLiking = layer.isLiking;
        self.mouthOffSet = layer.mouthOffSet;
        self.mouthY = layer.mouthY;
    }
    return self;
}

/// draw
- (void)drawInContext:(CGContextRef)ctx {
    UIBezierPath *bezierLeft = [UIBezierPath bezierPathWithOvalInRect:_eyeRect];
    UIBezierPath *bezierRight = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_eyeDistance, _eyeRect.origin.y, _eyeRect.size.width, _eyeRect.size.height)];
    UIBezierPath *bezierMouth = [UIBezierPath bezierPath];
    CGFloat mouthWidth = _eyeRect.size.width + _eyeDistance;
    if (_isLiking) {
        // funny mouth
        [bezierMouth moveToPoint:CGPointMake(0, _mouthY)];
        [bezierMouth addCurveToPoint:CGPointMake(mouthWidth, _mouthY) controlPoint1:CGPointMake(mouthWidth - _mouthOffSet * 3 / 4, _mouthY + _mouthOffSet / 2) controlPoint2:CGPointMake(mouthWidth - _mouthOffSet / 4, _mouthY + _mouthOffSet / 2)];
    } else {
        // boring mouth
        bezierMouth = [UIBezierPath bezierPathWithRect:CGRectMake(0, _mouthY, mouthWidth, _eyeRect.size.height / 4)];
    }
    
    [bezierMouth closePath];
    CGContextAddPath(ctx, bezierLeft.CGPath);
    CGContextAddPath(ctx, bezierRight.CGPath);
    CGContextAddPath(ctx, bezierMouth.CGPath);
    CGContextSetFillColorWithColor(ctx, _eyeColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextFillPath(ctx);
}

/// key animation
+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqual:@"mouthOffSet"]) {
        return YES;
    }
    if ([key isEqual:@"eyeRect"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

@end


@interface KJSwitchControl()<CAAnimationDelegate>

/// switch background view
@property(nonatomic,strong) UIView *backgroundView;
/// face layer
@property(nonatomic,strong) CAShapeLayer *circleFaceLayer;
/// paddingWidth
@property(nonatomic,assign) CGFloat paddingWidth;
/// eyes layer
@property(nonatomic,strong) KJFaceLayer *eyesLayer;
/// face radius
@property(nonatomic,assign) CGFloat circleFaceRadius;
/// the faceLayer move distance
@property(nonatomic,assign) CGFloat moveDistance;
/// whether is animated
@property(nonatomic,assign) BOOL isAnimating;
/// 笑脸Layer宽度
@property(nonatomic,assign) CGFloat faceLayerWidth;

@end


@implementation KJSwitchControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure{
    /// check the switch width and height
    NSAssert(self.frame.size.width >= self.frame.size.height, @"width must be tall");
    
    /// init property
    _onColor = [UIColor colorWithRed:73/255.0 green:182/255.0 blue:235/255.0 alpha:1.f];
    _offColor = [UIColor colorWithRed:211/255.0 green:207/255.0 blue:207/255.0 alpha:1.f];
    _faceColor = UIColor.whiteColor;
    _paddingWidth = self.frame.size.height * 0.1;
    _circleFaceRadius = (self.frame.size.height - 2 * _paddingWidth) / 2;
    _animationDuration = 1.2f;
    _moveDistance = self.frame.size.width - _paddingWidth * 2 - _circleFaceRadius * 2;
    _on = NO;
    _isAnimating = NO;
    
    /// setting init property
    self.backgroundView.backgroundColor = _offColor;
    self.circleFaceLayer.fillColor = _faceColor.CGColor;
    self.faceLayerWidth = self.circleFaceLayer.frame.size.width;
    [self.eyesLayer setNeedsDisplay];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSwitch)]];
}


#pragma mark - set property
- (void)setOffColor:(UIColor *)offColor {
    _offColor = offColor;
    if (!_on) {
        _backgroundView.backgroundColor = offColor;
        _eyesLayer.eyeColor = offColor;
        [self.eyesLayer setNeedsDisplay];
    }
}

- (void)setOnColor:(UIColor *)onColor {
    _onColor = onColor;
    if (_on) {
        _backgroundView.backgroundColor = onColor;
        _eyesLayer.eyeColor = onColor;
        [self.eyesLayer setNeedsDisplay];
    }
}

- (void)setFaceColor:(UIColor *)faceColor {
    _faceColor = faceColor;
    _circleFaceLayer.fillColor = faceColor.CGColor;
}

- (void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
}

- (void)setOn:(BOOL)on {
    if ((_on && on) || (!_on && !on)) {
        return;
    }
    _on = on;
    if (on) {
        [self.backgroundView.layer removeAllAnimations];
        self.backgroundView.backgroundColor = _onColor;
        [self.circleFaceLayer removeAllAnimations];
        self.circleFaceLayer.position = CGPointMake(self.circleFaceLayer.position.x + _moveDistance, self.circleFaceLayer.position.y);
        self.eyesLayer.eyeColor = _onColor;
        self.eyesLayer.isLiking = YES;
        self.eyesLayer.mouthOffSet = _eyesLayer.frame.size.width;
        [self.eyesLayer needsDisplay];
    } else {
        [self.backgroundView.layer removeAllAnimations];
        self.backgroundView.backgroundColor = _offColor;
        [self.circleFaceLayer removeAllAnimations];
        self.circleFaceLayer.position = CGPointMake(self.circleFaceLayer.position.x - _moveDistance, self.circleFaceLayer.position.y);
        self.eyesLayer.eyeColor = _offColor;
        self.eyesLayer.isLiking = NO;
        self.eyesLayer.mouthOffSet = 0;
        [self.eyesLayer needsDisplay];
    }
}

- (void)setSwitchControlIsOn:(BOOL)on animated:(BOOL)animated {
    if ((_on && on)||(!_on && !on)) {
        return;
    }
    if (animated) {
        [self handleTapSwitch];
    } else {
        [self setOn:on];
    }
}


#pragma mark - GestureRecognizer
- (void)handleTapSwitch {
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    // faceLayer
    CABasicAnimation *moveAnimation = [self moveAnimationWithFromPosition:_circleFaceLayer.position toPosition:_on ? CGPointMake(_circleFaceLayer.position.x - _moveDistance, _circleFaceLayer.position.y) : CGPointMake(_circleFaceLayer.position.x + _moveDistance, _circleFaceLayer.position.y)];
    moveAnimation.delegate = self;
    [_circleFaceLayer addAnimation:moveAnimation forKey:FaceMoveAnimationKey];
    
    // backfroundView
    CABasicAnimation *colorAnimation = [self backgroundColorAnimationFromValue:(id)(_on ? _onColor : _offColor).CGColor toValue:(id)(_on ? _offColor : _onColor).CGColor];
    [_backgroundView.layer addAnimation:colorAnimation forKey:BackgroundColorAnimationKey];
    
    // eyesLayer
    CABasicAnimation *rotationAnimation = [self eyeMoveAnimationFromValue:@(0) toValue:@(_on ? -_faceLayerWidth : _faceLayerWidth)];
    rotationAnimation.delegate = self;
    [_eyesLayer addAnimation:rotationAnimation forKey:EyesMoveStartAnimationKey];
    _circleFaceLayer.masksToBounds = YES;
    if (_on) {
        [self eyesKeyFrameAnimationStart];
    }
    // start delegate
    if ([self.delegate respondsToSelector:@selector(kAnimationStartSwitchControl:)]) {
        [self.delegate kAnimationStartSwitchControl:self];
    }
}

#pragma mark - lazy
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.frame = self.bounds;
        _backgroundView.layer.cornerRadius = self.frame.size.height / 2;
        _backgroundView.layer.masksToBounds = YES;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (CAShapeLayer *)circleFaceLayer {
    if (!_circleFaceLayer) {
        _circleFaceLayer = [CAShapeLayer layer];
        [_circleFaceLayer setFrame:CGRectMake(_paddingWidth, _paddingWidth, _circleFaceRadius * 2, _circleFaceRadius *2)];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:_circleFaceLayer.bounds];
        _circleFaceLayer.path = circlePath.CGPath;
        [self.backgroundView.layer addSublayer:_circleFaceLayer];
    }
    return _circleFaceLayer;
}

- (KJFaceLayer *)eyesLayer {
    if (!_eyesLayer) {
        _eyesLayer = [KJFaceLayer layer];
        _eyesLayer.eyeRect = CGRectMake(0, 0, _faceLayerWidth / 6, _circleFaceLayer.frame.size.height * 0.22);
        _eyesLayer.eyeDistance = _faceLayerWidth / 3;
        _eyesLayer.eyeColor = _offColor;
        _eyesLayer.isLiking = NO;
        _eyesLayer.mouthY = _eyesLayer.eyeRect.size.height * 7 / 4;
        _eyesLayer.frame = CGRectMake(_faceLayerWidth / 4, _circleFaceLayer.frame.size.height * 0.28, _faceLayerWidth / 2, _circleFaceLayer.frame.size.height * 0.72);
        [self.circleFaceLayer addSublayer:_eyesLayer];
        
    }
    return  _eyesLayer;
}

#pragma mark - AnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        // start eyes ending animation
        if (anim == [_eyesLayer animationForKey:EyesMoveStartAnimationKey]) {
            _eyesLayer.eyeColor = _on ?  _offColor: _onColor;
            _eyesLayer.isLiking = !_on;
            _backgroundView.backgroundColor = _eyesLayer.eyeColor;
            [_eyesLayer setNeedsDisplay];
            [_backgroundView setNeedsDisplay];
            CABasicAnimation *rotationAnimation = [self eyeMoveAnimationFromValue:@(_on ? _faceLayerWidth : -_faceLayerWidth) toValue:@(_on ? -_faceLayerWidth / 6 :  _faceLayerWidth / 6)];
            rotationAnimation.delegate = self;
            [_eyesLayer addAnimation:rotationAnimation forKey:EyesMoveEndAnimationKey];
            if (!_on) {
                [self eyesKeyFrameAnimationStart];
            }
        }
        
        // start eyes back animation
        if (anim == [_eyesLayer animationForKey:EyesMoveEndAnimationKey]) {
            CABasicAnimation *rotationAnimation = [self eyeMoveAnimationFromValue:@(_on ? -_faceLayerWidth / 6 :  _faceLayerWidth / 6) toValue:@(0)];
            rotationAnimation.delegate = self;
            [_eyesLayer addAnimation:rotationAnimation forKey:EyesMoveBackAnimationKey];
            if (!_on) {
                CAKeyframeAnimation *eyesKeyFrameAnimation = [self eyesCloseAndOpenAnimationWithRect:_eyesLayer.eyeRect];
                [_eyesLayer addAnimation:eyesKeyFrameAnimation forKey:EyesCloseAndOpenAnimationKey];
            }
        }
        
        // eyes back animation end
        if (anim == [_eyesLayer animationForKey:EyesMoveBackAnimationKey]) {
            _eyesLayer.mouthOffSet = _on ? 0 : _eyesLayer.frame.size.width;
            
            if (_on) {
                _circleFaceLayer.position = CGPointMake(_circleFaceLayer.position.x - _moveDistance, _circleFaceLayer.position.y);
                _on = NO;
            } else {
                _circleFaceLayer.position = CGPointMake(_circleFaceLayer.position.x + _moveDistance, _circleFaceLayer.position.y);
                _on = YES;
            }
            _isAnimating = NO;
            // stop delegate
            if ([self.delegate respondsToSelector:@selector(kAnimationDidStopWithKSwitchControl:)]) {
                [self.delegate kAnimationDidStopWithKSwitchControl:self];
            }
            
            // valueChanged
            if ([self.delegate respondsToSelector:@selector(kValueDidChangedWithSwitchControl:on:)]) {
                [self.delegate kValueDidChangedWithSwitchControl:self on:self.on];
            }
            
            [self.eyesLayer removeAllAnimations];
            [self.circleFaceLayer removeAllAnimations];
            [self.backgroundView.layer removeAllAnimations];
        }
    }
}

/// add mouth keyFrameAnimation
- (void)eyesKeyFrameAnimationStart {
    CAKeyframeAnimation *keyAnimation = [self mouthKeyFrameAnimationWidthOffSet:_eyesLayer.frame.size.width on:_on];
    [_eyesLayer addAnimation:keyAnimation forKey:MouthFrameAnimationKey];
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - 动画方法
/// faceLayer move animation
- (CABasicAnimation *)moveAnimationWithFromPosition:(CGPoint)fromPosition toPosition:(CGPoint)toPosition {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    moveAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    moveAnimation.duration = _animationDuration * 2 /3;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    return moveAnimation;
}

/// layer background color animation
- (CABasicAnimation *)backgroundColorAnimationFromValue:(NSValue *)fromValue toValue:(NSValue *)toValue {
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.fromValue = fromValue;
    colorAnimation.toValue = toValue;
    colorAnimation.duration = _animationDuration * 2 /3;
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.fillMode = kCAFillModeForwards;
    return colorAnimation;
}

/// the eyes layer move
- (CABasicAnimation *)eyeMoveAnimationFromValue:(NSValue *)fromValue toValue:(NSValue *)toValue{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    moveAnimation.fromValue = fromValue;
    moveAnimation.toValue = toValue;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    moveAnimation.duration = _animationDuration / 3;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    return moveAnimation;
}

/// mouth key frame animation
- (CAKeyframeAnimation *)mouthKeyFrameAnimationWidthOffSet:(CGFloat)offSet on:(BOOL)on{
    CGFloat frameNumber = _animationDuration * 60 / 3;
    CGFloat frameValue = on ? offSet : 0;
    NSMutableArray *arrayFrame = [NSMutableArray array];
    for (int i = 0; i < frameNumber; i++) {
        if (on) {
            frameValue = frameValue - offSet / frameNumber;
        } else {
            frameValue = frameValue + offSet / frameNumber;
        }
        [arrayFrame addObject:@(frameValue)];
    }
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"mouthOffSet"];
    keyAnimation.values = arrayFrame;
    keyAnimation.duration = _animationDuration / 4;
    if (!on && _animationDuration >= 1.f) {
        keyAnimation.beginTime = CACurrentMediaTime() + _animationDuration / 12;
    }
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    return keyAnimation;
}

/// eyes close and open key frame animation
- (CAKeyframeAnimation *)eyesCloseAndOpenAnimationWithRect:(CGRect)rect {
    CGFloat frameNumber = _animationDuration * 180 / 9; // 180 frame erver second
    CGFloat eyesX = rect.origin.x;
    CGFloat eyesY = rect.origin.y;
    CGFloat eyesWidth = rect.size.width;
    CGFloat eyesHeight = rect.size.height;
    NSMutableArray *arrayFrame = [NSMutableArray array];
    for (int i = 0; i < frameNumber; i++) {
        if (i < frameNumber / 3) {
            // close
            eyesHeight = eyesHeight - rect.size.height / (frameNumber / 3);
        } else if (i >= frameNumber / 3 && i < frameNumber * 2 / 3) {
            // zero
            eyesHeight = 0;
        } else {
            // open
            eyesHeight = eyesHeight + rect.size.height / (frameNumber / 3);
        }
        eyesY = (rect.size.height - eyesHeight) / 2;
        [arrayFrame addObject:[NSValue valueWithCGRect:CGRectMake(eyesX, eyesY, eyesWidth, eyesHeight)]];
    }
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"eyeRect"];
    keyAnimation.values = arrayFrame;
    keyAnimation.duration = _animationDuration / 3;
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    return keyAnimation;
}

@end

