//
//  BaseOpencvViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView

#import "BaseOpencvViewController.h"
#import "UIView+Toast.h"
@interface BaseOpencvViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation BaseOpencvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromHEXA(0xf5f5f5, 1);
    
    self.view.frame = CGRectMake(0, 0, kScreenW, kScreenH-60);
    
    _weakself;
    [self.navigationItem kj_makeNavigationItem:^(UINavigationItem * _Nonnull make) {
        make.kAddBarButtonItemInfo(^(KJNavigationItemInfo * _Nonnull info) {
            info.imageName = @"Arrow";
            info.tintColor = UIColor.whiteColor;
        }, ^(UIButton * _Nonnull kButton) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }).kAddBarButtonItemInfo(^(KJNavigationItemInfo * _Nonnull info) {
            info.imageName = @"wode_nor";
            info.isLeft = NO;
            info.tintColor = UIColor.cyanColor;
        }, ^(UIButton * _Nonnull kButton) {
            [weakself.navigationController popViewControllerAnimated:YES];
        });
        make.kAddBarButtonItemInfo(^(KJNavigationItemInfo * _Nonnull info) {
            info.isLeft = NO;
            info.barButton = ^(UIButton * _Nonnull barButton) {
                [barButton setTitle:@"分享" forState:(UIControlStateNormal)];
                barButton.titleLabel.font = kFont_Blod(16);
            };
        }, ^(UIButton * _Nonnull kButton) {
            UIImage *image = [UIImage kj_captureScreen:weakself.view Rect:CGRectMake(0, kSTATUSBAR_NAVIGATION_HEIGHT, kScreenW, kScreenH-kSTATUSBAR_NAVIGATION_HEIGHT) Quality:3];
            [weakself kj_shareActivityWithItems:@[UIImagePNGRepresentation(image)] complete:^(BOOL success) {
                [weakself.navigationController.view makeToast:success?@"分享成功":@"分享失败"];
            }];
        });
    }];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(10, kScreenH-60, kScreenW-20, 60);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"大家觉得好用还请点个星，遇见什么问题也可issues，持续更新ing.." attributes:@{NSForegroundColorAttributeName:UIColor.redColor}];
    [button setAttributedTitle:attrStr forState:(UIControlStateNormal)];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = 1;
    [button addTarget:self action:@selector(kj_button) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = (self.view.frame.size.height-kSTATUSBAR_NAVIGATION_HEIGHT-110)/2;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20+kSTATUSBAR_NAVIGATION_HEIGHT, w-40, h)];
    self.orignalImageView = imageView;
    imageView.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.5];
    imageView.image = [UIImage imageNamed:@"IMG_4931store_1024pt"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView kj_AddTapGestureRecognizerBlock:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        UIImagePickerController *pickerCtr = [[UIImagePickerController alloc] init];
        pickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerCtr.delegate = weakself;
        [weakself presentViewController:pickerCtr animated:YES completion:nil];
    }];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, imageView.bottom+70, w-40, h)];
    self.imageView = imageView2;
    imageView2.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.5];
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView2];
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.button = button2;
    button2.frame = CGRectMake(20, imageView.bottom+10, 100, 40);
    button2.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.5];
    [button2 setTitle:@"变身" forState:(UIControlStateNormal)];
    [button2 setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    button2.titleLabel.textAlignment = 1;
    [button2 addTarget:self action:@selector(kj_button2) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button2];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(button2.right + 10, 0, w-button2.right-30, 30)];
    self.slider = slider;
    slider.tag = 100;
    slider.backgroundColor = UIColor.clearColor;
    slider.centerY = button2.centerY-10;
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    
    UISlider *slider2 = [[UISlider alloc]initWithFrame:CGRectMake(button2.right + 10, slider.bottom, w-button2.right-30, 30)];
    self.slider2 = slider2;
    slider2.tag = 200;
    slider2.backgroundColor = UIColor.clearColor;
    slider2.minimumValue = 0.0;
    slider2.maximumValue = 1.0;
    [self.view addSubview:slider2];
    [slider2 addTarget:self action:@selector(sliderValueChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
}
- (void)kj_button2{
    if (self.kButtonAction) {
        self.kButtonAction();
    }
}
- (void)sliderValueChanged:(UISlider*)slider forEvent:(UIEvent*)event {
    UITouch *touchEvent = [[event allTouches]anyObject];
    switch(touchEvent.phase) {
        case UITouchPhaseBegan:
            break;
        case UITouchPhaseMoved:{
            if (slider.tag == 100) {
                if (self.kSliderMoving) {
                    self.kSliderMoving(slider.value);
                }
            }else if (slider.tag == 200) {
                if (self.kSlider2Moving) {
                    self.kSlider2Moving(slider.value);
                }
            }
        }
            break;
        case UITouchPhaseEnded:{
            CGFloat second = slider.value;
            [slider setValue:second animated:YES];
            if (slider.tag == 100) {
                if (self.kSliderMoveEnd) {
                    self.kSliderMoveEnd(slider.value);
                }
            }else if (slider.tag == 200) {
                if (self.kSlider2MoveEnd) {
                    self.kSlider2MoveEnd(slider.value);
                }
            }
        }
            break;
        default:
            break;
    }
}
- (void)kj_button{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/yangKJ/KJEmitterView"]];
#pragma clang diagnostic pop
}
- (void)dealloc{
    // 只要控制器执行此方法，代表VC以及其控件全部已安全从内存中撤出。
    // ARC除去了手动管理内存，但不代表能控制循环引用，虽然去除了内存销毁概念，但引入了新的概念--对象被持有。
    // 框架在使用后能完全从内存中销毁才是最好的优化
    // 不明白ARC和内存泄漏的请自行谷歌，此示例已加入内存检测功能，如果有内存泄漏会alent进行提示
    NSLog(@"控制器%s调用情况，已销毁%@",__func__,self);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        self.orignalImageView.image = image;
    }
}

@end
