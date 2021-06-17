//
//  UILabel+KJExtension.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/9/24.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UILabel+KJExtension.h"
#import <objc/runtime.h>
@interface UILabel ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong) UITableView *tableView;
@end
@implementation UILabel (KJExtension)
- (KJLabelTextAlignmentType)customTextAlignment{
    return (KJLabelTextAlignmentType)[objc_getAssociatedObject(self, @selector(customTextAlignment)) integerValue];
}
- (void)setCustomTextAlignment:(KJLabelTextAlignmentType)customTextAlignment{
    objc_setAssociatedObject(self, @selector(customTextAlignment), @(customTextAlignment), OBJC_ASSOCIATION_ASSIGN);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(drawTextInRect:)),
                                       class_getInstanceMethod(self.class, @selector(kj_drawTextInRect:)));
    });
    switch (customTextAlignment) {
        case KJLabelTextAlignmentTypeRight:
        case KJLabelTextAlignmentTypeRightTop:
        case KJLabelTextAlignmentTypeRightBottom:
            self.textAlignment = NSTextAlignmentRight;
            break;
        case KJLabelTextAlignmentTypeLeft:
        case KJLabelTextAlignmentTypeLeftTop:
        case KJLabelTextAlignmentTypeLeftBottom:
            self.textAlignment = NSTextAlignmentLeft;
            break;
        case KJLabelTextAlignmentTypeCenter:
        case KJLabelTextAlignmentTypeTopCenter:
        case KJLabelTextAlignmentTypeBottomCenter:
            self.textAlignment = NSTextAlignmentCenter;
            break;
        default:
            break;
    }
}
- (void)kj_drawTextInRect:(CGRect)rect{
    switch (self.customTextAlignment) {
        case KJLabelTextAlignmentTypeRight:
        case KJLabelTextAlignmentTypeLeft:
        case KJLabelTextAlignmentTypeCenter:
            [self kj_drawTextInRect:rect];
            break;
        case KJLabelTextAlignmentTypeBottomCenter:
        case KJLabelTextAlignmentTypeLeftBottom:
        case KJLabelTextAlignmentTypeRightBottom:{
            CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
            textRect.origin = CGPointMake(textRect.origin.x, -CGRectGetMaxY(textRect)+rect.size.height);
            [self kj_drawTextInRect:textRect];
        }
            break;
        default:{
            CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
            [self kj_drawTextInRect:textRect];
        }
            break;
    }
}
/// 获取宽度
- (CGFloat)kj_calculateWidth{
    self.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [UILabel kj_calculateLabelSizeWithTitle:self.text
                                                     font:self.font
                                        constrainedToSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                            lineBreakMode:NSLineBreakByCharWrapping];
    return ceil(size.width);
}
/// 获取高度
- (CGFloat)kj_calculateHeightWithWidth:(CGFloat)width{
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [UILabel kj_calculateLabelSizeWithTitle:self.text
                                                     font:self.font
                                        constrainedToSize:CGSizeMake(width, MAXFLOAT)
                                            lineBreakMode:NSLineBreakByCharWrapping];
    return ceil(size.height);
}
/// 获取高度，指定行高
- (CGFloat)kj_calculateHeightWithWidth:(CGFloat)width OneLineHeight:(CGFloat)height{
    CGFloat newHeight = [self kj_calculateHeightWithWidth:width];
    return newHeight * height / self.font.lineHeight;
}
/// 获取文字尺寸
+ (CGSize)kj_calculateLabelSizeWithTitle:(NSString *)title font:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    if (title.length == 0) return CGSizeZero;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = lineBreakMode;
    CGRect frame = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraph}
                                       context:nil];
    return frame.size;
}
- (void)kj_changeLineSpace:(float)space {
    NSString *labelText = self.text;
    if (!labelText) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                             range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}
- (void)kj_changeLineSpace:(float)space paragraphSpace:(float)paragraphSpace{
    NSString *labelText = self.text;
    if (!labelText) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [paragraphStyle setParagraphSpacing:paragraphSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}
- (void)kj_changeWordSpace:(float)space {
    NSString *labelText = self.text;
    if (!labelText) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}
- (void)kj_changeLineSpace:(float)lineSpace wordSpace:(float)wordSpace {
    NSString *labelText = self.text;
    if (!labelText) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}


#pragma mark - 长按复制功能
- (BOOL)copyable{
    return [objc_getAssociatedObject(self, @selector(copyable)) boolValue];
}
- (void)setCopyable:(BOOL)copyable{
    objc_setAssociatedObject(self, @selector(copyable), @(copyable), OBJC_ASSOCIATION_ASSIGN);
    [self attachTapHandler];
}
/// 移除拷贝长按手势
- (void)kj_removeCopyLongPressGestureRecognizer{
    [self removeGestureRecognizer:self.copyGesture];
}
- (void)attachTapHandler{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:self.copyGesture];
}
- (void)handleTap:(UIGestureRecognizer*)recognizer{
    [self becomeFirstResponder];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"复制", nil) action:@selector(kj_copyText)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:item]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}
// 复制时执行的方法
- (void)kj_copyText{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    if (objc_getAssociatedObject(self, @"expectedText")) {
        board.string = objc_getAssociatedObject(self, @"expectedText");
    }else{
        if (self.text) {
            board.string = self.text;
        } else {
            board.string = self.attributedText.string;
        }
    }
}
- (BOOL)canBecomeFirstResponder{
    return [objc_getAssociatedObject(self, @selector(copyable)) boolValue];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(kj_copyText));
}
#pragma mark - lazzing
- (UILongPressGestureRecognizer*)copyGesture{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, @selector(copyGesture));
    if (gesture == nil) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        objc_setAssociatedObject(self, @selector(copyGesture), gesture, OBJC_ASSOCIATION_RETAIN);
    }
    return gesture;
}

#pragma mark - 下拉菜单
/// 下拉菜单扩展
- (UITableView*)kj_dropdownMenuTexts:(NSArray<NSString*>*)texts MaxHeight:(CGFloat)height selectText:(void(^)(NSString *string))block{
    UITableView *tableView;
    tableView.rowHeight = 30;
    return tableView;
}

@end
