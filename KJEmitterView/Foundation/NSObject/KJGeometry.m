//
//  KJGeometry.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/5/13.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView


#import "KJGeometry.h"

@implementation KJGeometry
/// 已知A、B两点和C点到B点的长度，求垂直AB的C点
+ (CGPoint)kj_perpendicularLineDotsWithA:(CGPoint)A B:(CGPoint)B Len:(CGFloat)len Positive:(BOOL)positive{
    KJDoubleValue douvalue = [self kj_perpendicularLineDotsWithA:A B:B Length:len];
    if (positive) {
        return douvalue.max;
    }else{
        return douvalue.min;
    }
}
+ (KJDoubleValue)kj_perpendicularLineDotsWithA:(CGPoint)A B:(CGPoint)B Length:(CGFloat)len{
    CGFloat x1 = A.x,y1 = A.y;
    CGFloat x2 = B.x,y2 = B.y;
    if (x1 == x2) {/// 垂直线
        return (KJDoubleValue){CGPointMake(x2+len, y2),CGPointMake(x2-len, y2)};
    }else if (y1 == y2) {/// 水平线
        return (KJDoubleValue){CGPointMake(x2, y2+len),CGPointMake(x2, y2-len)};
    }
    /// 既非垂直又非水平处理
    CGFloat k1 = (y1-y2)/(x1-x2);
    CGFloat k = -1/k1;
    CGFloat b = y2 - k*x2;
    /// 根据 len² = (x-x2)² + (y-y2)²  和  y = kx + b 推倒出x、y
    CGFloat t = k*k + 1;
    CGFloat g = k*(b-y2) - x2;
    CGFloat f = x2*x2 + (b-y2)*(b-y2);
    CGFloat m = g/t;
    CGFloat n = (len*len - f)/t + m*m;
    CGFloat xa = sqrt(n) - m;
    CGFloat ya = k * xa + b;
    CGFloat xb = -sqrt(n) - m;
    CGFloat yb = k * xb + b;
    
    CGPoint pt1 = CGPointMake(xb, yb);
    CGPoint pt2 = CGPointMake(xa, ya);
    return (KJDoubleValue){yb>ya?pt1:pt2,yb>ya?pt2:pt1};
}

/// 已知A、B、C、D 4个点，求AB与CD交点  备注：重合和平行返回（0,0）
+ (CGPoint)kj_linellaeCrosspointWithA:(CGPoint)A B:(CGPoint)B C:(CGPoint)C D:(CGPoint)D{
    CGFloat x1 = A.x,y1 = A.y;
    CGFloat x2 = B.x,y2 = B.y;
    CGFloat x3 = C.x,y3 = C.y;
    CGFloat x4 = D.x,y4 = D.y;
    CGFloat k1 = (y1-y2)/(x1-x2);
    CGFloat k2 = (y3-y4)/(x3-x4);
    CGFloat b1 = y1-k1*x1;
    CGFloat b2 = y4-k2*x4;
    if (x1==x2&&x3!=x4) {
        return CGPointMake(x1, k2*x1+b2);
    }else if (x3==x4&&x1!=x2){
        return CGPointMake(x3, k1*x3+b1);
    }else if (x3==x4&&x1==x2){
        return CGPointZero;
    }else{
        if (y1==y2&&y3!=y4) {
            return CGPointMake((y1-b2)/k2, y1);
        }else if (y3==y4&&y1!=y2){
            return CGPointMake((y4-b1)/k1, y4);
        }else if (y3==y4&&y1==y2){
            return CGPointZero;
        }else{
            if (k1==k2){
                return CGPointZero;
            }else{
                CGFloat x = (b2-b1)/(k1-k2);
                CGFloat y = k2*x+b2;
                return CGPointMake(x, y);
            }
        }
    }
}
/// 求两点线段长度
+ (CGFloat)kj_distanceBetweenPointsWithA:(CGPoint)A B:(CGPoint)B{
    CGFloat deX = A.x - A.x;
    CGFloat deY = B.y - B.y;
    return sqrt(deX*deX + deY*deY);
}
/// 已知A、B、C三个点，求AB线对应C的平行线上的点  y = kx + b
+ (CGPoint)kj_parallelLineDotsWithA:(CGPoint)A B:(CGPoint)B C:(CGPoint)C{
    CGFloat x1 = A.x,y1 = A.y;
    CGFloat x2 = B.x,y2 = B.y;
    CGFloat x3 = C.x,y3 = C.y;
    CGFloat k = 0;
    if (x1 == x2) {
        k = 1;/// 水平线
    }else{    
        k = (y1-y2)/(x1-x2);
    }
    CGFloat b = y3 - k*x3;
    CGFloat x = x1;
    CGFloat y = k * x + b;/// y = kx + b
    return CGPointMake(x, y);
}
/// 椭圆求点方程
+ (CGPoint)kj_ovalPointWithRect:(CGRect)lpRect Angle:(CGFloat)angle{
    double a = lpRect.size.width / 2.0f;
    double b = lpRect.size.height / 2.0f;
    if (a == 0 || b == 0) return CGPointMake(lpRect.origin.x, lpRect.origin.y);
    double radian = angle * M_PI / 180.0f;/// 弧度
    double yc = sin(radian);/// 获取弧度正弦值
    double xc = cos(radian);/// 获取弧度余弦值
    /// 获取曲率 r = ab/Sqrt((a.Sinθ)^2+(b.Cosθ)^2
    double radio = (a * b) / sqrt(pow(yc * a, 2.0) + pow(xc * b, 2.0));
    return CGPointMake(lpRect.origin.x + a + radio * xc, lpRect.origin.y + b + radio * yc);
}

@end
