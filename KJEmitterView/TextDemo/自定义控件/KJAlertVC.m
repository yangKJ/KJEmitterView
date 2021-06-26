//
//  KJAlertViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/2.
//  Copyright © 2018 杨科军. All rights reserved.
//

#import "KJAlertVC.h"
#import "KJAlertView.h"      // 
@interface KJAlertVC ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation KJAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (IBAction)ClickCenter:(UIButton *)sender {
    [KJAlertView createAlertViewWithType:(KJAlertViewTypeCenter) title:@"提示" content:@"是否清理缓存" dataArray:@[@"取消",@"确定"] withBlock:^(KJAlertView *obj) {
//        obj.KJCenterColor(UIColor.redColor);
    } alertBlock:^(NSInteger index) {
        NSLog(@"%ld",index);
    }];
}
- (IBAction)ClickBottom:(UIButton *)sender {
    KJAlertView *view = [KJAlertView createAlertViewWithType:(KJAlertViewTypeBottom) title:@"Name" content:@"" dataArray:@[@"拍照",@"相册选择",@"拍照",@"相册选择",@"拍照",@"相册选择",@"拍照",@"相册选择",@"拍照",@"相册选择",@"拍照",@"相册选择",@"拍照",@"相册选择",@"拍照",@"相册选择",@"取消"] withBlock:^(KJAlertView *obj) {
        obj.KJBottomTableH(300, 30);
        obj.KJBgColor(UIColor.redColor);
        obj.KJAddView(self.view);
    } alertBlock:^(NSInteger index) {
        NSLog(@"%ld",index);
    }];
    view.isOpenBottomTableScroll = YES;
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
