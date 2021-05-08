//
//  TiledViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView


#import "TiledViewController.h"

@interface TiledViewController ()

@end

@implementation TiledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.slider.value = 0.5;
    self.slider2.value = 0.5;
    _weakself;
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvTiledRows:5 cols:5];
    };
    self.kSliderMoveEnd = ^(CGFloat value) {
        CGFloat x = 10 * value;
        CGFloat y = 10 * weakself.slider2.value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvTiledRows:x cols:y];
    };
    self.kSlider2MoveEnd = ^(CGFloat value) {
        CGFloat x = 10 * weakself.slider.value;
        CGFloat y = 10 * value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvTiledRows:x cols:y];
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
