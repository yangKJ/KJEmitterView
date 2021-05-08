//
//  KJLoadLanguageViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/3.
//  https://github.com/yangKJ/KJEmitterView

#import "KJLoadLanguageViewController.h"

@interface KJLoadLanguageViewController ()

@end

@implementation KJLoadLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleLarge)];
    }else{
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    }
    self.indicatorView.center = self.view.center;
    [self.view addSubview:self.indicatorView];
    
    [self.indicatorView startAnimating];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak __typeof(&*self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:^{
            if (weakself.loadEnd) {
                weakself.loadEnd();
            }
        }];
    });
}

@end
