//
//  InpaintViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/22.
//

#import "InpaintViewController.h"

@interface InpaintViewController ()

@end

@implementation InpaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __block UIImage *_image = self.orignalImageView.image = [UIImage imageNamed:@"shuiying"];
    self.slider.value = 0.25;
    _weakself;
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvInpaintImage:10];
    };
    self.kSliderMoveEnd = ^(CGFloat value) {
        CGFloat x = 20 * value;
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvInpaintImage:x];
    };
    kGCD_async(^{
        UIImage *image = [_image kj_opencvInpaintImage:5];
        kGCD_main(^{
            weakself.imageView.image = image;
        });
    });
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
