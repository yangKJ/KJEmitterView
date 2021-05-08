//
//  KJImageCompressVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/23.
//

#import "KJImageCompressVC.h"
@interface KJImageCompressVC ()

@end

@implementation KJImageCompressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat x,y;
    CGFloat sp = kAutoW(10);
    CGFloat w = (kScreenW-sp*2)/2.;
    CGFloat h = (kScreenH-4*sp-kSTATUSBAR_NAVIGATION_HEIGHT-kBOTTOM_SPACE_HEIGHT)/3;
    NSArray *names = @[@"原图",@"UIKit",@"Quartz 2D",@"ImageIO",@"CoreImage",@"Accelerate"];
    UIImage *image = kGetImage(@"IMG_4931");
    CGSize size = CGSizeMake(image.size.width/7.7, image.size.height/7.7);
    for (int k=0; k<names.count; k++) {
        x = k%2*(w+sp)+sp/2; 
        y = k/2*(h+sp)+sp+kSTATUSBAR_NAVIGATION_HEIGHT;
        [UILabel kj_createLabel:^(id<KJLabelDelegate>  _Nonnull handle) {
            handle.kj_frame(x, y, w, 20).kj_add(self.view);
            handle.kj_text(names[k]).kj_font([UIFont systemFontOfSize:16]).kj_textColor(UIColor.orangeColor);
        }];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y+25, w, h-25)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.1];
        [self.view addSubview:imageView];
        if (k==0) {
            imageView.image = image;
            NSData *date = UIImagePNGRepresentation(image);
            NSLog(@"OriginalData：%lu", (unsigned long)date.length);
        }else if (k==1) {
            CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
            UIImage *img = [image kj_UIKitChangeImageSize:size];
            NSData *date = UIImagePNGRepresentation(img);
            NSLog(@"UIKitTime：%f，Data：%lu", CFAbsoluteTimeGetCurrent() - start,(unsigned long)date.length);
            imageView.image = img;
        }else if (k==2) {
            CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
            UIImage *img = [image kj_QuartzChangeImageSize:size];
            NSData *date = UIImagePNGRepresentation(img);
            NSLog(@"QuartzTime：%f，Data：%lu", CFAbsoluteTimeGetCurrent() - start,(unsigned long)date.length);
            imageView.image = img;
        }else if (k==3) {
            CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
            UIImage *img = [image kj_ImageIOChangeImageSize:size];
            NSData *date = UIImagePNGRepresentation(img);
            NSLog(@"ImageIOTime：%f，Data：%lu", CFAbsoluteTimeGetCurrent() - start,(unsigned long)date.length);
            imageView.image = img;
        }else if (k==4) {
            CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
            UIImage *img = [image kj_coreImageChangeImageSize:size];
            NSData *date = UIImagePNGRepresentation(img);
            NSLog(@"CoreImageTime：%f，Data：%lu", CFAbsoluteTimeGetCurrent() - start,(unsigned long)date.length);
            imageView.image = img;
        }else if (k==5) {
            CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
            UIImage *img = [image kj_BitmapChangeImageSize:size];
            NSData *date = UIImagePNGRepresentation(img);
            NSLog(@"AccelerateTime：%f，Data：%lu", CFAbsoluteTimeGetCurrent() - start,(unsigned long)date.length);
            imageView.image = img;
        }
    }
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
