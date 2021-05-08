//
//  KJImageBlurVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/14.
//

#import "KJImageBlurVC.h"
@interface KJImageBlurVC ()

@end

@implementation KJImageBlurVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    imageView.image = kGetImage(@"IMG_4931store_1024pt");
    [imageView kj_blurImageViewWithBlurType:(KJImageBlurTypeBlurEffect) BlurImage:kGetImage(@"xxsf") BlurRadius:15.];
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
