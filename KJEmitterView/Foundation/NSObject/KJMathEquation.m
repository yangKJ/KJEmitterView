//
//  KJMathEquation.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/31.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "KJMathEquation.h"

@implementation KJMathEquation
#pragma mark - Calculate once linear equation (Y = kX + b)
+ (KJLinearEquation)kj_mathOnceLinearEquationWithPointA:(CGPoint)pointA PointB:(CGPoint)pointB{
    CGFloat x1 = pointA.x; CGFloat y1 = pointA.y;
    CGFloat x2 = pointB.x; CGFloat y2 = pointB.y;
    CGFloat k = x1 == x2 ? 0 : (y2 - y1) / (x2 - x1);
    CGFloat b = x1 == x2 ? 0 : (y1*(x2 - x1) - x1*(y2 - y1)) / (x2 - x1);
    return (KJLinearEquation){k,b};
}
/// 已知y，k，b 求 x
+ (CGFloat)kj_xValueWithY:(CGFloat)yValue LinearEquation:(KJLinearEquation)kb{
    if (kb.k == 0) return 0;
    return (yValue - kb.b) / kb.k;
}
/// 已知x，k，b 求 y
+ (CGFloat)kj_yValueWithX:(CGFloat)xValue LinearEquation:(KJLinearEquation)kb{
    return kb.k * xValue + kb.b;
}

float kDegreeFromRadian(float radian){
    return ((radian) * (180.0 / M_PI));
}
float kRadianFromDegree(float degree){
    return ((degree) * M_PI / 180.f);
}
float kradianValueFromTanSide(float sideA, float sideB){
    return atan2f(sideA, sideB);
}
CGSize kResetFromSizeAndFixedWidth(CGSize size, float width){
    CGFloat newHeight = size.height * (width / size.width);
    return CGSizeMake(width, newHeight);
}
CGSize kResetFromSizeAndFixedHeight(CGSize size, float height){
    float newWidth = size.width * (height / size.height);
    return CGSizeMake(newWidth, height);
}
/// 最大公约数
int kMaxCommonDivisor(int num){
    if (num == 4) return 2;
    int i = 2, ans = 1;
    while (i * i <= num) {
        if (num % i == 0) ans = i;
        while (num % i == 0) num /= i;
        i++;
    }
//    if (num != 1) ans = num;
    return num;
}


@end
