//
//  UITextView+KJPlaceHolder.m
//  CategoryDemo
//
//  Created by 杨科军 on 2018/7/12.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UITextView+KJPlaceHolder.h"
#import <objc/runtime.h>

@implementation UITextView (KJPlaceHolder)
#pragma mark - swizzled
- (void)kj_placeHolder_dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [self kj_placeHolder_dealloc];
}
- (void)kj_placeHolder_layoutSubviews{
    if (self.placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat x = self.textContainer.lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self kj_placeHolder_layoutSubviews];
}
- (void)kj_placeHolder_setText:(NSString *)text{
    [self kj_placeHolder_setText:text];
    if (self.placeHolder) [self updatePlaceHolder];
}
#pragma mark - associated
- (NSString *)placeHolder{
    return objc_getAssociatedObject(self, @selector(placeHolder));
}
- (void)setPlaceHolder:(NSString *)placeHolder{
    objc_setAssociatedObject(self, @selector(placeHolder), placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")), class_getInstanceMethod(self.class, @selector(kj_placeHolder_layoutSubviews)));
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")), class_getInstanceMethod(self.class, @selector(kj_placeHolder_dealloc)));
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")), class_getInstanceMethod(self.class, @selector(kj_placeHolder_setText:)));
    });
    [self updatePlaceHolder];
}
#pragma mark - update
- (void)updatePlaceHolder{
    if (self.text.length){
        [self.placeHolderLabel removeFromSuperview];
        return;
    }
    self.placeHolderLabel.font = self.font;
    self.placeHolderLabel.textAlignment = self.textAlignment;
    self.placeHolderLabel.text = self.placeHolder;
    [self insertSubview:self.placeHolderLabel atIndex:0];
}
#pragma mark - lazzing
- (UILabel*)placeHolderLabel{
    UILabel *label = objc_getAssociatedObject(self, @selector(placeHolderLabel));
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(placeHolderLabel), label, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return label;
}

@end
