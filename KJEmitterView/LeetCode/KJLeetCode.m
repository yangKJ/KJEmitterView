//
//  KJLeetCode.m
//  KJEmitterView
//
//  Created by yangkejun on 2021/3/15.
//  Copyright © 2021 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "KJLeetCode.h"

typedef struct KJDoubleValue{
    CGPoint max;
    CGPoint min;
}KJDoubleValue;
@implementation KJLeetCode
#pragma mark - 几何方程式
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
    if (x1 == x2) {//垂直线
        return (KJDoubleValue){CGPointMake(x2+len, y2),CGPointMake(x2-len, y2)};
    }else if (y1 == y2) {//水平线
        return (KJDoubleValue){CGPointMake(x2, y2+len),CGPointMake(x2, y2-len)};
    }
    //既非垂直又非水平处理
    CGFloat k1 = (y1-y2)/(x1-x2);
    CGFloat k = -1/k1;
    CGFloat b = y2 - k*x2;
    //根据 len² = (x-x2)² + (y-y2)² 和 y = kx + b 推倒出x、y
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
    if (x1 == x2) {//水平线
        k = 1;
    }else{
        k = (y1-y2)/(x1-x2);
    }
    CGFloat b = y3 - k*x3;
    CGFloat x = x1;
    CGFloat y = k * x + b;//y = kx + b
    return CGPointMake(x, y);
}
/// 椭圆求点方程
+ (CGPoint)kj_ovalPointWithRect:(CGRect)lpRect Angle:(CGFloat)angle{
    double a = lpRect.size.width / 2.0f;
    double b = lpRect.size.height / 2.0f;
    if (a == 0 || b == 0) return CGPointMake(lpRect.origin.x, lpRect.origin.y);
    double radian = angle * M_PI / 180.0f;
    double yc = sin(radian), xc = cos(radian);
    //获取曲率 r = ab/Sqrt((a.Sinθ)^2+(b.Cosθ)^2
    double radio = (a * b) / sqrt(pow(yc * a, 2.0) + pow(xc * b, 2.0));
    return CGPointMake(lpRect.origin.x + a + radio * xc, lpRect.origin.y + b + radio * yc);
}
float kDegreeFromRadian(float radian){
    return ((radian) * (180.0 / M_PI));
}
float kRadianFromDegree(float degree){
    return ((degree) * M_PI / 180.f);
}
float kRadianValueFromTanSide(float sideA, float sideB){
    return atan2f(sideA, sideB);
}
/// 离散傅立叶变换
int kDFT(int dir, int m, double *x1, double *y1){
    long i,k;
    double arg;
    double cosarg,sinarg;
    double *x2 = NULL,*y2 = NULL;
    x2 = malloc(m*sizeof(double));
    y2 = malloc(m*sizeof(double));
    if (x2 == NULL || y2 == NULL) return (FALSE);
    for (i = 0;i < m;i++) {
        x2[i] = 0;
        y2[i] = 0;
        arg = -dir * 2.0 * 3.141592654 * (double)i / (double)m;
        for (k = 0;k < m;k++) {
            cosarg = cos(k*arg);
            sinarg = sin(k*arg);
            x2[i] += (x1[k] * cosarg - y1[k] * sinarg);
            y2[i] += (x1[k] * sinarg + y1[k] * cosarg);
        }
    }
    if (dir == 1) {
        for (i = 0;i < m;i++) {
            x1[i] = x2[i] / (double)m;
            y1[i] = y2[i] / (double)m;
        }
    } else {
        for (i = 0;i < m;i++) {
            x1[i] = x2[i];
            y1[i] = y2[i];
        }
    }
    free(x2);
    free(y2);
    return (TRUE);
}

#pragma mark - 数组算法
/// 找到第 k 个最大元素
int kLeetCodeArrayFindMaxK(int * nums, int size, int k){
    int heapSize = size;
    for (int i = size / 2; i >= 0; --i) {
        maxHeapify(nums, i, size);
    }
    for (int i = size - 1; i >= size - k + 1; --i) {
        int t = nums[0];
        (void)(nums[0] = nums[i]), nums[i] = t;
        --heapSize;
        maxHeapify(nums, 0, heapSize);
    }
    return nums[0];
}
void maxHeapify(int * arr, int i, int size) {
    int l = i * 2 + 1, r = i * 2 + 2, largest = i;
    if (l < size && arr[l] > arr[largest]) {
        largest = l;
    }
    if (r < size && arr[r] > arr[largest]) {
        largest = r;
    }
    if (largest != i) {
        int t = arr[i];
        (void)(arr[i] = arr[largest]), arr[largest] = t;
        maxHeapify(arr, largest, size);
    }
}

#pragma mark - 字符串算法

#pragma mark - 数字算法
/* 整数反转
 给你一个 32 位的有符号整数 x ，返回将 x 中的数字部分反转后的结果
 如果反转后整数超过 32 位的有符号整数的范围 [−231,  231 − 1] ，就返回 0
 */
int kLeetCodeIntReverse(int x){
    long res = 0;
    while (x != 0) {
        res = res * 10 + x % 10;
        x /= 10;
    }
    return (int) res == res ? (int) res : 0;
}
/// 计数质数，统计所有小于非负整数 n 的质数的数量
int kLeetCodeIntCountPrimes(int n){
    int count = 0;
    bool signs[n];
    for (int i = 2; i < n; i++) {
        if (signs[i] == false){
            count++;
            for (int j = i + i; j < n; j += i) {
                signs[j] = true;
            }
        }
    }
    return count;
}
/// 计算区间内所有数字位与结果
int kLeetCodeIntrangeBitwise(int m, int n){
    while (m < n) {
        n &= n - 1;
    }
    return n;
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
    return num;
}
/// 汉明距离，两个数字对应二进制位不同的位置的数目
int kLeetCodeHammingDistance(int x, int y){
    int s = x ^ y, ret = 0;
    while (s) {
        ret += s & 1;
        s >>= 1;
    }
    return ret;
}
/// 汉明距离总和
int kLeetCodeHammingDistanceTotal(int * nums, int size){
    int ans = 0;
    for (int i = 0; i < 30; ++i) {
        int c = 0;
        for (int j = 0; j < size; ++j) {
            c += (nums[j] >> i) & 1;
        }
        ans += c * (size - c);
    }
    return ans;
}
/// 判断是否为 4 的幂次方
int kLeetCodeIntPowerOfFour(int n){
    //(n & (n - 1)) == 0 表示2的幂次方
    return n > 0 && (n & (n - 1)) == 0 && n % 3 == 1;
}

@end
