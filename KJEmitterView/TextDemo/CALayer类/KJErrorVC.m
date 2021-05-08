//
//  KJErrorVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/4/14.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJErrorVC.h"
#import "KJErrorView.h"
@interface KJErrorVC ()

@end

@implementation KJErrorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    but.center = self.view.center;
    [but setTitle:@"Button" forState:(UIControlStateNormal)];
    [but setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [but addTarget:self action:@selector(aaa) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:but];
}

- (void)aaa{
   KJErrorView *view = [KJErrorView createErrorView:^(KJErrorView * _Nonnull obj) {
        obj.KJFrame(self.view.bounds).KJAddView(self.view).KJBackgroundColor(UIColor.blackColor);
    }];
    
    view.delayTime = 2.0;
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
