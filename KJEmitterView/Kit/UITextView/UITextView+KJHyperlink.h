//
//  UITextView+KJHyperlink.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/4.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  超链接点击处理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 定义网址结构体
typedef struct kURLCustom {
    UIColor *color;/// 文字颜色
    UIFont  *font; /// 文字尺寸
}URLCustom;
typedef void (^KJTextViewURLHyperlinkBlock)(NSString *URLString);
@interface UITextView (KJHyperlink)
/* 识别点击TextView里面的超链接网址地址
 备注事项：
 1、实现了委托UITextViewDelegate，外界再用会失效
 2、需要在调用此方法之前设置text内容 self.textView.text = @"xxxx";
 3、关闭了text的编辑功能
 4、默认URL地址颜色为蓝色
*/
- (NSArray *)kj_clickTextViewURLCustom:(URLCustom)custom URLHyperlink:(KJTextViewURLHyperlinkBlock)block;

@end

NS_ASSUME_NONNULL_END
