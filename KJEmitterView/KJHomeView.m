//
//  KJHomeView.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/16.
//

#import "KJHomeView.h"

@interface KJHomeView () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)NSArray *sectionTemps;
@property(nonatomic,strong)NSArray *temps;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation KJHomeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds];
        self.tableView = tableView;
        tableView.rowHeight = 50;
        tableView.sectionHeaderHeight = 40;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
    }
    return self;
}

- (void)setTemps:(NSArray *)temps sectionTemps:(NSArray *)sectionTemps{
    self.temps = temps;
    self.sectionTemps = sectionTemps;
//    _weakself;
//    CTableViewDataSource * datasource = [[CTableViewDataSource alloc] initWithConfigureBlock:^(UITableViewCell * cell, NSIndexPath * indexPath) {
//        NSDictionary *dic = weakself.temps[indexPath.section][indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1, dic[@"VCName"]];
//        cell.textLabel.font = [UIFont systemFontOfSize:16];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.detailTextLabel.text = dic[@"describeName"];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
//    }];
//    self.tableView.dataSource = datasource;
//    self.tableView.delegate = datasource;
//    datasource.tableViewNumberSections = ^NSInteger(void) {
//        return weakself.sectionTemps.count;
//    };
//    datasource.numberOfRowsInSection = ^NSInteger(NSInteger section) {
//        return [weakself.temps[section] count];
//    };
//    datasource.titleForHeaderInSection = ^NSString * _Nonnull(NSInteger section) {
//        return weakself.sectionTemps[section];
//    };
//    datasource.tableViewCellAtIndexPath = ^__kindof UITableViewCell * _Nonnull(NSString * identifier, NSIndexPath * indexPath) {
//        return [weakself.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    };
//    datasource.didSelectRowAtIndexPath = ^(NSIndexPath * _Nonnull indexPath) {
//        NSDictionary *dic = weakself.temps[indexPath.section][indexPath.row];
//        UIViewController *vc = [NSClassFromString(dic[@"VCName"]) new];
//        [weakself kj_sendSemaphoreWithKey:kHomeViewKey Message:vc Parameter:dic];
//    };
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTemps.count;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.temps[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,dic[@"VCName"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = dic[@"describeName"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTemps[section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    UIViewController *vc = [NSClassFromString(dic[@"VCName"]) new];
    [self kj_sendSemaphoreWithKey:kHomeViewKey Message:vc Parameter:dic];
}

@end
