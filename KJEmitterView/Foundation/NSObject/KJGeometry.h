//
//  KJGeometry.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/5/13.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  几何方程式相关

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJGeometry : NSObject
/// 已知A、B两点和C点到B点的长度，求垂直AB的C点
+ (CGPoint)kj_perpendicularLineDotsWithA:(CGPoint)A B:(CGPoint)B Len:(CGFloat)len Positive:(BOOL)positive;
typedef struct KJDoubleValue{ CGPoint max;CGPoint min; }KJDoubleValue;
+ (KJDoubleValue)kj_perpendicularLineDotsWithA:(CGPoint)A B:(CGPoint)B Length:(CGFloat)len;
/// 已知A、B、C、D 4个点，求AB与CD交点  备注：重合和平行返回（0,0）
+ (CGPoint)kj_linellaeCrosspointWithA:(CGPoint)A B:(CGPoint)B C:(CGPoint)C D:(CGPoint)D;
/// 求两点线段长度
+ (CGFloat)kj_distanceBetweenPointsWithA:(CGPoint)A B:(CGPoint)B;
/// 已知A、B、C三个点，求AB线对应C的平行线上的点  y = kx + b
+ (CGPoint)kj_parallelLineDotsWithA:(CGPoint)A B:(CGPoint)B C:(CGPoint)C;
/// 椭圆求点方程
+ (CGPoint)kj_ovalPointWithRect:(CGRect)lpRect Angle:(CGFloat)angle;

@end

NS_ASSUME_NONNULL_END
