//
//  KJAlertView.m
//  MoLiao
//
//  Created by 杨科军 on 2018/7/25.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "KJAlertView.h"

#define ALERT_UIColorFromHEXA(hex,a)    [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0f green:((hex&0xFF00)>>8)/255.0f blue:(hex&0xFF)/255.0f alpha:a]
#define ALERT_SystemFontSize(fontsize)  [UIFont systemFontOfSize:(fontsize)]

// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define ALERT_IPHONEX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
// 屏幕总尺寸
#define ALERT_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define ALERT_HEIGHT       [[UIScreen mainScreen] bounds].size.height
//// 没有tabar 距 底边高度
#define ALERT_BOTTOM_SPACE_HEIGHT (ALERT_IPHONEX?34.0f:0.0f)

@interface KJAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy) KJAlertBlock myBlock;
@property(nonatomic,assign) KJAlertViewType type;

@property(nonatomic,assign) CGFloat bottomHeader;

@property(nonatomic,strong) NSString   *title;// 提示标题
@property(nonatomic,strong) NSString   *contentStr;// 提示内容
@property(nonatomic,strong) NSArray    *titleArray;// 按钮标题数组
@property(nonatomic,strong) UIView *addView;
@property(nonatomic,strong) UIButton     *bgView;
@property(nonatomic,strong) UIView       *centerView;
@property(nonatomic,strong) UITableView  *bottomTableView;

//*****************  颜色相关  *******************
@property(nonatomic,strong) UIColor *lineColor;  // 线颜色
@property(nonatomic,strong) UIColor *cancleColor;  // 取消颜色
@property(nonatomic,strong) UIColor *titleColor;   // 标题颜色
@property(nonatomic,strong) UIColor *textColor;    // 文字颜色
// center
@property(nonatomic,strong) UIColor *centerViewColor;  // 视图颜色

// bottom
@property(nonatomic,strong) UIColor *bottomViewColor;  // 视图颜色
@property(nonatomic,strong) UIColor *spaceColor;   // 间隙颜色

/// bottomTableCellH 默认44
@property (nonatomic,assign) CGFloat bottomTableCellH;
/// bottomTableMaxH 默认12个Cell高度
@property (nonatomic,assign) CGFloat bottomTableMaxH;

@end

@implementation KJAlertView

- (void)setIsOpenBottomTableScroll:(BOOL)isOpenBottomTableScroll{
    self.bottomTableView.scrollEnabled = isOpenBottomTableScroll;
}

- (void)_config{
    self.bottomHeader = 0.1;
    self.lineColor    = ALERT_UIColorFromHEXA(0xeeeeee,0.5);
    self.spaceColor   = ALERT_UIColorFromHEXA(0xeeeeee,1.0);
    self.textColor    = ALERT_UIColorFromHEXA(0x9d87ef,1.0);
    self.titleColor   = ALERT_UIColorFromHEXA(0x9d87ef,1.0);
    self.cancleColor  = UIColor.redColor;
    self.centerViewColor = UIColor.whiteColor;
    self.bottomViewColor = UIColor.whiteColor;
    self.backgroundColor = ALERT_UIColorFromHEXA(0x333333, 0.3);
    self.bottomTableCellH = 44;
    self.bottomTableMaxH = 12 * self.bottomTableCellH;
    self.addView = [UIApplication sharedApplication].windows[0];
}

/// 初始化
+ (instancetype)createAlertViewWithType:(KJAlertViewType)type Title:(NSString *)title Content:(NSString *)content DataArray:(NSArray *)array Block:(void(^)(KJAlertView *obj))objblock AlertBlock:(KJAlertBlock)block{
    KJAlertView *obj = [[KJAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    obj.title = title;
    obj.contentStr = content;
    obj.titleArray = array;
    obj.type = type;
    
    [obj _config];
    
    if (objblock) {
        objblock(obj);
    }
    
    [obj setUI];
    
    [obj kj_Show];
    obj.myBlock = block;
    
    return obj;
}

- (void)setUI{
    if (self.titleArray == nil) {
        return;
    }
    [self addSubview:self.bgView];
    
    switch (self.type) {
        case KJAlertViewTypeCenter:
            [self createAlertViewCenter];
            break;
        case KJAlertViewTypeBottom:
            [self createAlertViewBottom];
            break;
        default:
            break;
    }
}

//获取字符串大小
- (CGRect)getStringFrame:(NSString *)str withFont:(NSInteger)fontSize withMaxSize:(CGSize)size{
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ALERT_SystemFontSize(fontSize)} context:nil];
    return rect;
}

#pragma mark - AlertViewCenter
- (void)createAlertViewCenter {
    _centerView = [[UIView alloc] initWithFrame:CGRectMake((ALERT_WIDTH-(270))/2, (ALERT_HEIGHT-(120))/2, (270), (120))];
    _centerView.backgroundColor = self.centerViewColor;
    _centerView.layer.masksToBounds = YES;
    _centerView.layer.cornerRadius = (10);
    [_bgView addSubview:_centerView];
    
    CGFloat titleHeight;
    CGFloat contentLabY;
    
    CGFloat _centerViewwidth = CGRectGetWidth(_centerView.frame);
    
    if ([self.title isEqualToString:@""] || self.title == nil) {
        titleHeight = 0;
        contentLabY = (25);
    }
    else{
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((20), (15), _centerViewwidth-(20)*2, 20)];
        titleLab.text = self.title;
        titleLab.textColor = self.titleColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:(16)];
        [_centerView addSubview:titleLab];
        
        titleHeight = titleLab.frame.size.height;
        contentLabY = titleLab.frame.origin.y + titleLab.frame.size.height+(10);
    }
    
    CGRect rect = [self getStringFrame:self.contentStr withFont:15 withMaxSize:CGSizeMake(_centerViewwidth-(20)*2, MAXFLOAT)];
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake((_centerViewwidth-rect.size.width)/2, contentLabY, rect.size.width, rect.size.height)];
    contentLab.text = self.contentStr;
    contentLab.textColor = self.textColor;
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.font = ALERT_SystemFontSize(15);
    contentLab.numberOfLines = 0;
    [_centerView addSubview:contentLab];
    
    CGFloat contentLaby = contentLab.frame.origin.y;
    CGFloat contentLabheight = CGRectGetHeight(contentLab.frame);
    
    UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentLaby+contentLabheight+(25)-0.5, ALERT_WIDTH, 0.5)];
    imageLine.backgroundColor = self.lineColor;
    [_centerView addSubview:imageLine];
    
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.tag = 2000+i;
        titleBtn.backgroundColor = [UIColor clearColor];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = ALERT_SystemFontSize(15);
        
        if (self.titleArray.count == 1) {
            titleBtn.frame = CGRectMake(_centerViewwidth/self.titleArray.count*i, contentLaby+contentLabheight+(25), _centerViewwidth, (45));
            [titleBtn setTitleColor:self.textColor forState:UIControlStateNormal];
        }
        else{
            titleBtn.frame = CGRectMake(_centerViewwidth/self.titleArray.count*i, contentLaby+contentLabheight+(25), _centerViewwidth/self.titleArray.count-0.5, (45));
            if (i == 0) {
                [titleBtn setTitleColor:self.cancleColor forState:UIControlStateNormal];
            }
            else{
                [titleBtn setTitleColor:self.textColor forState:UIControlStateNormal];
                UIImageView *centerLine = [[UIImageView alloc] initWithFrame:CGRectMake(_centerViewwidth/self.titleArray.count*i-0.5, titleBtn.frame.origin.y, 0.5, titleBtn.frame.size.height)];
                centerLine.backgroundColor = self.lineColor;
                [_centerView addSubview:centerLine];
            }
            
            if (self.titleArray.count > 2) {
                [titleBtn setTitleColor:self.textColor forState:UIControlStateNormal];
            }
        }
        
        [_centerView addSubview:titleBtn];
    }
    
    _centerView.frame = CGRectMake((ALERT_WIDTH-(270))/2, (ALERT_HEIGHT-(120))/2, (270), contentLaby+contentLabheight+(25)+(45));
}


#pragma mark - AlertViewBottom
- (void)createAlertViewBottom{
    if ([self.title isEqualToString:@""] || self.title == nil) {
        self.bottomHeader = 0.1;
    }else{
        self.bottomHeader = self.bottomTableCellH;
    }
    CGFloat h = self.titleArray.count*(self.bottomTableCellH);
    if (h>=self.bottomTableMaxH) {
        h = self.bottomTableMaxH + 10 + ALERT_BOTTOM_SPACE_HEIGHT + self.bottomHeader;
    }else{
        h = h + 10 + ALERT_BOTTOM_SPACE_HEIGHT + self.bottomHeader;
    }
    _bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ALERT_HEIGHT, ALERT_WIDTH, h) style:UITableViewStyleGrouped];
    _bottomTableView.delegate = self;
    _bottomTableView.dataSource = self;
    _bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bottomTableView.scrollEnabled = NO;
    _bottomTableView.backgroundColor = self.spaceColor;
    [_bgView addSubview:_bottomTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleArray.count-1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = self.bottomViewColor;
//    }
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((ALERT_WIDTH-(150))/2, (self.bottomTableCellH-(15))/2, (150), (15))];
    titleLab.font = ALERT_SystemFontSize(15);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLab];
    
    if (indexPath.section == 0) {
        titleLab.text = self.titleArray[indexPath.row];
        titleLab.textColor = self.textColor;
    }else{
        titleLab.text = [self.titleArray lastObject];
        titleLab.textColor = self.cancleColor;
    }
    
    UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bottomTableCellH-0.5, ALERT_WIDTH, 0.5)];
    imageLine.backgroundColor = self.lineColor;
    [cell.contentView addSubview:imageLine];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bottomTableCellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.bottomHeader;
    }
    else{
        return (10);
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ALERT_WIDTH, self.bottomTableCellH)];
        titleLab.text = self.title;
        titleLab.backgroundColor = [self.bottomViewColor colorWithAlphaComponent:0.8];
        titleLab.textColor = self.titleColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = ALERT_SystemFontSize(15);
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(2, self.bottomTableCellH, ALERT_WIDTH-4, 1)];
        line.backgroundColor = [self.bottomViewColor colorWithAlphaComponent:0.9];
        [titleLab addSubview:line];
        return titleLab;
    }else{
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myBlock) {
        
        [self kj_Dissmiss];
        
        if (indexPath.section == 0) {
            self.myBlock(indexPath.row);
        }
        else{
            self.myBlock(self.titleArray.count-1);
        }
    }
}

#pragma mark - 公用方法
- (void)kj_Show{
    switch (self.type) {
        case KJAlertViewTypeCenter:{
            [self.addView addSubview:self];
            [self exChangeOut:_centerView dur:0.5];
        }
            break;
        case KJAlertViewTypeBottom:{
            [self.addView addSubview:self];
            [UIView animateWithDuration:0.25 animations:^{
                CGFloat h = self.titleArray.count*(self.bottomTableCellH);
                if (h>=self.bottomTableMaxH) {
                    h = self.bottomTableMaxH + 10 + ALERT_BOTTOM_SPACE_HEIGHT + self.bottomHeader;
                }else{
                    h = h + 10 + ALERT_BOTTOM_SPACE_HEIGHT + self.bottomHeader;
                }
                self.bottomTableView.frame = CGRectMake(0, ALERT_HEIGHT - h, ALERT_WIDTH, h);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)kj_Dissmiss{
    switch (self.type) {
        case KJAlertViewTypeCenter:{
            [self removeFromSuperview];
        }
            break;
        case KJAlertViewTypeBottom:{
            [UIView animateWithDuration:0.25 animations:^{
                CGFloat h = self.titleArray.count*(self.bottomTableCellH);
                if (h>=self.bottomTableMaxH) {
                    h = self.bottomTableMaxH + 10 + ALERT_BOTTOM_SPACE_HEIGHT;
                }else{
                    h = h + 10 + ALERT_BOTTOM_SPACE_HEIGHT;
                }
                self.bottomTableView.frame = CGRectMake(0, ALERT_HEIGHT, ALERT_WIDTH, h);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
        default:
            break;
    }
}

- (void)titleBtnClick:(UIButton *)btn{
    if (self.myBlock) {
        self.myBlock(btn.tag-2000);
    }
    [self kj_Dissmiss];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgView.frame = [UIScreen mainScreen].bounds;
        [_bgView addTarget:self action:@selector(butChack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

- (void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    //animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    [changeOutView.layer addAnimation:animation forKey:nil];
}

- (void)butChack{
    [self kj_Dissmiss];
}

#pragma mark - 链接编程设置View的一些属性
- (KJAlertView *(^)(UIView *addView))KJAddView {
    return ^(UIView *addView){
        if (addView) {
            self.addView = addView;
        }
        return self;
    };
}
- (KJAlertView *(^)(UIColor *bgColor))KJBgColor {
    return ^(UIColor *bgColor){
        if (bgColor) {
            self.backgroundColor = bgColor;
        }
        return self;
    };
}
- (KJAlertView *(^)(UIColor *lineColor,UIColor *titleColor,UIColor *textColor,UIColor *cancleColor))KJComColor {
    return ^(UIColor *lineColor,UIColor *titleColor,UIColor *textColor,UIColor *cancleColor){
        if (lineColor) {
            self.lineColor = lineColor;
        }
        if (titleColor) {
            self.titleColor = titleColor;
        }
        if (textColor) {
            self.textColor = textColor;
        }
        if (cancleColor) {
            self.cancleColor = cancleColor;
        }
        return self;
    };
}

- (KJAlertView *(^)(UIColor *centerViewColor))KJCenterColor {
    return ^(UIColor *centerViewColor){
        if (centerViewColor) {
            self.centerViewColor = centerViewColor;
        }
        return self;
    };
}

- (KJAlertView *(^)(UIColor *bottomViewColor,UIColor *spaceColor))KJBottomColor {
    return ^(UIColor *bottomViewColor,UIColor *spaceColor){
        if (bottomViewColor) {
            self.bottomViewColor = bottomViewColor;
        }
        if (spaceColor) {
            self.spaceColor = spaceColor;
        }
        return self;
    };
}
- (KJAlertView *(^)(CGFloat maxH,CGFloat cellH))KJBottomTableH {
    return ^(CGFloat maxH,CGFloat cellH){
        if (maxH) {
            self.bottomTableMaxH = maxH;
        }
        if (cellH) {
            self.bottomTableCellH = cellH;
        }
        return self;
    };
}

@end

