//
//  ImageBlendViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView


#import "ImageBlendViewController.h"

@interface ImageBlendViewController ()

@end

@implementation ImageBlendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"qq"];
    if (!CGSizeEqualToSize(self.orignalImageView.image.size, image.size)) {
        image = [image kj_BitmapChangeImageSize:self.orignalImageView.image.size];
    }
    self.slider.value = 0.5;
    _weakself;
    weakself.imageView.image = [weakself.orignalImageView.image kj_opencvBlendImage:image alpha:0.5];
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvBlendImage:image alpha:0.5];
    };
    self.kSliderMoving = ^(CGFloat value) {
        __block UIImage *img = weakself.orignalImageView.image;
        kGCD_async(^{
            CGFloat x = 1 * value;
            img = [img kj_opencvBlendImage:image alpha:x];
            kGCD_main(^{
                weakself.imageView.image = img;                
            });
        });
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
