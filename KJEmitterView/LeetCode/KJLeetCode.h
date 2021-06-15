//
//  KJLeetCode.h
//  KJEmitterView
//
//  Created by yangkejun on 2021/3/15.
//  Copyright © 2021 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  LeetCode算法汇总

#import <Foundation/Foundation.h>

@interface KJLeetCode : NSObject
#pragma mark - 几何方程式
/// 已知A、B两点和C点到B点的长度，求垂直AB的C点
+ (CGPoint)kj_perpendicularLineDotsWithA:(CGPoint)A
                                       B:(CGPoint)B
                                     Len:(CGFloat)len
                                Positive:(BOOL)positive;
/// 已知A、B、C、D 4个点，求AB与CD交点  备注：重合和平行返回（0,0）
+ (CGPoint)kj_linellaeCrosspointWithA:(CGPoint)A B:(CGPoint)B C:(CGPoint)C D:(CGPoint)D;
/// 求两点线段长度
+ (CGFloat)kj_distanceBetweenPointsWithA:(CGPoint)A B:(CGPoint)B;
/// 已知A、B、C三个点，求AB线对应C的平行线上的点  y = kx + b
+ (CGPoint)kj_parallelLineDotsWithA:(CGPoint)A B:(CGPoint)B C:(CGPoint)C;
/// 椭圆求点方程
+ (CGPoint)kj_ovalPointWithRect:(CGRect)lpRect Angle:(CGFloat)angle;
/// 把弧度转换成角度
float kDegreeFromRadian(float radian);
/// 把角度转换成弧度
float kRadianFromDegree(float degree);
/// 正切函数的弧度值，tan(A/B)
float kRadianValueFromTanSide(float sideA, float sideB);
/// 离散傅立叶变换
int kDFT(int dir, int m, double *x1, double *y1);

#pragma mark - 数组算法
/// 找到第 k 个最大元素
int kLeetCodeArrayFindMaxK(int * nums, int size, int k);

#pragma mark - 字符串算法

#pragma mark - 数字算法
/// 整数反转
int kLeetCodeIntReverse(int x);
/// 计数质数
int kLeetCodeIntCountPrimes(int n);
/// 计算区间内所有数字位与结果
int kLeetCodeIntrangeBitwise(int m, int n);
/// 最大公约数
int kMaxCommonDivisor(int num);
/// 汉明距离
int kLeetCodeHammingDistance(int x, int y);
/// 汉明距离总和
int kLeetCodeHammingDistanceTotal(int * nums, int size);
/// 判断是否为 4 的幂次方
int kLeetCodeIntPowerOfFour(int n);

@end

