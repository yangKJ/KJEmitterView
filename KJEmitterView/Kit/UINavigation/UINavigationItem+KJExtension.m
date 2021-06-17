//
//  UINavigationItem+KJExtension.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/1.
//  Copyright © 2018 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "UINavigationItem+KJExtension.h"

@implementation KJNavigationItemInfo
- (instancetype)init{
    if (self=[super init]) {
        self.color = UIColor.whiteColor;
        self.isLeft = YES;
    }
    return self;
}
@end
@implementation UINavigationItem (KJExtension)
/// 链式生成
- (instancetype)kj_makeNavigationItem:(void(^)(UINavigationItem *make))block{
    if (block) block(self);
    return self;
}

- (UIBarButtonItem *)kj_barButtonItemWithTitle:(NSString *)title
                                    TitleColor:(UIColor *)color
                                         Image:(UIImage *)image
                                     TintColor:(UIColor *)tintColor
                                   ButtonBlock:(KJButtonBlock)block
                                BarButtonBlock:(void(^)(UIButton *))bblock{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        if (tintColor) {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [button.imageView setTintColor:tintColor];
        }else{
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        [button setImage:image forState:UIControlStateNormal];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    [button sizeToFit];
    [button kj_addAction:block];
    if (bblock) bblock(button);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - ExtendParameterBlock 扩展参数
- (UINavigationItem * (^)(void(^)(KJNavigationItemInfo*),KJButtonBlock))kAddBarButtonItemInfo{
    return ^ UINavigationItem * (void(^xblock)(KJNavigationItemInfo*), KJButtonBlock block){
        KJNavigationItemInfo *info = [KJNavigationItemInfo new];
        if (xblock) xblock(info);
        UIBarButtonItem * barButtonItem = [self kj_barButtonItemWithTitle:info.title
                                                               TitleColor:info.color
                                                                    Image:[UIImage imageNamed:info.imageName]
                                                                TintColor:info.tintColor
                                                              ButtonBlock:block
                                                           BarButtonBlock:info.barButton];
        if (info.isLeft) {
            return self.kAddLeftBarButtonItem(barButtonItem);
        }else {
            return self.kAddRightBarButtonItem(barButtonItem);
        }
    };
}
- (UINavigationItem * (^)(UIBarButtonItem *))kAddLeftBarButtonItem{
    return ^ UINavigationItem * (UIBarButtonItem * barButtonItem){
        if (self.leftBarButtonItem == nil) {
            self.leftBarButtonItem = barButtonItem;
        }else{
            if (self.leftBarButtonItems.count == 0) {
                self.leftBarButtonItems = @[self.leftBarButtonItem,barButtonItem];
            }else{
                NSMutableArray * items = [NSMutableArray arrayWithArray:self.leftBarButtonItems];
                [items addObject:barButtonItem];
                self.leftBarButtonItems = items;
            }
        }
        return self;
    };
}
- (UINavigationItem * (^)(UIBarButtonItem *))kAddRightBarButtonItem{
    return ^ UINavigationItem * (UIBarButtonItem * barButtonItem){
        if (self.rightBarButtonItem == nil) {
            self.rightBarButtonItem = barButtonItem;
        }else{
            if (self.rightBarButtonItems.count == 0) {
                self.rightBarButtonItems = @[self.rightBarButtonItem,barButtonItem];
            }else{
                NSMutableArray * items = [NSMutableArray arrayWithArray:self.rightBarButtonItems];
                [items addObject:barButtonItem];
                self.rightBarButtonItems = items;
            }
        }
        return self;
    };
}

@end
