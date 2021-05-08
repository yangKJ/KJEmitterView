//
//  KJEmptyDataVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/18.
//

#import "KJEmptyDataVC.h"
#import "UIScrollView+KJEmptyDataSet.h"
@interface KJEmptyDataVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation KJEmptyDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = [NSMutableArray array];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
//    tableView.width = 200;
//    tableView.height = 500;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    self.tableView.verticalOffset = -kSTATUSBAR_NAVIGATION_HEIGHT;
//    self.tableView.kLoadedButton = ^NSAttributedString * _Nullable(UIControlState state) {
//        return nil;
//    };
    _weakself;
    self.tableView.descriptionText = [[NSAttributedString alloc] initWithString:@"假装没网，点我刷新数据" attributes:nil];
    self.tableView.kLoadingContentView = ^UIView * _Nullable{
        UIView *backView = [[UIView alloc]init];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        view.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.8];
        view.cornerRadius = 10;
        view.centerY = 0;
        view.centerX = weakself.tableView.centerX;
        [backView addSubview:view];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityView startAnimating];
        activityView.center = CGPointMake(view.width/2, view.height/2);
        [view addSubview:activityView];
        return backView;
    };
    self.tableView.kLoadedButtonClick = ^bool(UIButton * _Nonnull button) {
        [weakself kj_xxx:YES];
        return false;
    };
    self.tableView.kLoadedOtherViewClick = ^{
        [weakself kj_xxx:YES];
    };
    [self kj_xxx:NO];
}

- (void)kj_xxx:(BOOL)data{
    _weakself;
    if (weakself.data.count > 0) {
        [weakself.data removeAllObjects];
        [weakself.tableView reloadData];
    }
    weakself.tableView.loading = YES;
    weakself.tableView.loading = YES;
    kGCD_after_main(1, ^{
        if (data) {
            for (int i = 0; i < 7; i++) {
                [weakself.data addObject:[NSString stringWithFormat:@"点我刷新，假装没网"]];
            }
        }else{
            weakself.tableView.loading = NO;
        }
        [weakself.tableView reloadData];
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.data[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self kj_xxx:NO];
}

@end
