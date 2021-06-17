//
//  ViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/11/26.
//  Copyright © 2018 杨科军. All rights reserved.
//

#import "ViewController.h"
#import "KJHomeView.h"
#import "KJHomeModel.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.tabBarItem.selectedImage = [self.navigationController.tabBarItem.selectedImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    //暗黑模式
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return UIColor.whiteColor;
            }else{
                return UIColor.blackColor;
            }
        }];
    }else{
        self.view.backgroundColor = UIColor.whiteColor;
    }
    
    self.navigationController.navigationBar.kChangeNavigationBarTitle(UIColor.whiteColor,[UIFont boldSystemFontOfSize:20]);
    self.navigationController.navigationBar.navgationImage = [UIImage imageNamed:@"timg-2"];
    
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    KJHomeModel *model = [KJHomeModel new];
    KJHomeView *view = [KJHomeView kj_createView:^(id<KJViewDelegate> _Nonnull view) {
        view.kj_add(self.view);
    } frame:CGRectMake(0, kSTATUSBAR_NAVIGATION_HEIGHT, width, height-kBOTTOM_SPACE_HEIGHT-kSTATUSBAR_NAVIGATION_HEIGHT)];
    [view setTemps:model.temps sectionTemps:model.sectionTemps];
    
    _weakself;
    [view kj_receivedSemaphoreBlock:^id _Nullable(NSString * _Nonnull key, id _Nonnull message, id _Nullable parameter) {
        if ([key isEqualToString:kHomeViewKey]) {
            ((UIViewController *)message).title = ((NSDictionary *)parameter)[@"describeName"];
            weakself.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:message animated:true];
        }
        return nil;
    }];
}

@end
