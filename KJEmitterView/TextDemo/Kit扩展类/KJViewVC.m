//
//  KJViewVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/1.
//  Copyright © 2018 杨科军. All rights reserved.
//

#import "KJViewVC.h"

@interface KJViewVC ()
@property(nonatomic,strong)UIView *testView;
@property(nonatomic,strong)NSArray *NameArray;
@property(nonatomic,strong)NSMutableArray *RectCornerArr;

@end

@implementation KJViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _RectCornerArr = [NSMutableArray array];
    [self.view addSubview:self.testView];

    [self.testView kj_AddTapGestureRecognizerBlock:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        NSLog(@"单击");
    }];
    [self.testView kj_AddGestureRecognizer:(KJGestureTypeDouble) block:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        NSLog(@"双击");
    }];
    [self.testView kj_AddGestureRecognizer:(KJGestureTypeLongPress) block:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        NSLog(@"长按");
    }];
    [self.testView kj_AddGestureRecognizer:(KJGestureTypePinch) block:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        NSLog(@"缩放");
    }];
    [self createSwitch];
}

- (void)clickInsSwitch:(UISwitch *)sender{
    switch (sender.tag - 100) {
            case 0:
                if (sender.on) {
                    [_RectCornerArr addObject:@(UIRectCornerTopLeft)];
                }else{
                    [_RectCornerArr removeObject:@(UIRectCornerTopLeft)];
                }
            break;
            case 1:
                if (sender.on) {
                    [_RectCornerArr addObject:@(UIRectCornerBottomLeft)];
                }else{
                    [_RectCornerArr removeObject:@(UIRectCornerBottomLeft)];
                }
            break;
            case 2:
                if (sender.on) {
                    [_RectCornerArr addObject:@(UIRectCornerTopRight)];
                }else{
                    [_RectCornerArr removeObject:@(UIRectCornerTopRight)];
                }
            break;
            case 3:
                if (sender.on) {
                    [_RectCornerArr addObject:@(UIRectCornerBottomRight)];
                }else{
                    [_RectCornerArr removeObject:@(UIRectCornerBottomRight)];
                }
            break;
            case 4:
                if (sender.on) {
                    [_RectCornerArr addObject:@(UIRectCornerAllCorners)];
                }else{
                    [_RectCornerArr removeObject:@(UIRectCornerAllCorners)];
                }
            break;
        default:
            break;
    }
    switch (_RectCornerArr.count) {
            case 0:{
                self.testView.kj_rectCorner = 0;
            }
            break;
            case 1:{
                self.testView.kj_rectCorner = [_RectCornerArr[0] integerValue];
            }
            break;
            case 2:{
                self.testView.kj_rectCorner = [_RectCornerArr[0] integerValue] | [_RectCornerArr[1] integerValue];
            }
            break;
            case 3:{
                self.testView.kj_rectCorner = [_RectCornerArr[0] integerValue] | [_RectCornerArr[1] integerValue] |
                [_RectCornerArr[2] integerValue];
            }
            break;
            case 4:{
                self.testView.kj_rectCorner = [_RectCornerArr[0] integerValue] | [_RectCornerArr[1] integerValue] |
                [_RectCornerArr[2] integerValue] | [_RectCornerArr[3] integerValue];
            }
            break;
        default:
            break;
    }
}
- (void)slidingSlider:(UISlider *)sender{
    self.testView.kj_radius = sender.value;
    ((UILabel*)[self.view viewWithTag:5324 + sender.tag - 100]).text = [NSString stringWithFormat: @"%@:\t%.2f",self.NameArray[sender.tag - 100], sender.value];
}

- (void)createSwitch{
    for (int i = 0; i < 6; i++) {
        CGFloat Y = i * 40 + self.testView.frame.origin.y + CGRectGetHeight(self.testView.frame) + 10;
        CGFloat width = 150;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, Y, width, 30)];
        label.text = self.NameArray[i];
        label.textColor = UIColor.blueColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        if (i < 5) {
            UISwitch *InsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width + 10, Y, 50, 30)];
            InsSwitch.on = NO;
            [InsSwitch addTarget:self action:@selector(clickInsSwitch:)
                forControlEvents:UIControlEventValueChanged];
            InsSwitch.tag = i + 100;
            [self.view addSubview:InsSwitch];
        }else{
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(width + 30,Y, kScreenW - (width + 40), 30)];
            [slider addTarget:self action:@selector(slidingSlider:)
             forControlEvents:UIControlEventValueChanged];
            slider.minimumValue = 0;
            slider.maximumValue = 200;
            slider.value = self.testView.kj_radius;
            slider.tag = i + 100;
            [self.view addSubview:slider];
            label.text = [NSString stringWithFormat:@"%@:\t%.02f",self.NameArray[i],self.testView.kj_radius];
            label.tag = 5324 + i;
        }
    }
}

- (UIView *)testView{
    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _testView.center = CGPointMake(kScreenW/2, 200);
        _testView.backgroundColor = UIColor.orangeColor;
        _testView.kj_radius = 50;
        _testView.viewImage = kGetImage(@"IMG_4931");
        
        _testView.kj_borderColor = UIColor.redColor;
        _testView.kj_borderWidth = 2.5;
        _testView.kj_borderOrientation = KJBorderOrientationTypeLeft | KJBorderOrientationTypeTop;
    }
    return _testView;
}
- (NSArray *)NameArray{
    if (!_NameArray) {
        _NameArray = @[@"上左角",@"下左角",@"上右角",@"下右角",@"全角",@"圆角半径"];
    }
    return _NameArray;
}

@end
