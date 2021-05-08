//
//  MorphologyViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView

#import "MorphologyViewController.h"

@interface MorphologyViewController ()

@end

@implementation MorphologyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orignalImageView.image = [UIImage imageNamed:@"erzhitu"];
    _weakself;
    weakself.slider2.value = 0.42;
    weakself.imageView.image = [weakself.orignalImageView.image kj_opencvMorphology:KJOpencvMorphologyStyleOPEN element:42];
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvMorphology:KJOpencvMorphologyStyleOPEN element:42];
    };
    self.kSliderMoveEnd = ^(CGFloat value) {
        int x = 4 * value;
        int y = 100 * weakself.slider2.value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvMorphology:x element:y];
    };
    self.kSlider2MoveEnd = ^(CGFloat value) {
        int x = 4 * weakself.slider.value;
        int y = 100 * value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvMorphology:x element:y];
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
