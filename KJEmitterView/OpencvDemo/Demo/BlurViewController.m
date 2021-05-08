//
//  BlurViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView

#import "BlurViewController.h"

@interface BlurViewController ()

@end

@implementation BlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orignalImageView.image = [UIImage imageNamed:@"xxsf"];
    _weakself;
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvBilateralFilterBlurRadio:15 sigma:100];
    };
    self.kSliderMoveEnd = ^(CGFloat value) {
        CGFloat x = 50 * value;
        CGFloat y = 150 * weakself.slider2.value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvBilateralFilterBlurRadio:x sigma:y];
    };
    self.kSlider2MoveEnd = ^(CGFloat value) {
        CGFloat x = 50 * weakself.slider.value;
        CGFloat y = 150 * value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvBilateralFilterBlurRadio:x sigma:y];
    };
    weakself.imageView.image = [weakself.orignalImageView.image kj_opencvBilateralFilterBlurRadio:15 sigma:100];
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
