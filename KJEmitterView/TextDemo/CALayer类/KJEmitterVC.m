//
//  KJEmitterVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/1.
//  Copyright © 2018 杨科军. All rights reserved.
//

#import "KJEmitterVC.h"
#import "KJEmitterView.h"
@interface KJEmitterVC ()

@end

@implementation KJEmitterVC
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    /// 重置
//    [self.navigationController.navigationBar kj_reset];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"xuejing"];
    [self.view addSubview:imageView];
    
//    self.navigationController.navigationBar.kj_BackgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.1];
    
    [KJEmitterView createEmitterViewWithType:(KJEmitterTypeSnowflake) Block:^(KJEmitterView *obj) {
        obj.KJFrame(self.view.bounds).KJAddView(self.view).KJBackgroundColor([UIColor.whiteColor colorWithAlphaComponent:0.1]);
    }];
}

- (void)kj_qieHuan{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger i = (arc4random() % 4);
    [KJEmitterView createEmitterViewWithType:i Block:^(KJEmitterView *obj) {
        if (i==3) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
            imageView.image = [UIImage imageNamed:@"xuejing"];
            [self.view addSubview:imageView];
            obj.KJFrame(self.view.bounds).KJAddView(self.view).KJBackgroundColor([UIColor.whiteColor colorWithAlphaComponent:0.1]);
        }else{
            obj.KJFrame(self.view.bounds).KJAddView(self.view).KJBackgroundColor([UIColor.blackColor colorWithAlphaComponent:0.9]);
        }
    }];
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
