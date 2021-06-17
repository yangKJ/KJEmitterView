//
//  UILabel+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/9/24.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  文本位置和尺寸获取

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// Label 文本显示样式
typedef NS_ENUM(NSUInteger, KJLabelTextAlignmentType) {
    KJLabelTextAlignmentTypeLeft = 0,
    KJLabelTextAlignmentTypeRight,
    KJLabelTextAlignmentTypeCenter,
    KJLabelTextAlignmentTypeLeftTop,
    KJLabelTextAlignmentTypeRightTop,
    KJLabelTextAlignmentTypeLeftBottom,
    KJLabelTextAlignmentTypeRightBottom,
    KJLabelTextAlignmentTypeTopCenter,
    KJLabelTextAlignmentTypeBottomCenter,
};
@interface UILabel (KJExtension)
/// 设置文字内容显示位置，外部不需要再去设置 " textAlignment " 属性
@property(nonatomic,assign)KJLabelTextAlignmentType customTextAlignment;
/// 获取宽度
- (CGFloat)kj_calculateWidth;
/// 获取高度
- (CGFloat)kj_calculateHeightWithWidth:(CGFloat)width;
/// 获取高度，指定行高
- (CGFloat)kj_calculateHeightWithWidth:(CGFloat)width OneLineHeight:(CGFloat)height;
/// 获取文字尺寸
+ (CGSize)kj_calculateLabelSizeWithTitle:(NSString *)title
                                    font:(UIFont *)font
                       constrainedToSize:(CGSize)size
                           lineBreakMode:(NSLineBreakMode)lineBreakMode;
/// 改变行间距
- (void)kj_changeLineSpace:(float)space;
/// 改变字间距
- (void)kj_changeWordSpace:(float)space;
/// 改变行间距和段间距
- (void)kj_changeLineSpace:(float)space paragraphSpace:(float)paragraphSpace;
/// 改变行间距和字间距
- (void)kj_changeLineSpace:(float)lineSpace wordSpace:(float)wordSpace;

#pragma mark - 长按复制功能
/// 是否可以拷贝
@property(nonatomic,assign)BOOL copyable;
/// 移除拷贝长按手势
- (void)kj_removeCopyLongPressGestureRecognizer;

#pragma mark - 下拉菜单
/// TODO:下拉菜单扩展
- (UITableView *)kj_dropdownMenuTexts:(NSArray<NSString*> *)texts
                            MaxHeight:(CGFloat)height
                           selectText:(void(^)(NSString *string))block;

@end

NS_ASSUME_NONNULL_END
