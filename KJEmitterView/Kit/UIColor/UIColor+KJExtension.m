//
//  UIColor+KJExtension.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/31.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UIColor+KJExtension.h"

@implementation UIColor (KJExtension)
- (CGFloat)red{
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}
- (CGFloat)green{
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}
- (CGFloat)blue{
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}
- (CGFloat)alpha{
    return CGColorGetAlpha(self.CGColor);
}
- (CGFloat)hue{
    CGFloat h = 0,s,l;
    [self kj_HSL:&h :&s :&l];
    return h;
}
- (CGFloat)saturation{
    CGFloat h,s = 0,l;
    [self kj_HSL:&h :&s :&l];
    return s;
}
- (CGFloat)light{
    CGFloat h,s,l = 0;
    [self kj_HSL:&h :&s :&l];
    return l;
}
/// 随机颜色
UIColor * kDoraemonBoxRandomColor(void){
    return [UIColor colorWithRed:((float)arc4random_uniform(256)/255.0)
                           green:((float)arc4random_uniform(256)/255.0)
                            blue:((float)arc4random_uniform(256)/255.0)
                           alpha:1.0];
}
/// 获取颜色对应的RGBA
- (void)kj_rgba:(CGFloat *)r :(CGFloat *)g :(CGFloat *)b :(CGFloat *)a{
    NSString *colorString = [NSString stringWithFormat:@"%@",self];
    NSArray *temps = [colorString componentsSeparatedByString:@" "];
    if (temps.count == 3 || temps.count == 4) {
        *r = [temps[1] floatValue];
        *g = [temps[2] floatValue];
        *b = [temps[3] floatValue];
        if (temps.count == 4) {
            *a = [temps[4] floatValue];
        }
    }
}
/// 获取颜色对应的色相饱和度和透明度
- (void)kj_HSL:(CGFloat *)h :(CGFloat *)s :(CGFloat *)l{
    CGFloat red,green,blue,alpha = 0.0f;
    BOOL success = [self getRed:&red green:&green blue:&blue alpha:&alpha];
    if (success == NO) {
        *h = 0;*s = 0;*l = 0;
        return;
    }
    CGFloat hue = 0;
    CGFloat saturation = 0;
    CGFloat light = 0;
    CGFloat min = MIN(red,MIN(green,blue));
    CGFloat max = MAX(red,MAX(green,blue));
    if (min == max) {
        hue = 0;
        saturation = 0;
        light = min;
    }else {
        CGFloat d = (red==min) ? green-blue : ((blue==min) ? red-green : blue-red);
        CGFloat h = (red==min) ? 3 : ((blue==min) ? 1 : 5);
        hue = (h - d / (max - min)) / 6.0;
        saturation = (max - min) / max;
        light = max;
    }
    hue = (2 * hue - 1) * M_PI;
    *h = hue;
    *s = saturation;
    *l = light;
}
/// 获取颜色的均值
+ (UIColor *)kj_averageColors:(NSArray<UIColor*>*)colors{
    if (!colors || colors.count == 0)  return nil;
    CGFloat reds = 0.0f;
    CGFloat greens = 0.0f;
    CGFloat blues = 0.0f;
    CGFloat alphas = 0.0f;
    NSInteger count = 0;
    for (UIColor *c in colors) {
        CGFloat red = 0.0f;
        CGFloat green = 0.0f;
        CGFloat blue = 0.0f;
        CGFloat alpha = 0.0f;
        BOOL success = [c getRed:&red green:&green blue:&blue alpha:&alpha];
        if (success) {
            reds += red;
            greens += green;
            blues += blue;
            alphas += alpha;
            count++;
        }
    }
    return [UIColor colorWithRed:reds/count green:greens/count blue:blues/count alpha:alphas/count];
}
/// 图片生成颜色
+ (UIColor*(^)(UIImage *))kj_imageColor{
    return ^(UIImage *image){
        return [UIColor colorWithPatternImage:image];
    };
}
/// 兼容Swift版本，可变参数渐变色
- (UIColor *)kj_gradientSize:(CGSize)size color:(UIColor *)color,...{
    NSMutableArray * colors = [NSMutableArray arrayWithObjects:(id)self.CGColor,(id)color.CGColor,nil];
    va_list args;UIColor * arg;
    va_start(args, color);
    while ((arg = va_arg(args, UIColor *))) {
        [colors addObject:(id)arg.CGColor];
    }
    va_end(args);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(size.width, size.height), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}
/// 可变参数方式渐变色
- (UIColor*(^)(CGSize))kj_gradientColor:(UIColor *)color,...{
    NSMutableArray * colors = [NSMutableArray arrayWithObjects:(id)self.CGColor,(id)color.CGColor,nil];
    va_list args;UIColor * arg;
    va_start(args, color);
    while ((arg = va_arg(args, UIColor *))) {
        [colors addObject:(id)arg.CGColor];
    }
    va_end(args);
    return ^UIColor*(CGSize size){
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
        CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(size.width, size.height), 0);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorspace);
        UIGraphicsEndImageContext();
        return [UIColor colorWithPatternImage:image];
    };
}
/// 渐变颜色
+ (UIColor *)kj_gradientColorWithColors:(NSArray *)colors GradientType:(KJGradietColorType)type Size:(CGSize)size{
    NSMutableArray *temps = [NSMutableArray array];
    for(UIColor *c in colors){
        [temps addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)temps, NULL);
    temps = nil;
    CGPoint start,end;
    switch (type) {
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
    return [UIColor colorWithPatternImage:image];
}
/// 渐变色
- (UIColor *)kj_gradientVerticalToColor:(UIColor *)color Height:(NSInteger)height{
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    NSArray * colors = [NSArray arrayWithObjects:(id)self.CGColor, (id)color.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}
- (UIColor *)kj_gradientAcrossToColor:(UIColor *)color Width:(NSInteger)width{
    CGSize size = CGSizeMake(width, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    NSArray * colors = [NSArray arrayWithObjects:(id)self.CGColor, (id)color.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, size.height), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}
// UIColor转#ffffff格式的16进制字符串
- (NSString *)kj_hexString{
    return [UIColor kj_hexStringFromColor:self];
}
+ (NSString *)kj_hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",lroundf(r*255),lroundf(g*255),lroundf(b*255)];
}
NSString *kDoraemonBoxHexStringFromColor(UIColor *color){
    return [UIColor kj_hexStringFromColor:color];
}
/// 16进制字符串转UIColor
UIColor * kDoraemonBoxColorHexString(NSString *hexString){
    return [UIColor kj_colorWithHexString:hexString];
}
+ (UIColor *)kj_colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha,red,blue,green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start,length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@",substring,substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

/// 生成渐变色图片
+ (UIImage *)kj_colorImageWithColors:(NSArray<UIColor*>*)colors locations:(NSArray<NSNumber*>*)locations size:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    NSAssert(colors || locations, @"colors and locations must has value");
    NSAssert(colors.count == locations.count, @"Please make sure colors and locations count is equal");
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (borderWidth > 0 && borderColor) {
        CGRect rect = CGRectMake(size.width * 0.01, 0, size.width * 0.98, size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:size.height*0.5];
        [borderColor setFill];
        [path fill];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(size.width * 0.01 + borderWidth,
                                                                            borderWidth,
                                                                            size.width * 0.98 - borderWidth * 2,
                                                                            size.height - borderWidth * 2)
                                                    cornerRadius:size.height * 0.5];
    [self kj_drawLinearGradient:context path:path.CGPath colors:colors locations:locations];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+ (void)kj_drawLinearGradient:(CGContextRef)context
                         path:(CGPathRef)path
                       colors:(NSArray<UIColor*>*)colors
                    locations:(NSArray<NSNumber*>*)locations{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colorefs = [@[] mutableCopy];
    [colors enumerateObjectsUsingBlock:^(UIColor *obj, NSUInteger idx, BOOL *stop) {
        [colorefs addObject:(__bridge id)obj.CGColor];
    }];
    CGFloat locs[locations.count];
    for (int i = 0; i < locations.count; i++) {
        locs[i] = locations[i].floatValue;
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorefs, locs);
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
/// 获取ImageView上指定点的图片颜色
+ (UIColor *)kj_colorAtImageView:(UIImageView*)imageView Point:(CGPoint)point{
    return [self kj_colorAtPixel:point Size:imageView.frame.size Image:imageView.image];
}
/// 获取图片上指定点的颜色
+ (UIColor *)kj_colorAtImage:(UIImage *)image Point:(CGPoint)point{
    return [self kj_colorAtPixel:point Size:image.size Image:image];
}
+ (UIColor *)kj_colorAtPixel:(CGPoint)point Size:(CGSize)size Image:(UIImage *)image{
    CGRect rect = CGRectMake(0,0,size.width,size.height);
    if (!CGRectContainsPoint(rect, point)) return nil;
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextTranslateCTM(context, -pointX, pointY - size.height);
    CGContextDrawImage(context, rect, cgImage);
    CGContextRelease(context);
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
