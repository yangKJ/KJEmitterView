//
//  HoughViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/21.
//

#import "HoughViewController.h"

@interface HoughViewController ()

@end

@implementation HoughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orignalImageView.image = [UIImage imageNamed:@"Hough"];
    _weakself;
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvHoughLinesCorrectTextImageFillColor:UIColorFromHEXA(0x292a30, 1)];
    };
    weakself.imageView.image = [weakself.orignalImageView.image kj_opencvHoughLinesCorrectTextImageFillColor:UIColorFromHEXA(0x292a30, 1)];
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
