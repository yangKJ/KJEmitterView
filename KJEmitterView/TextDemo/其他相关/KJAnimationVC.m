//
//  KJAnimationVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/18.
//

#import "KJAnimationVC.h"
#import "UIView+KJAnimation.h"
@interface KJAnimationVC ()

@end

@implementation KJAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar kj_hiddenNavigationBarBottomLine];
    
    CGFloat w = kScreenW/4,sp = 30;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, kSTATUSBAR_NAVIGATION_HEIGHT+sp, w, w)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.5];
    view.viewImage = kGetImage(@"IMG_4931store_1024pt");
    [view kj_animationRotateClockwise:YES makeParameter:^(KJAnimationManager * _Nonnull make) {
        make.kRepeatCount(0).kDuration(.2).kAutoreverses(NO);
    }];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(view.maxX+sp, view.top, w, w)];
    [self.view addSubview:view2];
    view2.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.8];
    [view2 kj_animationMovePoint:CGPointMake(view2.maxX+sp, view2.centerY) makeParameter:^(KJAnimationManager * _Nonnull make) {
        make.kRepeatCount(0).kDuration(.2).kAutoreverses(YES);
    }];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(20, view2.bottom+sp, w, w)];
    [self.view addSubview:view3];
    view3.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.8];
    [view3 kj_animationZoomMultiple:.8 makeParameter:^(KJAnimationManager * _Nonnull make) {
        make.kRepeatCount(0).kDuration(.2).kAutoreverses(YES);
    }];
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(view3.maxX+sp, view2.bottom+sp, w, w)];
    [self.view addSubview:view4];
    view4.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.8];
    [view4 kj_animationOpacity:.5 makeParameter:^(KJAnimationManager * _Nonnull make) {
        make.kRepeatCount(0).kDuration(.2).kAutoreverses(YES);
    }];
    
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(20, view3.bottom+sp, w, w)];
    [self.view addSubview:view5];
    view5.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.8];
    CABasicAnimation *am1 = [view5 kj_animationRotateClockwise:YES makeParameter:^(KJAnimationManager * _Nonnull make) {
        make.kDuration(2).kAutoreverses(NO).kRepeatDuration(5).kTransformRotation(2);
    }];
    CABasicAnimation *am2 = [view5 kj_animationZoomMultiple:1.5 makeParameter:^(KJAnimationManager * _Nonnull make) {
        make.kDuration(.8).kAutoreverses(YES);
    }];
    CABasicAnimation *am3 = [view5 kj_animationOpacity:.5 makeParameter:^(KJAnimationManager * _Nonnull make) {
        make.kRepeatCount(0).kDuration(.5).kAutoreverses(YES);
    }];
    CABasicAnimation *am4 = [view5 kj_animationMovePoint:CGPointMake(kScreenW-sp-view5.width/2, view5.centerY) makeParameter:^(KJAnimationManager * _Nonnull make) {
        make.kRepeatCount(0).kDuration(.3).kAutoreverses(YES);
    }];
    [view5 kj_animationMoreAnimations:@[am1,am2,am3,am4]];
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
