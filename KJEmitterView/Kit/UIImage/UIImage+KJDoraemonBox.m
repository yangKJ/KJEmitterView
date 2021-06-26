//
//  UIImage+KJProcessing.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/1.
//  Copyright © 2018 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UIImage+KJDoraemonBox.h"
#import "NSObject+KJGCDBox.h"

#if __has_feature(objc_arc)
#define GIFTOCF (__bridge CFTypeRef)
#define GIFFROMCF (__bridge id)
#else
#define GIFTOCF (CFTypeRef)
#define GIFFROMCF (id)
#endif
@implementation UIImage (KJDoraemonBox)
#pragma mark - 截图处理
/// 屏幕截图
+ (UIImage *)kj_captureScreen:(UIView *)view{
    return [UIImage kj_captureScreen:view Rect:view.frame];
}
/// 指定位置屏幕截图
+ (UIImage *)kj_captureScreen:(UIView *)view Rect:(CGRect)rect{
    return [self kj_captureScreen:view Rect:rect Quality:UIScreen.mainScreen.scale];
}
/// 自定义质量的截图，quality质量倍数
+ (UIImage *)kj_captureScreen:(UIView *)view Rect:(CGRect)rect Quality:(NSInteger)quality{
    return ({
        CGSize size = view.bounds.size;
        size.width  = floorf(size.width  * quality) / quality;
        size.height = floorf(size.height * quality) / quality;
        rect = CGRectMake(rect.origin.x*quality, rect.origin.y*quality, rect.size.width*quality, rect.size.height*quality);
        UIGraphicsBeginImageContextWithOptions(size, NO, quality);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRef imageRef = CGImageCreateWithImageInRect([viewImage CGImage], rect);
        UIImage *newImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        newImage;
    });
}
/// 截取当前屏幕
+ (UIImage *)kj_captureScreenWindow{
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x,
                              -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }else{
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 截取当前屏幕
+ (UIImage *)kj_captureScreenWindowForInterfaceOrientation{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)){
        imageSize = [UIScreen mainScreen].bounds.size;
    }else{
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x,
                              -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft){
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }else if (orientation == UIInterfaceOrientationLandscapeRight){
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        }else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }else{
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 截取滚动的长图
+ (UIImage *)kj_captureScreenWithScrollView:(UIScrollView*)scroll contentOffset:(CGPoint)offset{
    UIGraphicsBeginImageContext(scroll.bounds.size);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, -offset.y);
    [scroll.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 裁剪处理
/// 不规则图形切图
+ (UIImage *)kj_anomalyCaptureImageWithView:(UIView *)view BezierPath:(UIBezierPath *)path{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    maskLayer.frame = view.bounds;
    maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    
    CALayer * contentLayer = [CALayer layer];
    contentLayer.mask = maskLayer;
    contentLayer.frame = view.bounds;
    view.layer.mask = maskLayer;
    UIImage *image = [self kj_captureScreen:view];
    return image;
}
/// 多边形切图
+ (UIImage *)kj_polygonCaptureImageWithImageView:(UIImageView*)imageView PointArray:(NSArray *)points{
    CGRect rect = CGRectZero;
    rect.size = imageView.image.size;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    [[UIColor whiteColor] setFill];
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    CGPoint p1 = [self convertCGPoint:[points[0] CGPointValue] fromRect1:imageView.frame.size toRect2:imageView.frame.size];
    [aPath moveToPoint:p1];
    for (int i = 1; i< points.count; i++) {
        CGPoint point = [self convertCGPoint:[points[i] CGPointValue] fromRect1:imageView.frame.size toRect2:imageView.frame.size];
        [aPath addLineToPoint:point];
    }
    [aPath closePath];
    [aPath fill];
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
    [imageView.image drawAtPoint:CGPointZero];
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return maskedImage;
}
+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2 {
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}
+ (CGRect)kj_newScaleRect:(CGRect)cropRect Image:(UIImage *)image{
    CGFloat scale = image.scale;
    if (scale != 1) {
        cropRect.origin.x *= scale;
        cropRect.origin.y *= scale;
        cropRect.size.width *= scale;
        cropRect.size.height *= scale;
    }
    return cropRect;
}
/// 根据特定的区域对图片进行裁剪
- (UIImage *)kj_cutImageWithCropRect:(CGRect)cropRect{
    return [UIImage kj_cutImageWithImage:self Frame:cropRect];
}
+ (UIImage *)kj_cutImageWithImage:(UIImage *)image Frame:(CGRect)cropRect{
    return ({
        CGImageRef tmp = CGImageCreateWithImageInRect([image CGImage], cropRect);
        UIImage *newImage = [UIImage imageWithCGImage:tmp scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(tmp);
        newImage;
    });
}
/// quartz 2d 实现裁剪
- (UIImage *)kj_quartzCutImageWithCropRect:(CGRect)cropRect{
    return [UIImage kj_quartzCutImageWithImage:self Frame:cropRect];
}
+ (UIImage *)kj_quartzCutImageWithImage:(UIImage *)image Frame:(CGRect)cropRect{
    cropRect = [self kj_newScaleRect:cropRect Image:image];
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    CGContextDrawImage(ctx, cropRect, imageRef);
    image = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return image;
}
/// 图片路径裁剪，裁剪路径 "以外" 部分
- (UIImage *)kj_captureOuterImageBezierPath:(UIBezierPath *)path Rect:(CGRect)rect{
    return [UIImage kj_captureOuterImage:self BezierPath:path Rect:rect];
}
+ (UIImage *)kj_captureOuterImage:(UIImage *)image BezierPath:(UIBezierPath *)path Rect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef outer = CGPathCreateMutable();
    CGPathAddRect(outer, NULL, rect);
    CGPathAddPath(outer, NULL, path.CGPath);
    CGContextAddPath(context, outer);
    CGPathRelease(outer);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    [image drawInRect:rect];
    CGContextDrawPath(context, kCGPathEOFill);
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}
/// 图片路径裁剪，裁剪路径 "以内" 部分
- (UIImage *)kj_captureInnerImageBezierPath:(UIBezierPath *)path Rect:(CGRect)rect{
    return [UIImage kj_captureInnerImage:self BezierPath:path Rect:rect];
}
+ (UIImage *)kj_captureInnerImage:(UIImage *)image BezierPath:(UIBezierPath *)path Rect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeClear);/// kCGBlendModeClear 裁剪部分透明
    [image drawInRect:rect];
    CGContextAddPath(context, path.CGPath);
    CGContextDrawPath(context, kCGPathEOFill);
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

#pragma mark - 图片尺寸处理
/// 等比改变图片尺寸
- (UIImage *)kj_cropImageWithAnySize:(CGSize)size{
    float scale = self.size.width/self.size.height;
    CGRect rect = CGRectZero;
    if (scale > size.width/size.height){
        rect.origin.x = (self.size.width - self.size.height * size.width/size.height)/2;
        rect.size.width  = self.size.height * size.width/size.height;
        rect.size.height = self.size.height;
    }else{
        rect.origin.y = (self.size.height - self.size.width/size.width * size.height)/2;
        rect.size.width  = self.size.width;
        rect.size.height = self.size.width/size.width * size.height;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}
/// 等比缩小图片尺寸
- (UIImage *)kj_zoomImageWithMaxSize:(CGSize)size{
    float imgHeight = self.size.height;
    float imgWidth  = self.size.width;
    float maxHeight = size.width;
    float maxWidth = size.height;
    float imgRatio = imgWidth/imgHeight;
    float maxRatio = maxWidth/maxHeight;
    if (imgHeight <= maxHeight && imgWidth <= maxWidth) return self;
    if (imgHeight > maxHeight || imgWidth > maxWidth) {
        if (imgRatio < maxRatio) {
            imgRatio = maxHeight / imgHeight;
            imgWidth = imgRatio * imgWidth;
            imgHeight = maxHeight;
        }else if (imgRatio > maxRatio) {
            imgRatio = maxWidth / imgWidth;
            imgHeight = imgRatio * imgHeight;
            imgWidth = maxWidth;
        }else {
            imgHeight = maxHeight;
            imgWidth = maxWidth;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, imgWidth, imgHeight);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (UIImage *)kj_scaleWithFixedWidth:(CGFloat)width {
    float newHeight = self.size.height * (width / self.size.width);
    CGSize size = CGSizeMake(width, newHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}
- (UIImage *)kj_scaleWithFixedHeight:(CGFloat)height {
    float newWidth = self.size.width * (height / self.size.height);
    CGSize size = CGSizeMake(newWidth, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}
/// 通过比例来缩放图片
- (UIImage *)kj_scaleImage:(CGFloat)scale{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scale, self.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (UIImage *)kj_maskImage:(UIImage *)image MaskImage:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
        //        imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
    }
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    if (sourceImage != imageWithAlpha) CGImageRelease(imageWithAlpha);
    UIImage * retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}
/// 不拉升填充图片
- (UIImage *)kj_fitImageWithSize:(CGSize)size{
    CGFloat x,y,w,h;
    if ((self.size.width/self.size.height)<(size.width/size.height)) {
        y = 0.;
        h = size.height;
        w = self.size.width * h / self.size.height;
        x = (size.width - w) / 2.;
    }else {
        x = 0.;
        w = size.width;
        h = self.size.height * w / self.size.width;
        y = -(size.height - h) / 2.;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, h);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(x, y, w, h), self.CGImage);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}
/// 裁剪图片处理，以图片中心位置开始裁剪
- (UIImage *)kj_clipCenterImageWithSize:(CGSize)size{
    UIImage * aImage = self;
    CGFloat scale = MIN(aImage.size.width / [[UIScreen mainScreen] bounds].size.width,
                        aImage.size.height / [[UIScreen mainScreen] bounds].size.height);
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat w = size.width * scale;
    CGFloat h = size.height * scale;
    // 正面
    if (aImage.imageOrientation == UIImageOrientationUp) {
        x = (aImage.size.width - w) / 2.0;
        y = (aImage.size.height - h) / 2.0;
    }else if (aImage.imageOrientation == UIImageOrientationRight) {// 相机拍出来的照片是 right
        x = (aImage.size.height - w) / 2.0;
        y = (aImage.size.width - h) / 2.0;
    }
    // 裁剪
    CGImageRef cgRef = CGImageCreateWithImageInRect(aImage.CGImage, CGRectMake(x, y, w, h));
    UIImage * image = [UIImage imageWithCGImage:cgRef];
    CGImageRelease(cgRef);
    return image;
}

#pragma mark - 图片压缩
/// 压缩图片到指定大小
- (UIImage *)kj_compressTargetByte:(NSUInteger)maxLength{
    return [UIImage kj_compressImage:self TargetByte:maxLength];
}
+ (UIImage *)kj_compressImage:(UIImage *)image TargetByte:(NSUInteger)maxLength{
    CGFloat compression = 1.;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1,min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        }else if (data.length > maxLength) {
            max = compression;
        }else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)), (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return resultImage;
}
#pragma mark - UIKit方式
- (UIImage *)kj_UIKitChangeImageSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Quartz 2D
- (UIImage *)kj_QuartzChangeImageSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - ImageIO
- (UIImage *)kj_ImageIOChangeImageSize:(CGSize)size{
    NSData *date = UIImagePNGRepresentation(self);
    int max = (int)MAX(size.width, size.height);
    CFDictionaryRef dictionaryRef = (__bridge CFDictionaryRef) @{(id)kCGImageSourceCreateThumbnailFromImageIfAbsent : @(YES),
                                                                 (id)kCGImageSourceThumbnailMaxPixelSize : @(max),
                                                                 (id)kCGImageSourceShouldCache : @(YES)};
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)date, nil);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(src, 0, dictionaryRef);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    if (imageRef != nil) CFRelease(imageRef);
    CFRelease(src);
    return newImage;
}
#pragma mark - 动态图板块
- (BOOL)isGif{
    return (self.images != nil);
}
+ (UIImage *)kj_gifLocalityImageWithName:(NSString *)name{
    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"gif"]];
    return [self kj_gifImageWithData:localData];
}
+ (UIImage *)kj_gifImageWithData:(NSData*)data {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData(GIFTOCF data, NULL));
}
+ (UIImage *)kj_gifImageWithURL:(NSURL *)URL {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL(GIFTOCF URL, NULL));
}
static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties) {
            NSNumber *number = GIFFROMCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (number == NULL || [number doubleValue] == 0) {
                number = GIFFROMCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([number doubleValue] > 0) delayCentiseconds = (int)lrint([number doubleValue] * 100);
        }
        CFRelease(properties);
    }
    return delayCentiseconds;
}
static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}
static int sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}
static int pairGCD(int a, int b) {
    if (a < b) return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0) return b;
        a = b;
        b = r;
    }
}
static int vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}
static NSArray * frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}
static void releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage * animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count];
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage * animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef CF_RELEASES_ARGUMENT source) {
    if (source) {
        UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    }else {
        return nil;
    }
}
/// 动态图和网图播放
+ (UIImage *)kj_playImageWithData:(NSData*)data{
    if (data == nil) return nil;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData(CFBridgingRetain(data), nil);
    size_t imageCount = CGImageSourceGetCount(imageSource);
    UIImage *animatedImage;
    if (imageCount <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }else{
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageCount];
        NSTimeInterval time = 0;
        for (int i = 0; i<imageCount; i++) {
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil);
            [images addObject:[UIImage imageWithCGImage:cgImage]];
            CGImageRelease(cgImage);
            CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, NULL);
            CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
            NSNumber *duration = (__bridge id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (duration == NULL || [duration doubleValue] == 0) {
                duration = (__bridge id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            CFRelease(properties);
            time += duration.doubleValue;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:time];
    }
    CFRelease(imageSource);
    return animatedImage;
}

/// 子线程处理动态图
void kPlayGifImageData(void(^xxblock)(bool isgif, UIImage * image), NSData *data){
    if (xxblock) {
        if (data == nil || data.length == 0) xxblock(false,nil);
        kGCD_async(^{
            CGImageSourceRef imageSource = CGImageSourceCreateWithData(CFBridgingRetain(data), nil);
            size_t count = CGImageSourceGetCount(imageSource);
            if (count <= 1) {
                UIImage *animatedImage = [[UIImage alloc] initWithData:data];
                kGCD_main(^{
                    xxblock(false,animatedImage);
                });
            }else{
                NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
                NSTimeInterval time = 0;
                for (int i = 0; i<count; i++) {
                    CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil);
                    [images addObject:[UIImage imageWithCGImage:cgImage]];
                    CGImageRelease(cgImage);
                    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, NULL);
                    CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
                    NSNumber *duration = (__bridge id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
                    if (duration == NULL || [duration doubleValue] == 0) {
                        duration = (__bridge id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
                    }
                    CFRelease(properties);
                    time += duration.doubleValue;
                }
                UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:time];
                kGCD_main(^{
                    xxblock(true,animatedImage);
                });
            }
            CFRelease(imageSource);
        });
    }
}

#pragma mark - 获取网络图片尺寸
+ (CGSize)kj_imageGetSizeWithURL:(NSURL *)URL{
    if (!URL) return CGSizeZero;
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)URL, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationRight:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRightMirrored:{
                    temp = width;
                    width = height;
                    height = temp;
                } break;
                default:break;
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

/// 异步获取网络图片大小
+ (CGSize)kj_imageAsyncGetSizeWithURL:(NSURL *)URL{
    if (!URL) return CGSizeZero;
    __block CGSize imageSize = CGSizeZero;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_async(dispatch_group_create(), queue, ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
        [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
            if ([response.MIMEType isEqualToString:@"image/jpeg"]) {
                imageSize = [self jpgImageSizeWithHeaderData:[data subdataWithRange:NSMakeRange(0,210)]];
            }else if ([response.MIMEType isEqualToString:@"image/png"]) {
                imageSize = [self pngImageSizeWithHeaderData:[data subdataWithRange:NSMakeRange(16,23)]];
            }else if ([response.MIMEType isEqualToString:@"image/gif"]) {
                imageSize = [self gifImageSizeWithHeaderData:[data subdataWithRange:NSMakeRange(6,9)]];
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return imageSize;
}
+ (CGSize)pngImageSizeWithHeaderData:(NSData*)data {
    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
    return (CGSizeMake(w, h));
}
+ (CGSize)jpgImageSizeWithHeaderData:(NSData*)data {
    if ([data length] <= 0x58) return (CGSizeZero);
    if ([data length] < 210) {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return (CGSizeMake(w, h));
    }else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return (CGSizeMake(w, h));
            }else {
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return (CGSizeMake(w, h));
            }
        }else {
            return (CGSizeZero);
        }
    }
}
+ (CGSize)gifImageSizeWithHeaderData:(NSData*)data {
    short w1 = 0, w2 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    short w = w1 + (w2 << 8);
    short h1 = 0, h2 = 0;
    [data getBytes:&h1 range:NSMakeRange(2, 1)];
    [data getBytes:&h2 range:NSMakeRange(3, 1)];
    short h = h1 + (h2 << 8);
    return (CGSizeMake(w, h));
}

#pragma mark - 图片拼接相关处理
/// 随意张拼接图片
- (UIImage *)kj_moreJointVerticalImage:(UIImage *)jointImage,...{
    NSMutableArray<UIImage*>* temps = [NSMutableArray arrayWithObjects:self,jointImage,nil];
    CGSize size = self.size;
    CGFloat w = size.width;
    size.height += w*jointImage.size.height/jointImage.size.width;
    
    va_list args;UIImage *tempImage;
    va_start(args, jointImage);
    while ((tempImage = va_arg(args, UIImage*))) {
        size.height += w*tempImage.size.height/tempImage.size.width;
        [temps addObject:tempImage];
    }
    va_end(args);
    UIGraphicsBeginImageContext(size);
    CGFloat y = 0;
    for (UIImage *img in temps) {
        CGFloat h = w*img.size.height/img.size.width;
        [img drawInRect:CGRectMake(0, y, w, h)];
        y += h;
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
/// 水平方向拼接随意张图片
- (UIImage *)kj_moreJointLevelImage:(UIImage *)jointImage,...{
    NSMutableArray<UIImage*>* temps = [NSMutableArray arrayWithObjects:self,jointImage,nil];
    CGSize size = self.size;
    CGFloat h = size.height;
    size.width += h*jointImage.size.width/jointImage.size.height;
    
    va_list args;UIImage *tempImage;
    va_start(args, jointImage);
    while ((tempImage = va_arg(args, UIImage*))) {
        size.width += h*tempImage.size.width/tempImage.size.height;
        [temps addObject:tempImage];
    }
    va_end(args);
    UIGraphicsBeginImageContext(size);
    CGFloat x = 0;
    for (UIImage *img in temps) {
        CGFloat w = h*img.size.width/img.size.height;
        [img drawInRect:CGRectMake(x, 0, w, h)];
        x += w;
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
/// 图片多次合成处理
- (UIImage *)kj_imageCompoundWithLoopNums:(NSInteger)loopNums orientation:(UIImageOrientation)orientation{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGFloat X = 0,Y = 0;
    switch (orientation) {
        case UIImageOrientationUp:
            for (int i = 0; i < loopNums; i++) {
                CGFloat W = self.size.width / loopNums;
                CGFloat H = self.size.height;
                X = W * i;
                [self drawInRect:CGRectMake(X, Y, W, H)];
            }
            break;
        case UIImageOrientationLeft:
            for (int i = 0; i < loopNums; i++) {
                CGFloat W = self.size.width;
                CGFloat H = self.size.height / loopNums;
                Y = H * i;
                [self drawInRect:CGRectMake(X, Y, W, H)];
            }
            break;
        case UIImageOrientationRight:
            for (int i = 0; i < loopNums; i++) {
                CGFloat W = self.size.width;
                CGFloat H = self.size.height / loopNums;
                Y = H * i;
                [self drawInRect:CGRectMake(X, Y, W, H)];
            }
            break;
        default:
            break;
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
#pragma mark - CoreGraphics
/// 水平方向拼接随意张图片，固定主图的高度
- (UIImage *)kj_moreCoreGraphicsJointLevelImage:(UIImage *)jointImage,...{
    NSMutableArray<UIImage*>* temps = [NSMutableArray arrayWithObjects:self,jointImage,nil];
    CGSize size = self.size;
    CGFloat h = size.height;
    size.width += h*jointImage.size.width/jointImage.size.height;
    
    va_list args;UIImage *tempImage;
    va_start(args, jointImage);
    while ((tempImage = va_arg(args, UIImage*))) {
        size.width += h*tempImage.size.width/tempImage.size.height;
        [temps addObject:tempImage];
    }
    va_end(args);
    
    const size_t width = size.width, height = size.height;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 space,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(space);
    if (!context) return nil;
    CGFloat x = 0;
    for (UIImage *img in temps) {
        CGFloat w = h*img.size.width/img.size.height;
        CGContextDrawImage(context, CGRectMake(x, 0, w, h), img.CGImage);
        x += w;
    }
    UInt8 * data = (UInt8*)CGBitmapContextGetData(context);
    if (!data){
        CGContextRelease(context);
        return nil;
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return newImage;
}
/// 图片拼接艺术
- (UIImage *)kj_jointImageWithJointType:(KJJointImageType)type size:(CGSize)size maxwidth:(CGFloat)maxw{
    CGFloat scale = [UIScreen mainScreen].scale;
    const size_t width = size.width * scale, height = size.height * scale;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 space,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(space);
    if (!context) return nil;
    CGFloat maxh = (maxw*self.size.height)/self.size.width;
    int row = (int)ceilf(size.width/maxw);
    int col = (int)ceilf(size.height/maxh);
    UIImage *tempImage = nil;
    if (type == 3) {
        tempImage = [self kj_rotationImageWithOrientation:UIImageOrientationUpMirrored];
    }else if (type == 4) {
        tempImage = [self kj_rotationImageWithOrientation:UIImageOrientationDownMirrored];
    }
    __block CGFloat x = 0,y = 0;
    void (^kDrawImage)(UIImage *) = ^(UIImage *image) {
        //宽高+1，解决拼接中间的空隙
        CGContextDrawImage(context, CGRectMake(x, y, maxw*scale+1, maxh*scale+1), image.CGImage);
    };
    for (int i = 0; i < row; i++) {
        for (int k = 0; k < col; k++) {
            x = maxw * i * scale;y = maxh * k * scale;
            if (type == 0) {
                kDrawImage(self);
            }else if (type == 1) {
                if (i&1) {
                    y += maxh*scale/2;
                    if (k+1 == col) kDrawImage(self);
                    y -= maxh*scale;
                }
                kDrawImage(self);
            }else if (type == 2) {
                if (!(i&1)) {
                    y += maxh*scale/2;
                    if (k+1 == col) kDrawImage(self);
                    y -= maxh*scale;
                }
                kDrawImage(self);
            }else if (type == 3) {
                kDrawImage(i&1 ? tempImage : self);
            }else if (type == 4) {
                kDrawImage(k%2 ? tempImage : self);
            }
        }
    }
    UInt8 * data = (UInt8*)CGBitmapContextGetData(context);
    if (!data){
        CGContextRelease(context);
        return nil;
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return newImage;
}
/// 异步图片拼接处理
- (void)kj_asyncJointImage:(void(^)(UIImage *image))block
                 jointType:(KJJointImageType)type
                      size:(CGSize)size
                      maxwidth:(CGFloat)maxw{
    UIImage *selfImage = self;
    CGFloat scale = [UIScreen mainScreen].scale;
    const size_t width = size.width * scale, height = size.height * scale;
    CGFloat maxh = (maxw*self.size.height)/self.size.width;
    int row = (int)ceilf(size.width/maxw);
    int col = (int)ceilf(size.height/maxh);
    __weak __typeof(&*self) weakself = self;
    kGCD_async(^{
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     8,
                                                     width * 4,
                                                     space,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
        CGColorSpaceRelease(space);
        if (!context) {
            kGCD_main(^{block(nil);});
            return;
        }
        UIImage *tempImage = nil;
        if (type == 3) {
            tempImage = [weakself kj_rotationImageWithOrientation:UIImageOrientationUpMirrored];
        }else if (type == 4) {
            tempImage = [weakself kj_rotationImageWithOrientation:UIImageOrientationDownMirrored];
        }
        __block CGFloat x = 0,y = 0;
        void (^kDrawImage)(UIImage *) = ^(UIImage *image) {
            //宽高+1，解决拼接中间的空隙
            CGContextDrawImage(context, CGRectMake(x, y, maxw*scale+1, maxh*scale+1), image.CGImage);
        };
        for (int i = 0; i < row; i++) {
            for (int k = 0; k < col; k++) {
                x = maxw * i * scale;y = maxh * k * scale;
                if (type == 0) {
                    kDrawImage(selfImage);
                }else if (type == 1) {
                    if (i&1) {//相当于%2
                        y += maxh*scale/2;
                        if (k+1 == col) kDrawImage(selfImage);
                        y -= maxh*scale;
                    }
                    kDrawImage(selfImage);
                }else if (type == 2) {
                    if (!(i&1)) {
                        y += maxh*scale/2;
                        if (k+1 == col) kDrawImage(selfImage);
                        y -= maxh*scale;
                    }
                    kDrawImage(selfImage);
                }else if (type == 3) {
                    kDrawImage(i&1 ? tempImage : selfImage);
                }else if (type == 4) {
                    kDrawImage(k%2 ? tempImage : selfImage);
                }
            }
        }
        UInt8 * data = (UInt8*)CGBitmapContextGetData(context);
        if (!data){
            CGContextRelease(context);
            kGCD_main(^{block(nil);});
            return;
        }
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *newImage = [UIImage imageWithCGImage:imageRef];
        kGCD_main(^{
            block(newImage);
        });
        CGImageRelease(imageRef);
        CGContextRelease(context);
    });
}

#pragma mark - 水印蒙版处理
/// 文字水印
- (UIImage *)kj_waterText:(NSString *)text
                direction:(KJImageWaterType)direction
                textColor:(UIColor *)color
                     font:(UIFont *)font
                   margin:(CGPoint)margin{
    CGRect rect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [self drawInRect:rect];
    NSDictionary *dict = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    CGRect calRect = [self kj_rectWithRect:rect size:[text sizeWithAttributes:dict] direction:direction margin:margin];
    [text drawInRect:calRect withAttributes:dict];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/// 图片水印
- (UIImage *)kj_waterImage:(UIImage *)image direction:(KJImageWaterType)direction waterSize:(CGSize)size margin:(CGPoint)margin{
    CGRect rect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [self drawInRect:rect];
    CGSize waterImageSize = CGSizeEqualToSize(size, CGSizeZero) ? image.size : size;
    CGRect waterRect = [self kj_rectWithRect:rect size:waterImageSize direction:direction margin:margin];
    [image drawInRect:waterRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (CGRect)kj_rectWithRect:(CGRect)rect size:(CGSize)size direction:(KJImageWaterType)direction margin:(CGPoint)margin{
    CGPoint point = CGPointZero;
    switch (direction) {
        case KJImageWaterTypeTopLeft:
            break;
        case KJImageWaterTypeTopRight:
            point = CGPointMake(rect.size.width - size.width, 0);
            break;
        case KJImageWaterTypeBottomRight:
            point = CGPointMake(rect.size.width - size.width, rect.size.height - size.height);
            break;
        case KJImageWaterTypeCenter:
            point = CGPointMake((rect.size.width - size.width)*.5f, (rect.size.height - size.height)*.5f);
            break;
        default:
            break;
    }
    point.x += margin.x;
    point.y += margin.y;
    return (CGRect){point,size};
}

// 画水印
- (UIImage *)kj_waterMark:(UIImage *)mark InRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGRect imgRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:imgRect];
    [mark drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
/// 蒙版图片处理
- (UIImage *)kj_maskImage:(UIImage *)maskImage{
    UIImage *image = self;
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
        //        imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
    }
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    if (sourceImage != imageWithAlpha) CGImageRelease(imageWithAlpha);
    UIImage * retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}

#pragma mark - CoreGraphics板块
/// 裁剪掉图片周围的透明部分
- (UIImage *)kj_cutImageRoundAlphaZero{
    UIImage *image = self;
    CGImageRef cgimage = [image CGImage];
    size_t width  = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char));
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    int top = 0,left = 0,right = 0,bottom = 0;
    for (size_t row = 0; row < height; row++) {
        BOOL find = false;
        for (size_t col = 0; col < width; col++) {
            size_t pixelIndex = (row * width + col) * 4;
            int alpha = data[pixelIndex + 3];
            if (alpha != 0) {
                find = YES;
                break;
            }
        }
        if (find) break;
        top ++;
    }
    for (size_t col = 0; col < width; col++) {
        BOOL find = false;
        for (size_t row = 0; row < height; row++) {
            size_t pixelIndex = (row * width + col) * 4;
            int alpha = data[pixelIndex + 3];
            if (alpha != 0) {
                find = YES;
                break;
            }
        }
        if (find) break;
        left ++;
    }
    for (size_t col = width - 1; col > 0; col--) {
        BOOL find = false;
        for (size_t row = 0; row < height; row++) {
            size_t pixelIndex = (row * width + col) * 4;
            int alpha = data[pixelIndex + 3];
            if (alpha != 0) {
                find = YES;
                break;
            }
        }
        if (find) break;
        right ++;
    }
    
    for (size_t row = height - 1; row > 0; row--) {
        BOOL find = false;
        for (size_t col = 0; col < width; col++) {
            size_t pixelIndex = (row * width + col) * 4;
            int alpha = data[pixelIndex + 3];
            if (alpha != 0) {
                find = YES;
                break;
            }
        }
        if (find) break;
        bottom ++;
    }
    
    CGFloat scale = image.scale;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(cgimage, CGRectMake(left*scale,
                                                                              top*scale,
                                                                              (image.size.width-left-right)*scale,
                                                                              (image.size.height-top-bottom)*scale));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGContextRelease(context);
    CGColorSpaceRelease(space);
    CGImageRelease(newImageRef);
    free(data);
    return newImage;
}

/// 图片压缩
- (UIImage *)kj_BitmapChangeImageSize:(CGSize)size{
    const size_t width = size.width, height = size.height;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 space,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(space);
    if (!context) return nil;
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 * data = (UInt8*)CGBitmapContextGetData(context);
    if (!data){
        CGContextRelease(context);
        return nil;
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return newImage;
}

#pragma mark - 其他相关
/// 保存到相册
static char kSavePhotosKey;
- (void)kj_saveImageToPhotosAlbum:(void(^)(BOOL success))complete{
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    objc_setAssociatedObject(self, &kSavePhotosKey, complete, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    void(^block)(BOOL success) = objc_getAssociatedObject(self, &kSavePhotosKey);
    if (block) block(error == nil ? YES : NO);
}
/// 渐变色图片，0：从上到下，1：从左到右，2：从左上到右下，3：从右上到左下
//UIImage * kGradientColorImage(CGSize size, int direction, UIColor *color,...){
//    if (direction <= 0) {
//        direction = 0;
//    }else if (direction >= 3) {
//        direction = 3;
//    }
//    return [UIImage kj_gradientImageColor:color](size,direction);
//}
+ (UIImage*(^)(CGSize,int))kj_gradientImageColor:(UIColor *)color,...{
    NSMutableArray * temps = [NSMutableArray arrayWithObjects:(id)color.CGColor,nil];
    va_list args;UIColor * arg;
    va_start(args, color);
    while ((arg = va_arg(args, UIColor *))) {
        [temps addObject:(id)arg.CGColor];
    }
    va_end(args);
    return ^UIImage * (CGSize size, int index){
        UIGraphicsBeginImageContextWithOptions(size, YES, 1);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGColorSpaceRef colorSpace = CGColorGetColorSpace([[temps lastObject] CGColor]);
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)temps, NULL);
        CGPoint start = CGPointZero,end = CGPointZero;
        switch (index) {
            case 0:
                start = CGPointMake(0.0, 0.0);
                end = CGPointMake(0.0, size.height);
                break;
            case 1:
                start = CGPointMake(0.0, 0.0);
                end = CGPointMake(size.width, 0.0);
                break;
            case 2:
                start = CGPointMake(0.0, 0.0);
                end = CGPointMake(size.width, size.height);
                break;
            case 3:
                start = CGPointMake(size.width, 0.0);
                end = CGPointMake(0.0, size.height);
                break;
            default:
                break;
        }
        CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        CGGradientRelease(gradient);
        CGContextRestoreGState(context);
        UIGraphicsEndImageContext();
        return image;
    };
}
/// 旋转图片和镜像处理
- (UIImage *)kj_rotationImageWithOrientation:(UIImageOrientation)orientation{
    CGRect rect = CGRectMake(0, 0, CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
    CGRect bounds = rect;
    CGRect (^kSwapWidthAndHeight)(CGRect) = ^CGRect(CGRect rect) {
        CGFloat swap = rect.size.width;
        rect.size.width  = rect.size.height;
        rect.size.height = swap;
        return rect;
    };
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIImageOrientationUp:
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(rect.size.width,rect.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeft:
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeftMirrored:
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeTranslation(rect.size.height,rect.size.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored:
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (orientation){
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(context, -1.0, 1.0);
            CGContextTranslateCTM(context, -rect.size.height, 0.0);
            break;
        default:
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0.0, -rect.size.height);
            break;
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/// 椭圆形图片
- (UIImage *)kj_ellipseImage{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 圆形图片
- (UIImage *)kj_circleImage{
    CGFloat width = MIN(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, width, width));
    CGContextClip(ctx);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 边框圆形图片
- (UIImage *)kj_squareCircleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    CGFloat width = self.size.width + 2 * borderWidth;
    CGFloat height = width;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [borderColor set];
    CGFloat bigRadius = width * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(context);
    [self drawInRect:CGRectMake(borderWidth, borderWidth, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/// 透明图片穿透
- (bool)kj_transparentWithPoint:(CGPoint)point{
    unsigned char pixel[1] = {0};
    CGContextRef context = CGBitmapContextCreate(pixel,1,1,8,1,NULL,kCGImageAlphaOnly);
    UIGraphicsPushContext(context);
    [self drawAtPoint:CGPointMake(-point.x, -point.y)];
    UIGraphicsPopContext();
    CGContextRelease(context);
    CGFloat alpha = pixel[0]/255.0f;
    return alpha < 0.01f;
}
/// 获取图片平均颜色
- (UIColor *)kj_getImageAverageColor{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0,0,1,1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    if (rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat mu = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*mu
                               green:((CGFloat)rgba[1])*mu
                                blue:((CGFloat)rgba[2])*mu
                               alpha:alpha];
    }else{
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}
/// 获得灰度图
- (UIImage *)kj_getGrayImage{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat w = self.size.width * scale;
    CGFloat h = self.size.height * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    //使用kCGImageAlphaPremultipliedLast保留Alpha通道，避免透明区域变成黑色
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 w,
                                                 h,
                                                 8,
                                                 0,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context,CGRectMake(0,0,w,h),[self CGImage]);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(imageRef);
    return newImage;
}
/// 改变图片透明度
- (UIImage *)kj_changeImageAlpha:(CGFloat)alpha{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/// 改变图片颜色
- (UIImage *)kj_changeImageColor:(UIColor *)color{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*2, self.size.height*2));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width * 2, self.size.height * 2);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, self.CGImage);
    [color set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
/// 修改图片颜色
- (UIImage *)kj_imageLinellaeColor:(UIColor *)color{
    return [self kj_imageBlendMode:kCGBlendModeDestinationIn TineColor:color];
}
/// 图层混合
- (UIImage *)kj_imageBlendMode:(CGBlendMode)blendMode TineColor:(UIColor *)tintColor{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}
/* 绘制图片 */
- (UIImage *)kj_mallocDrawImage{
    CGImageRef cgimage = self.CGImage;
    size_t width  = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    UInt32 *data = (UInt32*)calloc(width * height * 4, sizeof(UInt32));
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    for (size_t i = 10; i < height; i++){
        for (size_t j = 10; j < width; j++){
            size_t pixelIndex = i * width * 4 + j * 4;
            UInt32 red   = data[pixelIndex];
            UInt32 green = data[pixelIndex + 1];
            UInt32 blue  = data[pixelIndex + 2];
            //过滤代码
            if ((red < 0x2f && red > 0x07) && (green < 0xa0 && green > 0x84) && (blue < 0xbf && blue > 0xa8)) {
                data[pixelIndex] = 255;
                data[pixelIndex + 1] = 255;
                data[pixelIndex + 2] = 255;
            }
        }
    }
    cgimage = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:cgimage];
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    CGImageRelease(cgimage);
    free(data);
    return newImage;
}
/// 改变图片亮度
- (UIImage *)kj_changeImageLuminance:(CGFloat)luminance{
    CGImageRef cgimage = self.CGImage;
    size_t width  = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    UInt32 * data = (UInt32 *)calloc(width * height * 4, sizeof(UInt32));
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    for (size_t i = 0; i < height; i++){
        for (size_t j = 0; j < width; j++){
            size_t pixelIndex = i * width * 4 + j * 4;
            UInt32 red   = data[pixelIndex];
            UInt32 green = data[pixelIndex + 1];
            UInt32 blue  = data[pixelIndex + 2];
            red += luminance;
            green += luminance;
            blue += luminance;
            data[pixelIndex]     = red > 255 ? 255 : red;
            data[pixelIndex + 1] = green > 255 ? 255 : green;
            data[pixelIndex + 2] = blue > 255 ? 255 : blue;
        }
    }
    cgimage = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:cgimage];
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    CGImageRelease(cgimage);
    free(data);
    return newImage;
}

@end
