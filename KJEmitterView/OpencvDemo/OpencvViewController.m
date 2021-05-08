//
//  OpencvViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2021/3/20.
//  https://github.com/yangKJ/KJEmitterView

#import "OpencvViewController.h"

@interface OpencvViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *temps;
@property(nonatomic,strong) NSArray *setemps;
@end

@implementation OpencvViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}
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
    
    self.setemps = @[@"综合运营",@"Opencv测试专区"];
}
- (NSArray*)temps{
    if (!_temps) {
        NSMutableArray *temp1 = [NSMutableArray array];
        [temp1 addObject:@{@"VCName":@"HoughViewController",@"describeName":@"霍夫线检测矫正文本"}];
        [temp1 addObject:@{@"VCName":@"SobelViewController",@"describeName":@"特征提取处理"}];
        [temp1 addObject:@{@"VCName":@"RepairViewController",@"describeName":@"老照片修复"}];
        [temp1 addObject:@{@"VCName":@"InpaintViewController",@"describeName":@"修复图片去水印"}];
//        [temp1 addObject:@{@"VCName":@"CompoundViewController",@"describeName":@"类似图合成"}];
        [temp1 addObject:@{@"VCName":@"CutViewController",@"describeName":@"最大区域裁剪"}];
        
        NSMutableArray *temp2 = [NSMutableArray array];
        [temp2 addObject:@{@"VCName":@"MorphologyViewController",@"describeName":@"形态学操作"}];
        [temp2 addObject:@{@"VCName":@"BlurViewController",@"describeName":@"模糊磨皮美白处理"}];
        [temp2 addObject:@{@"VCName":@"WarpPerspectiveViewController",@"describeName":@"图片透视"}];
        [temp2 addObject:@{@"VCName":@"ImageBlendViewController",@"describeName":@"图片混合"}];
        [temp2 addObject:@{@"VCName":@"LuminanceViewController",@"describeName":@"修改亮度和对比度"}];
        [temp2 addObject:@{@"VCName":@"IlluminationViewController",@"describeName":@"图片去高光"}];
        [temp2 addObject:@{@"VCName":@"TiledViewController",@"describeName":@"图片拼接平铺"}];
//        [temp2 addObject:@{@"VCName":@"ChangeColorViewController",@"describeName":@"修改图片通道值"}];
        
        _temps = @[temp1,temp2];
    }
    return _temps;
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
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1,dic[@"VCName"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = dic[@"describeName"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    UIViewController *vc = [[NSClassFromString(dic[@"VCName"]) alloc]init];
    vc.title = dic[@"describeName"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
