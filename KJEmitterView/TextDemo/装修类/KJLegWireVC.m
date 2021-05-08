//
//  KJLegWireVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2020/5/19.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJOvalVC.h"
#import "_KJIFinishTools.h"

@interface KJOvalVC ()
@end

@implementation KJOvalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat w = self.view.size.width;
    CGFloat h = self.view.size.height;
    __block UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, h/2+20, w, h/2-20)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.5];
//    imageView.center = CGPointMake(w/2, h-100);
    [self.view addSubview:imageView];
    UIImage *img = [UIImage imageNamed:@"xxsf"];
    UIImage *imgg = [_KJIFinishTools kj_changeImageSizeWithImage:img SimpleImageWidth:300];
    imageView.image = [_KJIFinishTools kj_orthogonImageBecomeOvalWithImage:imgg Rect:CGRectMake(0, 0, 180, 100)];
}
@end
