//
//  UIView+KJRectCorner.h
//  CategoryDemo
//
//  Created by 杨科军 on 2018/7/12.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  进阶版圆角和边框扩展

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, KJBorderOrientationType) {
    KJBorderOrientationTypeUnknown= 1 << 0,/// 未知边
    KJBorderOrientationTypeTop    = 1 << 1,/// 上边
    KJBorderOrientationTypeBottom = 1 << 2,/// 下边
    KJBorderOrientationTypeLeft   = 1 << 3,/// 左边
    KJBorderOrientationTypeRight  = 1 << 4,/// 右边
};
@interface UIView (KJRectCorner)
//*********  Xib中显示属性 IBInspectable就可以可视化显示相关的属性  ***********
/// 图片属性，备注这个会覆盖掉UIImageView上面设置的image
@property(nonatomic,strong)IBInspectable UIImage *viewImage;
/// 圆角边框
@property(nonatomic,strong)IBInspectable UIColor *borderColor;
@property(nonatomic,assign)IBInspectable CGFloat borderWidth;
@property(nonatomic,assign)IBInspectable CGFloat cornerRadius;
/// 阴影，备注View默认颜色ClearColor时阴影不会生效
@property(nonatomic,strong)IBInspectable UIColor *shadowColor;//设置阴影颜色
@property(nonatomic,assign)IBInspectable CGFloat shadowRadius;//设置阴影的圆角
@property(nonatomic,assign)IBInspectable CGFloat shadowWidth;//设置阴影的宽度
@property(nonatomic,assign)IBInspectable CGFloat shadowOpacity;//设置阴影透明度
@property(nonatomic,assign)IBInspectable CGSize  shadowOffset;//设置阴影偏移量
/// 贝塞尔圆角，更快捷高效的圆角方式
@property(nonatomic,assign)CGFloat bezierRadius;

#pragma mark - 进阶版圆角和边框扩展
/// 圆角半径，默认5px
@property(nonatomic,assign)CGFloat kj_radius;
/// 圆角方位
@property(nonatomic,assign)UIRectCorner kj_rectCorner;

/// 边框颜色，默认黑色
@property(nonatomic,strong)UIColor *kj_borderColor;
/// 边框宽度，默认1px
@property(nonatomic,assign)CGFloat kj_borderWidth;
/// 边框方位，必设参数
@property(nonatomic,assign)KJBorderOrientationType kj_borderOrientation;

/// 虚线边框
/// @param lineColor 线条颜色
/// @param lineWidth 线条宽度
/// @param spaceAry 线条之间间隔数组
- (void)kj_dashedLineColor:(UIColor *)lineColor
                 lineWidth:(CGFloat)lineWidth
                spaceArray:(NSArray<NSNumber*>*)spaceAry;
/// 设置阴影
/// @param color 阴影颜色
/// @param offset 阴影位移
/// @param radius 阴影半径
- (void)kj_shadowColor:(UIColor *)color
                offset:(CGSize)offset
                radius:(CGFloat)radius;

#pragma mark - 渐变相关
/// 渐变图层
/// @param colors 渐变颜色数组
/// @param frame 需要渐变的尺寸
/// @param locations 渐变颜色的分割点
/// @param startPoint 开始坐标，范围在（0，0）与（1,1）之间,如(0,0)(1,0)代表水平方向渐变,(0,0)(0,1)代表竖直方向渐变
/// @param endPoint 结束坐标
/// @return 返回渐变图层
- (CAGradientLayer *)kj_gradientLayerWithColors:(NSArray *)colors
                                          frame:(CGRect)frame
                                      locations:(NSArray *)locations
                                     startPoint:(CGPoint)startPoint
                                       endPoint:(CGPoint)endPoint;
/// 生成渐变背景色
/// @param colors 渐变颜色数组
/// @param locations 渐变颜色的分割点
/// @param startPoint 开始坐标
/// @param endPoint 结束坐标
- (void)kj_gradientBgColorWithColors:(NSArray *)colors
                           locations:(NSArray *)locations
                          startPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint;

#pragma mark - 指定图形
/// 画直线
- (void)kj_DrawLineWithPoint:(CGPoint)fPoint
                     toPoint:(CGPoint)tPoint
                   lineColor:(UIColor *)color
                   lineWidth:(CGFloat)width;
/// 画虚线
- (void)kj_DrawDashLineWithPoint:(CGPoint)fPoint
                         toPoint:(CGPoint)tPoint
                       lineColor:(UIColor *)color
                       lineWidth:(CGFloat)width
                       lineSpace:(CGFloat)space
                        lineType:(NSInteger)type;
/// 画五角星
- (void)kj_DrawPentagramWithCenter:(CGPoint)center
                            radius:(CGFloat)radius
                             color:(UIColor *)color
                              rate:(CGFloat)rate;
/// 根据宽高画六边形
- (void)kj_DrawSexangleWithWidth:(CGFloat)width
                       LineWidth:(CGFloat)lineWidth
                     StrokeColor:(UIColor *)color
                       FillColor:(UIColor *)fcolor;
/// 根据宽高画八边形
- (void)kj_DrawOctagonWithWidth:(CGFloat)width
                         Height:(CGFloat)height
                      LineWidth:(CGFloat)lineWidth
                    StrokeColor:(UIColor *)color
                      FillColor:(UIColor *)fcolor
                             Px:(CGFloat)px
                             Py:(CGFloat)py;

@end

NS_ASSUME_NONNULL_END
