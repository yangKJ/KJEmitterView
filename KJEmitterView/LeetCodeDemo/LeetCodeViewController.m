//
//  LeetCodeViewController.m
//  KJEmitterView
//
//  Created by yangkejun on 2021/3/15.
//  Copyright © 2021 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "LeetCodeViewController.h"
#import "KJLeetCode.h"
@interface LeetCodeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *temps;
@property(nonatomic,strong) NSArray *setemps;
@end

@implementation LeetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.tabBarItem.selectedImage = [self.navigationController.tabBarItem.selectedImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.tabBarItem setTitleTextAttributes:dictHome forState:(UIControlStateSelected)];
    
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
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSTATUSBAR_NAVIGATION_HEIGHT, width, height-kBOTTOM_SPACE_HEIGHT-kSTATUSBAR_NAVIGATION_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.sectionHeaderHeight = 40;
    [self.view addSubview:self.tableView];
    
    self.setemps = @[@"数组算法",@"字符串算法",@"数字算法"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.setemps.count;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.temps[section] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.setemps[section];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:15];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1,dic[@"Name"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = dic[@"Method"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    SEL sel = NSSelectorFromString(dic[@"Method"]);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
}

#pragma mark - LeetCode Array
- (void)arrayTest1{
    int arr[] = {3,2,3,1,2,4,5,5,6};
    int k = 3;
    int x = kLeetCodeArrayFindMaxK(arr, 9, k);
    ShowAlertView([NSString stringWithFormat:@"找到第%d个最大元素%d",k,x]);
}

#pragma mark - LeetCode String
- (void)stringTest1{
    
}

#pragma mark - LeetCode Int
- (void)intTest1{
    int x = kLeetCodeIntReverse(125);
    ShowAlertView([NSString stringWithFormat:@"125反转结果%d",x]);
}
- (void)intTest2{
    int x = kLeetCodeIntrangeBitwise(5, 7);
    ShowAlertView([NSString stringWithFormat:@"计算区间内所有数字位与结果%d",x]);
}

#pragma mark - lazy
- (NSArray*)temps{
    if (!_temps) {
        NSMutableArray *temp1 = [NSMutableArray array];
        [temp1 addObject:@{@"Name":@"找出数组中第N个最大元素",@"Method":@"arrayTest1"}];
        
        NSMutableArray *temp2 = [NSMutableArray array];
        [temp2 addObject:@{@"Name":@"反转字符串",@"Method":@"stringTest1"}];
        
        NSMutableArray *temp3 = [NSMutableArray array];
        [temp3 addObject:@{@"Name":@"整数反转",@"Method":@"intTest1"}];
        [temp3 addObject:@{@"Name":@"区间内位与计算",@"Method":@"intTest2"}];
        
        _temps = @[temp1,temp2,temp3];
    }
    return _temps;
}
void ShowAlertView(NSString *message){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"展示结果" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
#pragma clang diagnostic pop
}

@end
