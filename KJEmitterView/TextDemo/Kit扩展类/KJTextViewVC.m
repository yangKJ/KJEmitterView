//
//  KJTextViewVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/1.
//  Copyright © 2018 杨科军. All rights reserved.
//

#import "KJTextViewVC.h"
#import "UITextView+KJPlaceHolder.h"  // 输入框扩展
#import "UITextView+KJLimitCounter.h" // 限制字数
#import "UITextView+KJBackout.h" // 撤销输入
@interface KJTextViewVC ()
@property(nonatomic,strong)UITextView  *remarkTextView;//备注
@end

@implementation KJTextViewVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.remarkTextView];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(10, self.remarkTextView.bottom + 20, 100, 40);
    button.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.3];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = UIColor.blueColor.CGColor;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [button setTitle:@"撤销输入" forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    _weakself;
    [button kj_addAction:^(UIButton * _Nonnull kButton) {
        [weakself.remarkTextView kj_textViewBackout];
    }];
}

- (UITextView *)remarkTextView{
    if (!_remarkTextView){
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, kScreenW-20, 150)];
        textView.centerY = self.view.centerY - 100;
        textView.font = [UIFont systemFontOfSize:15];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.borderWidth = 1;
        
        textView.limitCount = 100;
        textView.limitHeight = 20;
        textView.limitMargin = 10;
        textView.limitLabel.textColor = UIColor.blueColor;
        
        textView.placeHolder = @"默认占位符文字";
        textView.placeHolderLabel.textColor = UIColor.orangeColor;
        
        textView.kOpenBackout = true;
        
        _remarkTextView = textView;
    }
    return _remarkTextView;
}

@end
