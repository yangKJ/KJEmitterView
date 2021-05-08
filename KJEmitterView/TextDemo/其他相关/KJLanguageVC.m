//
//  KJLanguageVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/3.
//

#import "KJLanguageVC.h"
#import "NSBundle+KJLanguage.h"
@interface KJLanguageVC ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation KJLanguageVC
- (instancetype)init{
    if (self=[super init]) {
        [NSBundle kj_openDynamicInherit];
        NSBundle.customStringsName = @"LocalizableTest";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.navgationImage = [UIImage imageNamed:@"timg-2"];
    
    _weakself;
    [self.button kj_addAction:^(UIButton * _Nonnull kButton) {
        kButton.selected = !kButton.selected;
    }];
    
    UIButton *changebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenH - 60 - 60, kScreenW-150, 40)];
    [self.view addSubview:changebutton];
    changebutton.centerX = kScreenW/2;
    changebutton.backgroundColor = UIColor.whiteColor;
    changebutton.layer.borderWidth = 1;
    changebutton.layer.borderColor = UIColor.blueColor.CGColor;
    changebutton.layer.masksToBounds = YES;
    changebutton.layer.cornerRadius = 5;
    changebutton.titleLabel.font = [UIFont systemFontOfSize:14];
    changebutton.LocalizedKey = @"切换语言";
    [changebutton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [changebutton kj_addAction:^(UIButton * _Nonnull kButton) {
        NSString *language = NSBundle.currentLanguage;
        if ([language isEqualToString:@"en"]) {
            language = @"zh-Hans";
        }else{
            language = @"en";
        }
        [NSBundle kj_setCurrentLanguage:language complete:nil];
        [NSBundle kj_switchoverLanguage:^UIViewController * _Nonnull(KJLoadLanguageViewController * _Nonnull loadvc) {
            loadvc.view.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.3];
            return weakself;
        } complete:^{
            changebutton.LocalizedKey = @"切换语言";
        }];
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
