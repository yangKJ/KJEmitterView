//
//  KJSwitchVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/4/14.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJSwitchVC.h"
#import "KJSwitchControl.h"
@interface KJSwitchVC ()<KJSwitchControlDelegate>

@end

@implementation KJSwitchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    KJSwitchControl *sw = [[KJSwitchControl alloc] initWithFrame:CGRectMake(kScreenW/2 - 50, 200, 100, 50)];
    [self.view addSubview:sw];
    sw.delegate = self;
    sw.on = YES;
    [sw setSwitchControlIsOn:YES animated:YES];
}

- (void)kAnimationStartSwitchControl:(KJSwitchControl *)kSwitch {
    NSLog(@"start");
}

- (void)kAnimationDidStopWithKSwitchControl:(KJSwitchControl *)kSwitch {
    NSLog(@"stop");
}

- (void)kValueDidChangedWithSwitchControl:(KJSwitchControl *)kSwitch on:(BOOL)on {
    //    NSLog(@"stop --- on:%ld", on);
}

@end
