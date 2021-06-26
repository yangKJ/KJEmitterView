//
//  UIImage+KJDoraemonBox.h
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/1.
//  Copyright © 2018 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  图片尺寸处理

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KJJointImageType) {
    KJJointImageTypeCustom = 0,/// 正常平铺
    KJJointImageTypePositively,/// 正斜对花
    KJJointImageTypeBackslash, /// 反斜对花
    KJJointImageTypeAcross,    /// 横对花
    KJJointImageTypeVertical,  /// 竖对花
};
typedef NS_ENUM(NSInteger, KJImageWaterType) {
    KJImageWaterTypeTopLeft = 0, /// 左上
    KJImageWaterTypeTopRight,    /// 右上
    KJImageWaterTypeBottomLeft,  /// 左下
    KJImageWaterTypeBottomRight, /// 右下
    KJImageWaterTypeCenter,      /// 正中
};
@interface UIImage (KJDoraemonBox)
#pragma mark - 截图处理
/// 当前视图截图
+ (UIImage *)kj_captureScreen:(UIView *)view;
/// 指定位置屏幕截图
+ (UIImage *)kj_captureScreen:(UIView *)view Rect:(CGRect)rect;
/// 自定义质量的截图
/// @param view 被截取视图
/// @param rect 截取尺寸
/// @param quality 质量倍数
/// @return 返回截图
+ (UIImage *)kj_captureScreen:(UIView *)view Rect:(CGRect)rect Quality:(NSInteger)quality;
/// 截取当前屏幕（窗口截图）
+ (UIImage *)kj_captureScreenWindow;
/// 截取当前屏幕（根据手机方向旋转）
+ (UIImage *)kj_captureScreenWindowForInterfaceOrientation;
/// 截取滚动视图的长图
/// @param scroll 截取视图
/// @param contentOffset 开始截取位置
/// @return 返回截图
+ (UIImage *)kj_captureScreenWithScrollView:(UIScrollView*)scroll contentOffset:(CGPoint)contentOffset;

#pragma mark - 裁剪处理
/// 不规则图形切图
+ (UIImage *)kj_anomalyCaptureImageWithView:(UIView *)view BezierPath:(UIBezierPath *)path;
/// 多边形切图
+ (UIImage *)kj_polygonCaptureImageWithImageView:(UIImageView*)imageView PointArray:(NSArray *)points;
/// 指定区域裁剪
- (UIImage *)kj_cutImageWithCropRect:(CGRect)cropRect;
+ (UIImage *)kj_cutImageWithImage:(UIImage *)image Frame:(CGRect)cropRect;
/// quartz 2d 实现裁剪
- (UIImage *)kj_quartzCutImageWithCropRect:(CGRect)cropRect;
+ (UIImage *)kj_quartzCutImageWithImage:(UIImage *)image Frame:(CGRect)cropRect;
/// 图片路径裁剪，裁剪路径 "以外" 部分
/// @param path 裁剪路径
/// @param rect 画布尺寸
/// @return 返回裁剪图
- (UIImage *)kj_captureOuterImageBezierPath:(UIBezierPath *)path Rect:(CGRect)rect;
+ (UIImage *)kj_captureOuterImage:(UIImage *)image BezierPath:(UIBezierPath *)path Rect:(CGRect)rect;
/// 图片路径裁剪，裁剪路径 "以内" 部分
/// @param path 裁剪路径
/// @param rect 画布尺寸
/// @return 返回裁剪图
- (UIImage *)kj_captureInnerImageBezierPath:(UIBezierPath *)path Rect:(CGRect)rect;
+ (UIImage *)kj_captureInnerImage:(UIImage *)image BezierPath:(UIBezierPath *)path Rect:(CGRect)rect;

#pragma mark - 图片尺寸处理
/// 通过比例来缩放图片
- (UIImage *)kj_scaleImage:(CGFloat)scale;
/// 以固定宽度缩放图像
- (UIImage *)kj_scaleWithFixedWidth:(CGFloat)width;
/// 以固定高度缩放图像
- (UIImage *)kj_scaleWithFixedHeight:(CGFloat)height;
/// 等比改变图片尺寸
- (UIImage *)kj_cropImageWithAnySize:(CGSize)size;
/// 等比缩小图片尺寸
- (UIImage *)kj_zoomImageWithMaxSize:(CGSize)size;
/// 不拉升填充图片
- (UIImage *)kj_fitImageWithSize:(CGSize)size;
/// 裁剪图片处理，以图片中心位置开始裁剪
- (UIImage *)kj_clipCenterImageWithSize:(CGSize)size;

#pragma mark - 图片压缩
/// 压缩图片到指定大小
- (UIImage *)kj_compressTargetByte:(NSUInteger)maxLength;
+ (UIImage *)kj_compressImage:(UIImage *)image TargetByte:(NSUInteger)maxLength;
/// UIKit方式
- (UIImage *)kj_UIKitChangeImageSize:(CGSize)size;
/// Quartz 2D
- (UIImage *)kj_QuartzChangeImageSize:(CGSize)size;
/// ImageIO，性能最优
- (UIImage *)kj_ImageIOChangeImageSize:(CGSize)size;
/// CoreGraphics
- (UIImage *)kj_BitmapChangeImageSize:(CGSize)size;
/// CoreImage
//- (UIImage *)kj_coreImageChangeImageSize:(CGSize)size;

#pragma mark - 动态图板块
/// 是否为动态图
@property(nonatomic,assign,readonly) BOOL isGif;
/// 本地动态图播放
+ (UIImage *)kj_gifLocalityImageWithName:(NSString *)name;
/// 本地动图
+ (UIImage *)kj_gifImageWithData:(NSData*)data;
/// 网络动图
+ (UIImage *)kj_gifImageWithURL:(NSURL *)URL;
/// 图片播放，动态图
+ (UIImage *)kj_playImageWithData:(NSData*)data;
/// 子线程播放动态图
/// @param xxblock 动态图生成回调
/// @param data 图片数据
void kPlayGifImageData(void(^xxblock)(bool isgif, UIImage * image), NSData *data);

#pragma mark - 获取网络图片尺寸
/// 获取网络图片尺寸
+ (CGSize)kj_imageGetSizeWithURL:(NSURL *)URL;
/// 异步等待获取网络图片大小，信号量
+ (CGSize)kj_imageAsyncGetSizeWithURL:(NSURL *)URL;

#pragma mark - 图片拼接相关处理
/// 竖直方向拼接随意张图片，固定主图的宽度
- (UIImage *)kj_moreJointVerticalImage:(UIImage *)jointImage,...;
/// 水平方向拼接随意张图片，固定主图的高度
- (UIImage *)kj_moreJointLevelImage:(UIImage *)jointImage,...;
/// 图片合成
/// @param loopTimes 重复合成次数
/// @param orientation 合成方向
/// @return 返回拼接图
- (UIImage *)kj_imageCompoundWithLoopNums:(NSInteger)loopTimes
                              orientation:(UIImageOrientation)orientation;
/// 水平拼接图片，固定主图高度
/// @param jointImage 拼接图片，可追加多张以nil结尾
/// @return 返回拼接图
- (UIImage *)kj_moreCoreGraphicsJointLevelImage:(UIImage *)jointImage,...;
/// 图片拼接艺术
/// @param type 拼接类型
/// @param size 拼接出来图片尺寸
/// @param maxw 固定拼接图片的宽度
/// @return 返回拼接图
- (UIImage *)kj_jointImageWithJointType:(KJJointImageType)type
                                   size:(CGSize)size
                               maxwidth:(CGFloat)maxw;
/// 异步图片拼接处理
/// @param block 回调拼接之后的图片
/// @param type 拼接类型
/// @param size 拼接图片尺寸
/// @param maxw 固定拼接图片的宽度
- (void)kj_asyncJointImage:(void(^)(UIImage *image))block
                 jointType:(KJJointImageType)type
                      size:(CGSize)size
                  maxwidth:(CGFloat)maxw;

#pragma mark - 水印蒙版处理
/// 文字水印
/// @param text 文本内容
/// @param direction 水印位置
/// @param color 文本颜色
/// @param font 文本字体
/// @param margin 显示位置
/// @return 返回添加水印的图片
- (UIImage *)kj_waterText:(NSString *)text
                direction:(KJImageWaterType)direction
                textColor:(UIColor *)color
                     font:(UIFont *)font
                   margin:(CGPoint)margin;
/// 图片水印
/// @param image 水印图片
/// @param direction 水印位置
/// @param size 水印尺寸
/// @param margin 水印位置
/// @return 返回添加水印的图片
- (UIImage *)kj_waterImage:(UIImage *)image
                 direction:(KJImageWaterType)direction
                 waterSize:(CGSize)size
                    margin:(CGPoint)margin;
/// 图片添加水印
/// @param mark 水印图片
/// @param rect 水印位置
/// @return 返回添加水印的图片
- (UIImage *)kj_waterMark:(UIImage *)mark InRect:(CGRect)rect;
/// 蒙版图片处理
- (UIImage *)kj_maskImage:(UIImage *)maskImage;

#pragma mark - CoreGraphics板块，Core Graphics是Quartz 2D的一个高级绘图引擎，基于CPU处理
/// 裁剪掉图片周围的透明部分
- (UIImage *)kj_cutImageRoundAlphaZero;
/// 获取图片平均颜色
- (UIColor *)kj_getImageAverageColor;
/// 获得灰度图
- (UIImage *)kj_getGrayImage;
/// 绘制图片
- (UIImage *)kj_mallocDrawImage;

#pragma mark - 其他
/// 保存图片到系统相册
- (void)kj_saveImageToPhotosAlbum:(void(^)(BOOL success))complete;
/// 渐变色图片，0：从上到下，1：从左到右，2：从左上到右下，3：从右上到左下
+ (UIImage*(^)(CGSize,int))kj_gradientImageColor:(UIColor *)color,...;
/// 兼容Swift版本的渐变色图片
//UIImage * kGradientColorImage(CGSize size, int direction, UIColor *color,...);
/// 旋转图片和镜像处理
- (UIImage *)kj_rotationImageWithOrientation:(UIImageOrientation)orientation;
/// 椭圆形图片，图片长宽不等会出现切出椭圆
- (UIImage *)kj_ellipseImage;
/// 圆形图片
- (UIImage *)kj_circleImage;
/// 边框圆形图片
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
/// @return 返回添加边框的图片
- (UIImage *)kj_squareCircleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/// 图片透明区域点击穿透处理
- (bool)kj_transparentWithPoint:(CGPoint)point;
/// 修改图片线条颜色
- (UIImage *)kj_imageLinellaeColor:(UIColor *)color;
/// 图层混合，https://blog.csdn.net/yignorant/article/details/77864887
/// @param blendMode 混合类型
/// @param tintColor 颜色
/// @return 返回混合之后的图片
- (UIImage *)kj_imageBlendMode:(CGBlendMode)blendMode TineColor:(UIColor *)tintColor;
/// 改变图片透明度
- (UIImage *)kj_changeImageAlpha:(CGFloat)alpha;
/// 改变图片背景颜色
- (UIImage *)kj_changeImageColor:(UIColor *)color;
/// 改变图片亮度
- (UIImage *)kj_changeImageLuminance:(CGFloat)luminance;

@end

NS_ASSUME_NONNULL_END
