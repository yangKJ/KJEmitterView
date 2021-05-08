//
//  KJSliderVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/8/24.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJSliderVC.h"
#import "KJColorSlider.h"
@interface KJSliderVC ()

@end

@implementation KJSliderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    KJColorSlider *slider = [[KJColorSlider alloc]initWithFrame:CGRectMake(20, 100, kScreenW-40, 30)];
    slider.value = 0.5;
    [self.view addSubview:slider];
    slider.colors = @[UIColorFromHEXA(0xF44336,1), UIColorFromHEXA(0xFFFFFF,1)];
    slider.locations = @[@0.,@0.8];
    slider.kValueChangeBlock = ^(CGFloat progress) {
        NSLog(@"progress:%f",progress);
    };
    slider.kMoveEndBlock = ^(CGFloat progress) {
        NSLog(@"end:%f",progress);
    };
    
    KJColorSlider *slider2 = [[KJColorSlider alloc] initWithFrame:CGRectMake(20, slider.bottom+30, kScreenW-40, 30)];
    slider2.value = 0.5;
    slider2.colors = @[UIColorFromHEXA(0xFF0000,1),
                       UIColorFromHEXA(0xFF7F00,1),
                       UIColorFromHEXA(0xFFFF00,1),
                       UIColorFromHEXA(0x00FF00,1),
                       UIColorFromHEXA(0x00FFFF,1),
                       UIColorFromHEXA(0x0000FF,1),
                       UIColorFromHEXA(0x8B00FF,1)];
    slider2.locations = @[@0.,@0.16,@(0.16*2),@(0.16*3),@(0.16*4),@(0.16*5),@1.];
    [self.view addSubview:slider2];
    
    KJColorSlider *slider3 = [[KJColorSlider alloc] initWithFrame:CGRectMake(20, slider2.bottom+30, kScreenW-40, 30)];
    slider3.colorHeight = 28;
    slider3.borderColor = UIColor.redColor;
    slider3.borderWidth = 1.5;
    slider3.value = 0.5;
    [self.view addSubview:slider3];
    
    /// kvo
    [slider kj_observeKey:@"progress" ResultBlock:^(id  _Nonnull newValue, id  _Nonnull oldValue) {
        NSLog(@"%@",newValue);
    }];
    [slider2 kj_observeKey:@"progress" ResultBlock:^(id  _Nonnull newValue, id  _Nonnull oldValue) {
        NSLog(@"---%@",newValue);
    }];
}

@end
