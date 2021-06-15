//
//  UIImage+KJOpencv.h
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView
//  Opencv图片处理工具封装
//  官方文档：https://docs.opencv.org/4.5.1/modules.html

/* ****************  需要引入OpenCV库，pod 'OpenCV', '~> 4.1.0' *******************/

#import <UIKit/UIKit.h>
#import "KJOpencvType.h"
#if __has_include(<opencv2/imgcodecs/ios.h>)
NS_ASSUME_NONNULL_BEGIN
@interface UIImage (KJOpencv)
/// 图片平铺 
- (UIImage*)kj_opencvTiledRows:(int)row cols:(int)col;
/// 根据透视四点透视图片 
- (UIImage*)kj_opencvWarpPerspectiveWithKnownPoints:(KJKnownPoints)points size:(CGSize)size;
/// 消除图片高光，beta[0-2]，alpha[0-2]
- (UIImage*)kj_opencvIlluminationChangeBeta:(double)beta alpha:(double)alpha;
/// 图片混合，前提条件两张图片必须大小和类型均一致，alpha[0-1] 
- (UIImage*)kj_opencvBlendImage:(UIImage*)image alpha:(double)alpha;
/// 调整图片亮度和对比度，contrast[0-100]，luminance[0-2] 
- (UIImage*)kj_opencvChangeContrast:(int)contrast luminance:(double)luminance;
/// 修改图片通道值颜色，r,g,b[0-255]，需要保持不变请传-1 
- (UIImage*)kj_opencvChangeR:(int)r g:(int)g b:(int)b;

#pragma mark - 滤波模糊板块
/// 模糊处理 
- (UIImage*)kj_opencvBlurX:(int)x y:(int)y;
/// 高斯模糊，xy正数且为奇数 
- (UIImage*)kj_opencvGaussianBlurX:(int)x y:(int)y;
/// 中值模糊，可以去掉白色小颗粒，ksize必须为正数且奇数 
- (UIImage*)kj_opencvMedianBlurksize:(int)ksize;
/// 高斯双边模糊，可以做磨皮美白效果，sigma[10-150] 
- (UIImage*)kj_opencvBilateralFilterBlurRadio:(int)radio sigma:(int)sigma;
/// 自定义线性模糊 
- (UIImage*)kj_opencvCustomBlurksize:(int)ksize;

#pragma mark - 图像形态学相关
/// 形态学操作，element腐蚀膨胀程度 
- (UIImage*)kj_opencvMorphology:(KJOpencvMorphologyStyle)type element:(int)element;

#pragma mark - 综合效果处理
/// 修复图片，可以去水印 
- (UIImage*)kj_opencvInpaintImage:(int)radius;
/// 图片修复，效果增强处理 
- (UIImage*)kj_opencvRepairImage;
/// 图像裁剪算法，裁剪出最大内部矩形区域 
- (UIImage*)kj_opencvCutMaxRegionImage;
/// 图片拼接技术，多张类似图合成一张 
- (UIImage*)kj_opencvCompoundMoreImage:(UIImage*)image,...;
/// 特征提取，基于Sobel算子 
- (UIImage*)kj_opencvFeatureExtractionFromSobel;
/// 文本类型图片矫正，直线探测基于霍夫线判断矫正 
- (UIImage*)kj_opencvHoughLinesCorrectTextImageFillColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
#endif
