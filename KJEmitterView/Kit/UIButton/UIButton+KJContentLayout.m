//
//  UIButton+KJContentLayout.m
//  CategoryDemo
//
//  Created by 杨科军 on 2018/7/7.
//  Copyright © 2017年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UIButton+KJContentLayout.h"
#import <objc/runtime.h>

@implementation UIButton (KJContentLayout)
/// 设置图文混排
- (void)kj_setButtonContentLayout{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize size = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGFloat labelWidth  = size.width;
    CGFloat labelHeight = size.height;
#pragma clang diagnostic pop
    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets titleEdge = UIEdgeInsetsZero;
    if (self.periphery == 0) self.periphery = 5;
    switch (self.layoutType) {
        case KJButtonContentLayoutStyleNormal:{
            titleEdge = UIEdgeInsetsMake(0, self.padding, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.padding);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case KJButtonContentLayoutStyleCenterImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -imageWith - self.padding, 0, imageWith);
            imageEdge = UIEdgeInsetsMake(0, labelWidth + self.padding, 0, -labelWidth);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case KJButtonContentLayoutStyleCenterImageTop:{
            titleEdge = UIEdgeInsetsMake(0, -imageWith, -imageHeight - self.padding, 0);
            imageEdge = UIEdgeInsetsMake(-labelHeight - self.padding, 0, 0, -labelWidth);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case KJButtonContentLayoutStyleCenterImageBottom:{
            titleEdge = UIEdgeInsetsMake(-imageHeight - self.padding, -imageWith, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, -labelHeight - self.padding, -labelWidth);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case KJButtonContentLayoutStyleLeftImageLeft:{
            titleEdge = UIEdgeInsetsMake(0, self.padding + self.periphery, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, self.periphery, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case KJButtonContentLayoutStyleLeftImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -imageWith + self.periphery, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, labelWidth + self.padding + self.periphery, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case KJButtonContentLayoutStyleRightImageLeft:{
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.padding + self.periphery);
            titleEdge = UIEdgeInsetsMake(0, 0, 0, self.periphery);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        case KJButtonContentLayoutStyleRightImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -self.frame.size.width / 2, 0, imageWith + self.padding + self.periphery);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, -labelWidth + self.periphery);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        default:break;
    }
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = titleEdge;
    [self setNeedsDisplay];
}

#pragma mark - associated
- (NSInteger)layoutType{
    return [objc_getAssociatedObject(self, @selector(layoutType)) integerValue];;
}
- (void)setLayoutType:(NSInteger)layoutType{
    objc_setAssociatedObject(self, @selector(layoutType), @(layoutType), OBJC_ASSOCIATION_ASSIGN);
    [self kj_setButtonContentLayout];
}
- (CGFloat)padding{
    return [objc_getAssociatedObject(self, @selector(padding)) floatValue];
}
- (void)setPadding:(CGFloat)padding{
    objc_setAssociatedObject(self, @selector(padding), @(padding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kj_setButtonContentLayout];
}
- (CGFloat)periphery{
    return [objc_getAssociatedObject(self, @selector(periphery)) floatValue];
}
- (void)setPeriphery:(CGFloat)periphery{
    objc_setAssociatedObject(self, @selector(periphery), @(periphery), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kj_setButtonContentLayout];
}

#pragma mark - 扩大点击域
static char topNameKey,bottomNameKey,leftNameKey,rightNameKey;
- (void (^)(CGFloat, CGFloat, CGFloat, CGFloat))kEnlargeEdge{
    return ^(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
        objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    };
}
- (CGRect)enlargedRect{
    NSNumber *t = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *r = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *b = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *l = objc_getAssociatedObject(self, &leftNameKey);
    if (t && r && b && l){
        return CGRectMake(self.bounds.origin.x - l.floatValue,
                          self.bounds.origin.y - t.floatValue,
                          self.bounds.size.width + l.floatValue + r.floatValue,
                          self.bounds.size.height + t.floatValue + b.floatValue);
    }else {
        return self.bounds;
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    UIEdgeInsets insets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - insets.left,
                        bounds.origin.y - insets.top,
                        bounds.size.width + insets.left + insets.right,
                        bounds.size.height + insets.top + insets.bottom);
    return CGRectContainsPoint(bounds, point);
}
#pragma mark - associated
- (UIEdgeInsets)touchAreaInsets{
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}
- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets{
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

