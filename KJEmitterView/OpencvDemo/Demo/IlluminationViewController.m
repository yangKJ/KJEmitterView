//
//  IlluminationViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView


#import "IlluminationViewController.h"

@interface IlluminationViewController ()

@end

@implementation IlluminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orignalImageView.image = [UIImage imageNamed:@"orange"];
    self.slider.value = 0.37;
    self.slider2.value = 0.9;
    _weakself;
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvIlluminationChangeBeta:0.74 alpha:1.8];
    };
    self.kSliderMoveEnd = ^(CGFloat value) {
        CGFloat x = 2 * value;
        CGFloat y = 2 * weakself.slider2.value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvIlluminationChangeBeta:x alpha:y];
    };
    self.kSlider2MoveEnd = ^(CGFloat value) {
        CGFloat x = 2 * weakself.slider.value;
        CGFloat y = 2 * value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvIlluminationChangeBeta:x alpha:y];
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
