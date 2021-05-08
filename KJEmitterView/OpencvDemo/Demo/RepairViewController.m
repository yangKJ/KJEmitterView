//
//  RepairViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView


#import "RepairViewController.h"

@interface RepairViewController ()

@end

@implementation RepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __block UIImage *_image = self.orignalImageView.image = [UIImage imageNamed:@"old"];
    _weakself;
    kGCD_async(^{
        UIImage *image = [_image kj_opencvRepairImage];
        kGCD_main(^{
            weakself.imageView.image = image;
        });
    });
    self.kButtonAction = ^{
        weakself.imageView.image = [weakself.orignalImageView.image kj_opencvRepairImage];
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
