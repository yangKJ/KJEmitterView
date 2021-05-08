//
//  KJImageViewVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/17.
//

#import "KJImageViewVC.h"
@interface KJImageViewVC ()

@end

@implementation KJImageViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat x,y;
    CGFloat sp = kAutoW(10);
    CGFloat w = (kScreenW-sp*5)/4.;
    CGFloat h = w+w/2;
    NSArray *name = @[@"回头",@"看看",@"Z Jian",@"I Love You",@"你好",@"喜 欢",@"痛苦的信 仰",@"吗？",@"End",@"hao ba"];
    for (int k=0; k<name.count; k++) {
        x = k%4*(w+sp)+sp;
        y = k/4*(h+sp*2)+sp+kSTATUSBAR_NAVIGATION_HEIGHT+sp*2;
        UILabel *label = [UILabel kj_createLabel:^(id<KJLabelDelegate>  _Nonnull handle) {
            handle.kj_frame(x, y, w, w/3).kj_add(self.view);
            handle.kj_background([UIColor.orangeColor colorWithAlphaComponent:0.2]);
            handle.kj_text(name[k]).kj_font([UIFont systemFontOfSize:14]).kj_textColor(UIColor.orangeColor);
        }];
        label.borderWidth = 1;
        label.borderColor = UIColor.orangeColor;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(x, y+w/3+10, w, w);
        [self.view addSubview:imageView];
        [imageView kj_imageViewWithText:name[k] LettersInfo:^(UIImageViewLettersInfo * _Nonnull info) {
            if (k==0) {
                info.circle = NO;
                info.color = UIColor.orangeColor;
            }else if (k==1) {
                info.pinyin = YES;
                info.uppercase = NO;
            }else if (k==2) {
                
            }else if (k==3) {
                info.partition = @" ";
                info.isPartition = YES;
            }else if (k==4) {
                info.pinyin = YES;
            }else if (k==5) {
                info.frist = NO;
                info.isPartition = YES;
            }else if (k==6) {
                info.frist = NO;
                info.isPartition = YES;
            }else if (k==9) {
                info.frist = NO;
                info.uppercase = NO;
                info.isPartition = YES;
            }
        }];
        [imageView kj_AddTapGestureRecognizerBlock:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
            [imageView kj_headerImageShowScreen];
        }];
    }
}

@end
