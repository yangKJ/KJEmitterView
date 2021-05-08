//
//  WarpPerspectiveViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView


#import "WarpPerspectiveViewController.h"

@interface WarpPerspectiveViewController ()

@end

@implementation WarpPerspectiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _weakself;
    CGFloat w = weakself.orignalImageView.width;
    CGFloat h = weakself.orignalImageView.height;
    self.slider2.value = 0.5;
    weakself.imageView.image = [weakself.orignalImageView.image kj_opencvWarpPerspectiveWithKnownPoints:KJKnownPointsMake(kPoint(0, 0), kPoint(w-50, 30), kPoint(w, h-20), kPoint(20, h)) size:CGSizeMake(w, h)];
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvWarpPerspectiveWithKnownPoints:KJKnownPointsMake(kPoint(0, 0), kPoint(w-50, 30), kPoint(w, h-20), kPoint(20, h)) size:CGSizeMake(w, h)];
    };
    self.kSliderMoving = ^(CGFloat value) {
        CGFloat x = 100 * value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvWarpPerspectiveWithKnownPoints:KJKnownPointsMake(kPoint(x, x), kPoint(w-50, 30+x/2), kPoint(w, h-20), kPoint(20, h)) size:CGSizeMake(w, h)];
    };
    self.kSlider2Moving = ^(CGFloat value) {
        CGFloat x = 100 * value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvWarpPerspectiveWithKnownPoints:KJKnownPointsMake(kPoint(x, x), kPoint(w-x, x), kPoint(w, h), kPoint(0, h)) size:CGSizeMake(w, h)];
    };
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
