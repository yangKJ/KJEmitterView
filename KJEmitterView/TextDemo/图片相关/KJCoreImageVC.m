//
//  KJCoreImageVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/5/19.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJCoreImageVC.h"

@interface KJCoreImageVC ()
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UIButton *Button;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation KJCoreImageVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = self.Image.image;
    _weakself;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (500 <= obj.tag && obj.tag <= 509) {
            UIButton *button = (UIButton *)obj;
            [button kj_addAction:^(UIButton * _Nonnull kButton) {
                weakself.Image.contentMode = UIViewContentModeScaleAspectFill;
                switch (kButton.tag) {
                    case 500:/// 黑色透明
                        weakself.Image.image = [weakself.Image.image kj_coreImageBlackMaskToAlpha];
                        break;
                    case 501:/// 高光阴影
                        weakself.Image.image = [weakself.Image.image kj_coreImageHighlightShadowWithHighlightAmount:10 ShadowAmount:20];
                        break;
                    case 502:
//                        weakself.Image.image = [weakself.Image.image kj_drawingWithEdgeDetection];
                        break;
                    case 503:
//                        weakself.Image.image = [weakself.Image.image kj_drawingWithEmboss];
                        break;
                    case 504:
//                        weakself.Image.image = [weakself.Image.image kj_drawingWithSharpen];
                        break;
                    case 505:/// 透视
                        weakself.Image.contentMode = UIViewContentModeTopLeft;
                        weakself.Image.image = [weakself.Image.image kj_coreImagePerspectiveTransformWithTopLeft:CGPointMake(0, 0) TopRight:CGPointMake(100, 20) BottomRight:CGPointMake(200, 100) BottomLeft:CGPointMake(-20, 100)];
                        break;
                    case 506:/// 透视矫正
                        weakself.Image.contentMode = UIViewContentModeTopLeft;
                        weakself.Image.image = [weakself.Image.image kj_coreImagePerspectiveCorrectionWithTopLeft:CGPointMake(0, 0) TopRight:CGPointMake(100, 20) BottomRight:CGPointMake(200, 100) BottomLeft:CGPointMake(-20, 100)];
                        break;
                    case 507:/// 圆形变形
                        weakself.Image.contentMode = UIViewContentModeScaleAspectFit;
                        weakself.Image.image = [weakself.Image.image kj_coreImageCircularWrapWithCenter:CGPointMake(weakself.Image.image.size.width/2, weakself.Image.image.size.height/2) Radius:150 Angle:0];
                        break;
                    case 508:/// 环形透镜畸变
                        weakself.Image.image = [weakself.Image.image kj_coreImageTorusLensDistortionCenter:CGPointMake(weakself.Image.image.size.width/2, weakself.Image.image.size.height/2) Radius:weakself.Image.image.size.height/2 Width:weakself.Image.image.size.height Refraction:0.9];
                        break;
                    case 509:
                        weakself.Image.image = [weakself.Image.image kj_coreImageHoleDistortionCenter:CGPointMake(weakself.Image.image.size.width/2,weakself.Image.image.size.height/2) Radius:50];
                        break;
                    default:
                        break;
                }
            }];
        }
    }];
    [self.Button kj_addAction:^(UIButton * _Nonnull kButton) {
        weakself.Image.contentMode = UIViewContentModeScaleAspectFill;
        weakself.Image.image = image;
    }];
}
- (IBAction)sliderChage:(UISlider *)sender {
    
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
