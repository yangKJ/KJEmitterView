//
//  KJMathEquation.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/31.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  数学算法方程式

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJMathEquation : NSObject
#pragma mark - 一元一次线性方程 (Y = kX + b).
/// 一元一次线性方程，求k，b
typedef struct KJLinearEquation{ CGFloat k;CGFloat b; }KJLinearEquation;
+ (KJLinearEquation)kj_mathOnceLinearEquationWithPointA:(CGPoint)pointA PointB:(CGPoint)pointB;
/// 已知y，k，b 求 x
+ (CGFloat)kj_xValueWithY:(CGFloat)yValue LinearEquation:(KJLinearEquation)kb;
/// 已知x，k，b 求 y
+ (CGFloat)kj_yValueWithX:(CGFloat)xValue LinearEquation:(KJLinearEquation)kb;


/// 把弧度转换成角度
float kDegreeFromRadian(float radian);
/// 把角度转换成弧度
float kRadianFromDegree(float degree);
/// 正切函数的弧度值，tan
float kradianValueFromTanSide(float sideA, float sideB);
/// 获取具有固定宽度的新size
CGSize kResetFromSizeAndFixedWidth(CGSize size, float width);
/// 获取具有固定高度的新size
CGSize kResetFromSizeAndFixedHeight(CGSize size, float height);
/// 最大公约数
int kMaxCommonDivisor(int num);

@end

NS_ASSUME_NONNULL_END
