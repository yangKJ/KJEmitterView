//
//  UITextField+KJExtension.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/4.
//  https://github.com/yangKJ/KJEmitterView

#import "UITextField+KJExtension.h"
#import <objc/runtime.h>

@implementation UITextField (KJExtension)

static char placeholderColorKey,placeHolderFontSizeKey;
- (UIColor *)placeholderColor{
    return objc_getAssociatedObject(self, &placeholderColorKey);
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    objc_setAssociatedObject(self, &placeholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.placeholder) [self kj_setPlaceholder];
}
- (CGFloat)placeholderFontSize{
    return [objc_getAssociatedObject(self, &placeHolderFontSizeKey) floatValue];
}
- (void)setPlaceholderFontSize:(CGFloat)placeHolderFontSize{
    objc_setAssociatedObject(self, &placeHolderFontSizeKey, @(placeHolderFontSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.placeholder) [self kj_setPlaceholder];
}
- (void)kj_setPlaceholder{
    UIColor *color = objc_getAssociatedObject(self, &placeholderColorKey);
    CGFloat size = [objc_getAssociatedObject(self, &placeHolderFontSizeKey) floatValue];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (color) {
        [dict setValue:color forKey:NSForegroundColorAttributeName];
    }
    if (size) {
        [dict setValue:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
    }
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
}

@dynamic bottomLineColor;
- (void)setBottomLineColor:(UIColor *)bottomLineColor{
    [self layoutIfNeeded];
    CALayer *bottomLayer = [CALayer new];
    bottomLayer.frame = CGRectMake(0.0, CGRectGetHeight(self.bounds)-1, CGRectGetWidth(self.bounds), 1.0);
    bottomLayer.backgroundColor = bottomLineColor.CGColor;
    [self.layer addSublayer:bottomLayer];
}
- (NSInteger)maxLength{
    return [objc_getAssociatedObject(self, @selector(maxLength)) integerValue];
}
- (void)setMaxLength:(NSInteger)maxLength{
    objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(kj_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (void (^)(NSString * _Nonnull))kMaxLengthBolck{
    return objc_getAssociatedObject(self, @selector(kMaxLengthBolck));
}
- (void)setKMaxLengthBolck:(void (^)(NSString * _Nonnull))kMaxLengthBolck{
    objc_setAssociatedObject(self, @selector(kMaxLengthBolck), kMaxLengthBolck, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@dynamic securePasswords;
- (void)setSecurePasswords:(BOOL)mingwen{
    NSString *temp = self.text;
    self.text = @"";
    self.secureTextEntry = mingwen;
    self.text = temp;
}
@dynamic displayInputAccessoryView;
- (void)setDisplayInputAccessoryView:(BOOL)displayInputAccessoryView{
    if (!displayInputAccessoryView) {
        self.inputAccessoryView = [UIView new];
    }
}
- (void (^)(NSString * _Nonnull))kTextEditingChangedBolck{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setKTextEditingChangedBolck:(void (^)(NSString * _Nonnull))kTextEditingChangedBolck{
    objc_setAssociatedObject(self, @selector(kTextEditingChangedBolck), kTextEditingChangedBolck, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(kj_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - public Method
/// 设置左边视图，类似账号密码标题
- (UIView *)kj_leftView:(void(^)(KJTextFieldLeftInfo *info))block{
    KJTextFieldLeftInfo *info = [KJTextFieldLeftInfo new];
    if (block) block(info);
    UIView *view = [[UIView alloc]init];
    if (info.text && info.imageName) {
        UIImage *image = [UIImage imageNamed:info.imageName];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.tag = 520;
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 521;
        label.font = info.font?:self.font;
        label.text = info.text;
        label.textColor = info.textColor?:self.textColor;
        [view addSubview:label];
        
        CGFloat width = [self kj_calculateRectWithText:info.text
                                                  Size:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                                  font:label.font
                                             alignment:NSTextAlignmentLeft
                                         linebreakMode:NSLineBreakByWordWrapping
                                             lineSpace:0.0].width + 2.;
        CGFloat h = info.maxImageHeight?:self.frame.size.height/2;
        CGFloat w = image.size.width*h/image.size.height;
        if (info.minWidth > 0 && width < info.minWidth) width = info.minWidth;
        if (info.style == KJTextAndImageStyleNormal) {
            imageView.frame = CGRectMake(info.periphery, (self.frame.size.height-h)/2., w, h);
            label.frame = CGRectMake(info.periphery+w+info.padding, 0.0, width, self.frame.size.height);
        } else {
            label.frame = CGRectMake(info.periphery, 0.0, width, self.frame.size.height);
            imageView.frame = CGRectMake(info.periphery+width+info.padding, (self.frame.size.height-h)/2., w, h);
        }
        view.frame = CGRectMake(0, 0, info.periphery+label.frame.size.width+info.padding+imageView.frame.size.width, self.frame.size.height);
    }else if (info.imageName) {
        UIImage *image = [UIImage imageNamed:info.imageName];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.tag = 520;
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        
        CGFloat h = info.maxImageHeight?:self.frame.size.height/2;
        CGFloat width = image.size.width*h/image.size.height;
        if (info.minWidth > 0 && width < info.minWidth) width = info.minWidth;
        imageView.frame = CGRectMake(info.periphery, (self.frame.size.height-h)/2., width, h);
        view.frame = CGRectMake(0, 0, width+info.periphery, self.frame.size.height);
    }else if (info.text) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = 521;
        label.font = info.font?:self.font;
        label.text = info.text;
        label.textColor = info.textColor?:self.textColor;
        [view addSubview:label];
        
        CGFloat width = [self kj_calculateRectWithText:info.text
                                                  Size:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                                  font:label.font
                                             alignment:NSTextAlignmentLeft
                                         linebreakMode:NSLineBreakByWordWrapping
                                             lineSpace:0.0].width + 2.;
        if (info.minWidth > 0 && width < info.minWidth) width = info.minWidth;
        label.frame = CGRectMake(info.periphery, 0.0, width, self.frame.size.height);
        view.frame = CGRectMake(0, 0, width+info.periphery, self.frame.size.height);
    }else{
        return view;
    }
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
    return view;
}
/// 设置右边视图，类似小圆叉
static char tapActionKey;
- (UIButton *)kj_rightViewTapBlock:(void(^_Nullable)(BOOL state))block
                         imageName:(NSString *)imageName
                             width:(CGFloat)width
                           padding:(CGFloat)padding{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, width, self.frame.size.height);
    [button setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (block) {
        objc_setAssociatedObject(self, &tapActionKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [button addTarget:self action:@selector(tapAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width+padding, self.frame.size.height)];
    [view addSubview:button];
    self.rightView = view;
    self.rightViewMode = UITextFieldViewModeAlways;
    return button;
}
- (void)tapAction:(UIButton *)sender{
    void(^block)(bool state) = objc_getAssociatedObject(self, &tapActionKey);
    sender.selected = !sender.selected;
    if (block) block(sender.selected);
}

#pragma mark - private Method
/// 获取文本尺寸
- (CGSize)kj_calculateRectWithText:(NSString *)string
                              Size:(CGSize)size
                              font:(UIFont *)font
                         alignment:(NSTextAlignment)alignment
                     linebreakMode:(NSLineBreakMode)linebreakMode
                         lineSpace:(CGFloat)lineSpace{
    if (string.length == 0) return CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = linebreakMode;
    paragraphStyle.alignment = alignment;
    if (lineSpace > 0) paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize newSize = [string boundingRectWithSize:size
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                       attributes:attributes
                                          context:NULL].size;
    return CGSizeMake(ceil(newSize.width), ceil(newSize.height));
}
/// 最大输入限制
- (void)kj_textFieldChanged:(UITextField *)textField{
    if (self.kTextEditingChangedBolck) {
        self.kTextEditingChangedBolck(textField.text);
    }
    if (textField.maxLength <= 0) return;
    UITextPosition *position = [self positionFromPosition:[self markedTextRange].start offset:0];
    if (position == nil && textField.text.length > textField.maxLength) {
        textField.text = [self.text substringToIndex:self.maxLength];
        if (self.kMaxLengthBolck) {
            self.kMaxLengthBolck(textField.text);
        }
    }
}

@end

@implementation KJTextFieldLeftInfo

- (instancetype)init{
    if (self = [super init]) {
        self.padding = 5;
    }
    return self;
}

@end
