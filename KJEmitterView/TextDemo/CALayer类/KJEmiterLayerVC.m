//
//  KJEmiterLayerVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/8/27.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJEmiterLayerVC.h"
#import "KJEmitterLayer.h"
@interface KJEmiterLayerVC ()

@end

@implementation KJEmiterLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"重置" forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = CGPointMake(self.view.center.x, self.view.height - 100);
    button.alpha = 0;
    [self.view addSubview:button];
    
    KJEmitterLayer *layer = [KJEmitterLayer createEmitterLayerWaitTime:.1 imageBlock:^UIImage * _Nonnull(KJEmitterLayer * _Nonnull obj) {
        obj.KJIgnored(NO, YES).KJPixel(UIColor.clearColor, 0, CGPointMake(self.view.center.x, 0), 0);
        return [UIImage imageNamed:@"pikaqiu"];
    } complete:^{
        NSLog(@"end");
        button.alpha = 1;
    }];
    layer.bounds = CGRectMake(0, 0, self.view.width, self.view.width);
    layer.position = self.view.center;
    [self.view.layer addSublayer:layer];
    [button addTarget:layer action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
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
