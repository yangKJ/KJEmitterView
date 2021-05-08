//
//  KJCodeImageVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/18.
//

#import "KJCodeImageVC.h"
@interface KJCodeImageVC ()

@end

@implementation KJCodeImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat w = (kScreenW-60)/2;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, kSTATUSBAR_NAVIGATION_HEIGHT+20, w, w)];
    [self.view addSubview:view];
//    view.viewImage = [UIImage kj_QRCodeImageWithContent:@"I Like You" codeImageSize:100];
    kQRCodeImage(^(UIImage * _Nonnull image) {
        view.viewImage = image;
    }, @"I Like You", 100);
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(view.maxX+20, kSTATUSBAR_NAVIGATION_HEIGHT+20, w, w)];
    [self.view addSubview:view2];
    kQRCodeImageFromColor(^(UIImage * _Nonnull image) {
        view2.viewImage = image;
    }, @"我喜欢你", 100, UIColor.orangeColor);
//    view2.viewImage = [UIImage kj_QRCodeImageWithContent:@"I Like You" codeImageSize:100 color:UIColor.orangeColor];
//
//    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(20, view.bottom+20, kScreenW-40, 50)];
//    [self.view addSubview:view3];
//    view3.viewImage = [UIImage kj_barcodeImageWithContent:@"I Like You" codeImageSize:100];
//
//    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(20, view3.bottom+20, kScreenW-40, 50)];
//    [self.view addSubview:view4];
//    view4.viewImage = [UIImage kj_barcodeImageWithContent:@"I Like You" codeImageSize:100 color:UIColor.redColor];
//
//    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(20, view4.bottom+20, kScreenW-40, 50)];
//    [self.view addSubview:view5];
//    view5.viewImage = [UIImage kj_barCodeImageWithContent:@"Like"];
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
