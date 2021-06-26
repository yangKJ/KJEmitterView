//
//  KJImageJointVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/23.
//

#import "KJImageJointVC.h"

@interface KJImageJointVC ()
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation KJImageJointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat x,y;
    CGFloat sp = kAutoW(10);
    CGFloat w = (kScreenW-sp*2);
    CGFloat h = 105;
    CGFloat maxY = 0.;
    UIImage *image  = kGetImage(@"IMG_4931store_1024pt");
    UIImage *image2 = kGetImage(@"timg-2");
    UIImage *image3 = kGetImage(@"xxsf");
    NSArray *names = @[@"UIKit",@"vImage"];
    for (int k=0; k<names.count; k++) {
        x = sp;
        y = k*(h+sp)+sp+kSTATUSBAR_NAVIGATION_HEIGHT;
        UILabel *label = [UILabel kj_createLabel:^(id<KJLabelDelegate>  _Nonnull handle) {
            handle.kj_frame(x, y, w, 17).kj_add(self.view);
            handle.kj_background([UIColor.orangeColor colorWithAlphaComponent:0.2]);
            handle.kj_text(names[k]).kj_font([UIFont systemFontOfSize:16]).kj_textColor(UIColor.orangeColor);
        }];
        label.textAlignment = NSTextAlignmentLeft;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y+20, w, h-20)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.1];
        [self.view addSubview:imageView];
        if (k==0) {
            CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
            UIImage *img = [image kj_moreJointLevelImage:image,image2,image3,nil];
            NSData *date = UIImagePNGRepresentation(img);
            NSLog(@"UIKitTime：%f，Data：%lu", CFAbsoluteTimeGetCurrent() - start,(unsigned long)date.length);
            imageView.image = img;
        }else if (k==1) {
            CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
            UIImage *img = [image kj_moreCoreGraphicsJointLevelImage:image,image2,image3,nil];
            NSData *date = UIImagePNGRepresentation(img);
            NSLog(@"AccelerateTime：%f，Data：%lu", CFAbsoluteTimeGetCurrent() - start,(unsigned long)date.length);
            imageView.image = img;
        }
        maxY = imageView.maxY;
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(sp, maxY+5*sp, w, w+2*sp)];
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.1];
    [self.view addSubview:imageView];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(sp, maxY+sp/2, 100, sp*3);
    button.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.3];
    button.layer.borderWidth = 1;
    button.layer.borderColor = UIColor.blueColor.CGColor;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [button setTitle:@"切换拼接类型" forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    _weakself;
    [button kj_addAction:^(UIButton * _Nonnull kButton) {
        [weakself kj_changeJointImage:image];
    }];
    [weakself kj_changeJointImage:image];
}
- (void)kj_changeJointImage:(UIImage *)image{
    static NSInteger index = 3;
    index %= 5;
    _weakself;
    CGSize size = self.imageView.size;
    [image kj_asyncJointImage:^(UIImage * _Nonnull image) {
        weakself.imageView.image = image;
    } jointType:(KJJointImageType)index size:size maxwidth:size.width/7];
    index++;
}


@end
