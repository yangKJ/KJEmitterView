//
//  KJFilterImageVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/8/22.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJFilterImageVC.h"

@interface KJFilterImageVC ()
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UIButton *Button;

@end

@implementation KJFilterImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = self.Image.image;
    _weakself;
    __block int iterations = 1;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (500 <= obj.tag && obj.tag <= 509) {
            UIButton *button = (UIButton*)obj;
            [button kj_addAction:^(UIButton * _Nonnull kButton) {
                switch (kButton.tag) {
                    case 500:
                        iterations++;
                        weakself.Image.image = [image kj_sharpenImageWithIterations:iterations];
                        break;
                    case 501:
                        weakself.Image.image = [weakself.Image.image kj_gaussianImage];
                        break;
                    case 502:
                        weakself.Image.image = [weakself.Image.image kj_marginImage];
                        break;
                    case 503:
                        weakself.Image.image = [weakself.Image.image kj_embossImage];
                        break;
                    case 504:
                        weakself.Image.image = [weakself.Image.image kj_sharpenImage];
                        break;
                    case 505:
//                        weakself.Image.image = [weakself.Image.image kj_drawingWithGrayImage];
                        break;
                    case 506:
                        weakself.Image.image = [weakself.Image.image kj_erodeImageWithIterations:2];
                        break;
                    case 507:
                        weakself.Image.image = [weakself.Image.image kj_gradientImageWithIterations:5];
                        break;
                    case 508:
                        weakself.Image.image = [weakself.Image.image kj_blackhatImageWithIterations:5];
                        break;
                    case 509:
                        weakself.Image.image = [weakself.Image.image kj_equalizationImage];
                        break;
                    default:
                        break;
                }
            }];
        }
    }];
    [self.Button kj_addAction:^(UIButton * _Nonnull kButton) {
        weakself.Image.image = image;
        iterations = 1;
    }];
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
