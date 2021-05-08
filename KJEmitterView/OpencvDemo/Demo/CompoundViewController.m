//
//  CompoundViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView


#import "CompoundViewController.h"
#import "UIImage+KJOpencv.h"
@interface CompoundViewController ()

@end

@implementation CompoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = (self.view.frame.size.height-kSTATUSBAR_NAVIGATION_HEIGHT-110)/2;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20+kSTATUSBAR_NAVIGATION_HEIGHT, w-40, h)];
    imageView.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.5];
    imageView.image = [UIImage imageNamed:@"IMG_4931store_1024pt"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView kj_AddTapGestureRecognizerBlock:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        
    }];
    UIImage *image  = [UIImage imageNamed:@"dark1"];
    UIImage *image1 = [UIImage imageNamed:@"dark2"];
    UIImage *image2 = [UIImage imageNamed:@"dark3"];
    imageView.image = [image kj_opencvCompoundMoreImage:image1,image2,nil];
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
