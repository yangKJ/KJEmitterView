//
//  CutViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView


#import "CutViewController.h"

@interface CutViewController ()

@end

@implementation CutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orignalImageView.image = [UIImage imageNamed:@"xxxx"];
    self.orignalImageView.backgroundColor = UIColor.blackColor;
    _weakself;
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvCutMaxRegionImage];
    };
    weakself.imageView.image = [weakself.orignalImageView.image kj_opencvCutMaxRegionImage];
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
