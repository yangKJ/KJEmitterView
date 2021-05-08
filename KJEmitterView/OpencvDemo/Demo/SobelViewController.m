//
//  SobelViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/21.
//  https://github.com/yangKJ/KJEmitterView

#import "SobelViewController.h"

@interface SobelViewController ()

@end

@implementation SobelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orignalImageView.image = [UIImage imageNamed:@"timg-2"];
    _weakself;
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvFeatureExtractionFromSobel];
    };
    weakself.imageView.image = [weakself.orignalImageView.image kj_opencvFeatureExtractionFromSobel];
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
