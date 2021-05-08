//
//  KJRuntimeTestVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/2/5.
//

#import "KJRuntimeTestVC.h"

@interface KJRuntimeModel : NSObject
@property(nonatomic,strong)NSString *string;
@end
@implementation KJRuntimeModel
- (void)setString:(NSString *)string{
    _string = string;
    NSLog(@"xxxxx,%@",string);
}
@end

@interface KJRuntimeInheritModel : NSObject
@property(nonatomic,strong)NSString *string;
@end
@implementation KJRuntimeInheritModel
- (void)setString:(NSString *)string{
    _string = string;
    NSLog(@"KJRuntimeInheritModel:%@",string);
}
@end
@interface KJRuntimeTestVC ()
@property(nonatomic,strong)UITextView *textView;
@end
@implementation KJRuntimeTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 86, self.view.frame.size.width-40, self.view.frame.size.height-120)];
    self.textView.layer.borderColor = UIColor.greenColor.CGColor;
    self.textView.layer.borderWidth = 2.;
    self.textView.editable = NO;
    self.textView.selectable = NO;
    self.textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.textView];
    self.textView.text = @"Runtime测试:\n\n";
    
    NSDictionary *dict = @{
        @"class":@"KJRuntimeModel",
        @"parameter":@{
                @"string":@"test",
                @"name":@"xxx"
        }
    };
    // 模拟服务器返回
    id obj = [NSClassFromString(dict[@"class"]) new];
    NSDictionary *parameter = dict[@"parameter"];
    // 获取对象类名
    self.textView.text = [self.textView.text stringByAppendingFormat:@"当前类名:%@\n对象地址%@\n\n",[obj kj_runtimeClassName],obj];
    
    // 模拟赋值
    [obj kj_runtimeHaveProperty:^(NSString * _Nonnull property, BOOL * _Nonnull stop) {
        for (NSString *key in [parameter allKeys]) {
            if ([property isEqualToString:key]) {
                [obj setValue:parameter[key] forKey:property];
                *stop = YES;
            }
        }
    }];
    
    // 模拟动态继承
    [obj kj_dynamicInheritChildClass:NSClassFromString(@"KJRuntimeInheritModel")];
    [obj kj_runtimeHaveProperty:^(NSString * _Nonnull property, BOOL * _Nonnull stop) {
        for (NSString *key in [parameter allKeys]) {
            if ([property isEqualToString:key]) {
                [obj setValue:parameter[key] forKey:property];
                *stop = YES;
            }
        }
    }];
    self.textView.text = [self.textView.text stringByAppendingFormat:@"修改isa指针后类名:%@\n对象地址%@\n\n",[obj kj_runtimeClassName],obj];
    
    KJRuntimeModel *mo = [KJRuntimeModel new];
    self.textView.text = [self.textView.text stringByAppendingFormat:@"新对象类名:%@\n\n",[mo kj_runtimeClassName]];
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
