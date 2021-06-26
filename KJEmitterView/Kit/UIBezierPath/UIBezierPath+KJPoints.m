//
//  UIBezierPath+KJPoints.m
//  AutoDecorate
//
//  Created by 杨科军 on 2019/7/8.
//  Copyright © 2020 songxf. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UIBezierPath+KJPoints.h"
#import <CoreText/CTFont.h>
#import <CoreText/CTLine.h>
#import <CoreText/CTRun.h>
#import <CoreText/CTStringAttributes.h>

@implementation UIBezierPath (KJPoints)

- (NSArray *)points{
    NSMutableArray *temps = [NSMutableArray array];
    CGPathApply(self.CGPath, (__bridge void *)temps, kGetBezierPathPoints);
    return temps.mutableCopy;
}
static void kGetBezierPathPoints(void *info, const CGPathElement * element){
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    if (type != kCGPathElementCloseSubpath) {
        [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
        if ((type != kCGPathElementAddLineToPoint) && (type != kCGPathElementMoveToPoint)) {
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
        }
    }
    if (type == kCGPathElementAddCurveToPoint) {
        [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
    }
}
/// 圆滑贝塞尔曲线
- (UIBezierPath *)kj_smoothedPathWithGranularity:(int)granularity{
    NSArray * points = self.points;
    if (points.count < 4) return self;
    
    CGPoint(^kPOINT)(NSUInteger) = ^CGPoint(NSUInteger index){
        return [(NSValue *)[points objectAtIndex:index] CGPointValue];
    };
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    smoothedPath.lineWidth = self.lineWidth;
    [smoothedPath moveToPoint:kPOINT(0)];
    [smoothedPath addLineToPoint:kPOINT(1)];
    for (int index = 3; index < points.count; index ++) {
        CGPoint p0 = kPOINT(index - 3);
        CGPoint p1 = kPOINT(index - 2);
        CGPoint p2 = kPOINT(index - 1);
        CGPoint p3 = kPOINT(index);
        for (int i = 1; i < granularity; i++) {
            float t = (float)i * (1.0 / granularity);
            float tt = t * t;
            float ttt = tt * t;
            CGPoint pi;
            pi.x = 0.5 * ( 2*p1.x + (p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt );
            pi.y = 0.5 * ( 2*p1.y + (p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt );
            [smoothedPath addLineToPoint:pi];
        }
        [smoothedPath addLineToPoint:p2];
    }
    [smoothedPath addLineToPoint:kPOINT(points.count - 1)];
    return smoothedPath;
}
/// 获取文字贝塞尔路径
+ (UIBezierPath *)kj_bezierPathWithText:(NSString *)text Font:(UIFont *)font{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    if (!ctFont) return nil;
    NSDictionary *attrs = @{ (__bridge id)kCTFontAttributeName:(__bridge id)ctFont };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    CFRelease(ctFont);
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)attrString);
    if (!line) return nil;
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    for (CFIndex iRun = 0, iRunMax = CFArrayGetCount(runs); iRun < iRunMax; iRun++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runs, iRun);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        for (CFIndex iGlyph = 0, iGlyphMax = CTRunGetGlyphCount(run); iGlyph < iGlyphMax; iGlyph++) {
            CFRange glyphRange = CFRangeMake(iGlyph, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            CTRunGetPositions(run, glyphRange, &position);
            CGPathRef glyphPath = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            if (glyphPath) {
                CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(cgPath, &transform, glyphPath);
                CGPathRelease(glyphPath);
            }
        }
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGRect boundingBox = CGPathGetPathBoundingBox(cgPath);
    CFRelease(cgPath);
    CFRelease(line);
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    return path;
}

@end
