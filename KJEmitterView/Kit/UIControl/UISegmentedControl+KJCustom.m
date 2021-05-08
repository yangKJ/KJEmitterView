//
//  UISegmentedControl+KJCustom.m
//  Winpower
//
//  Created by 杨科军 on 2019/10/12.
//  Copyright © 2019 cq. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UISegmentedControl+KJCustom.h"

@implementation UISegmentedControl (KJCustom)
- (void)kj_ensureBackgroundAndTintColor {
    if (@available(iOS 13, *)) {
        UIColor *tintColor = [self tintColor];
        UIImage *tintColorImage = [self imageWithColor:tintColor];
        [self setBackgroundImage:[self imageWithColor:self.backgroundColor ? self.backgroundColor : [UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[self imageWithColor:[tintColor colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected|UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setDividerImage:tintColorImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [tintColor CGColor];
    }
}

- (UIImage*)imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
