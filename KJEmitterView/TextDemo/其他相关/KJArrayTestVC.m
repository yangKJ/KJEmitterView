//
//  KJArrayTestVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/28.
//

#import "KJArrayTestVC.h"
#import "NSArray+KJExtension.h"

@interface KJTestModel : NSObject
@property(nonatomic,assign)int userid;
@end
@implementation KJTestModel
@end
@interface KJTestModel2 : NSObject
@property(nonatomic,strong)NSString *userid;
@end
@implementation KJTestModel2
@end
@interface KJArrayTestVC ()
@property(nonatomic,strong)UITextView *textView;
@end

@implementation KJArrayTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.navgationBackground = UIColor.orangeColor;
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 86, self.view.frame.size.width-40, self.view.frame.size.height-120)];
    self.textView.layer.borderColor = UIColor.greenColor.CGColor;
    self.textView.layer.borderWidth = 2.;
    self.textView.editable = NO;
    self.textView.selectable = NO;
    self.textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.textView];
    self.textView.text = @"数组测试:\n\n";
    
    _weakself;
    // 筛选数据
    {
        NSArray *temps = @[@"1",@"xx",@"3",@"5",@(2),@"3dasd",@"痛仰",@(123456)];
        id obj = [temps kj_detectArray:^BOOL(id  _Nonnull object, int index) {
            if ([object intValue] == 2) {
                weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"筛选数据index:%d\n",index];
                return YES;
            }
            return NO;
        }];
        weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"筛选数据内容:%@\n",obj];
        NSLog(@"筛选数据:%@",obj);
    }
    // 多维数组筛选
    {
        NSArray *temps = @[@"1",@"xx",@[@"2",@"666"],@"痛仰",@(123456)];
        id obj = [temps kj_detectManyDimensionArray:^BOOL(id  _Nonnull object, BOOL * _Nonnull stop) {
            if ([object intValue] == 666) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"多维数组筛选内容:%@\n",obj];
        NSLog(@"多维数组筛选:%@",obj);
    }
    // 查询数据
    {
        KJTestModel *model = [KJTestModel new];
        NSArray *temps = @[@"1",@"xx",@"3",@(5),model,@"3dasd"];
        int index = [temps kj_searchObject:model];
        weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"查询数据:%d\n",index];
    }
    // 插入到指定位置
    {
        KJTestModel *model = [KJTestModel new];
        model.userid = 12;
        KJTestModel *model2 = [KJTestModel new];
        model2.userid = 122;
        NSArray *temps = @[@"1",model2,@(5),model,@"3dasd"];
        temps = [temps kj_insertObject:@"520" aim:^BOOL(id  _Nonnull object, int index) {
            if ([object isKindOfClass:[KJTestModel class]]) {
                if (((KJTestModel*)object).userid == 12) {
                    NSLog(@"插入到指定位置:%d",index);
                    return YES;
                }
            }
            return NO;
        }];
        weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"插入到指定位置:%@\n",temps];
        NSLog(@"插入到指定位置:%@",temps);
    }
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
