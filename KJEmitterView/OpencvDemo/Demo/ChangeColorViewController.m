//
//  ChangeColorViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView

#import "ChangeColorViewController.h"

@interface ChangeColorViewController ()

@end

@implementation ChangeColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _weakself;
    weakself.imageView.image = [weakself.orignalImageView.image kj_opencvChangeR:-1 g:-1 b:-1];
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvChangeR:-1 g:-1 b:-1];
    };
    self.kSliderMoveEnd = ^(CGFloat value) {
        CGFloat x = 255 * value;
        CGFloat y = 255 * weakself.slider2.value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvChangeR:x g:y b:-1];
    };
    self.kSlider2MoveEnd = ^(CGFloat value) {
        CGFloat x = 255 * weakself.slider.value;
        CGFloat y = 255 * value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvChangeR:y g:-1 b:x];
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
