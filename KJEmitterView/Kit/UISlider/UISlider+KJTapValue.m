//
//  UISlider+KJTapValue.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/9/17.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UISlider+KJTapValue.h"
#import <objc/runtime.h>
@implementation UISlider (KJTapValue)
- (bool)kTapValue{
    return [objc_getAssociatedObject(self,@selector(kTapValue)) boolValue];
}
- (void)setKTapValue:(bool)kTapValue{
    objc_setAssociatedObject(self,@selector(kTapValue),[NSNumber numberWithBool:kTapValue],OBJC_ASSOCIATION_ASSIGN);
}
- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event{
    if (self.kTapValue == false) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    CGRect rect = [self trackRectForBounds:self.bounds];
    float value = [self minimumValue] + ([[touches anyObject] locationInView: self].x - rect.origin.x - 4.0) * (([self maximumValue]-[self minimumValue]) / (rect.size.width - 8.0));
    [self setValue:value];
    [super touchesBegan:touches withEvent:event];
}

@end
