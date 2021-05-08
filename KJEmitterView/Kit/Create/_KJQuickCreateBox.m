//
//  _KJQuickCreateBox.m
//  KJEmitterView
//
//  Created by yangkejun on 2019/4/25.
//  https://github.com/yangKJ/KJEmitterView
//  快捷链式创建UI

#import "_KJQuickCreateBox.h"

/// 公共部分
#define Quick_Create_Common \
- (id<KJCustomDelegate>(^)(UIView *))kj_add{\
    return ^(UIView * superview) {\
        [superview addSubview:self];\
        return self;\
    };\
}\
- (id<KJCustomDelegate> (^)(CGFloat, CGFloat, CGFloat, CGFloat))kj_frame{\
    return ^(CGFloat x, CGFloat y, CGFloat w, CGFloat h) {\
        self.frame = CGRectMake(x, y, w, h);\
        return self;\
    };\
}\
- (id<KJCustomDelegate>(^)(UIColor *))kj_background{\
    return ^(UIColor * color) {\
        self.backgroundColor = color;\
        return self;\
    };\
}\

@interface _KJQuickCreateBox ()
@property (nonatomic, assign) BOOL doubleArray;// 二级数据源
@property (nonatomic, assign) NSInteger sections;
@property (nonatomic, copy) NSString * identifier;
@property (nonatomic, copy, readwrite) void(^callback)(id cell, id data, NSIndexPath *indexPath);
@end
@implementation _KJQuickCreateBox
/// 初始化，目前只支持同种Cell处理
- (instancetype)initWithDatas:(NSArray * _Nullable)datas identifier:(NSString*)identifier cellCallBack:(void(^)(id cell, id data, NSIndexPath *indexPath))callback{
    if (self = [super init]) {
        self.datas = datas;
        self.doubleArray = NO;
        self.sections = 1;
        self.identifier = identifier;
        self.callback = callback;
        if (datas && datas.count > 0 && [[datas firstObject] isKindOfClass:NSArray.class]) {
            self.doubleArray = YES;
            self.sections = datas.count;
        }
    }
    return self;
}

- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    if (datas && datas.count > 0 && [[datas firstObject] isKindOfClass:NSArray.class]) {
        self.doubleArray = YES;
        self.sections = datas.count;
    }
}
/// 获取NSIndexPath位置数据
- (id)kj_dataAtIndexPath:(NSIndexPath*)indexPath{
    // 双层数组
    if (self.doubleArray) {
        if (indexPath.section >= self.sections) return nil;
        if (indexPath.row >= [(NSArray *)_datas[indexPath.section] count]) return nil;
        return [(NSArray *)_datas[indexPath.section] objectAtIndex:indexPath.row];
    }
    // 单层数组
    if (indexPath.row >= _datas.count) return nil;
    return _datas[indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.doubleArray ? [_datas[section] count] : _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
    id item = [self kj_dataAtIndexPath:indexPath];
    self.callback(cell, item, indexPath);
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.doubleArray ? [_datas[section] count] : _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
    id item = [self kj_dataAtIndexPath:indexPath];
    self.callback(cell, item, indexPath);
    return cell;
}

@end

@interface UIButton ()<KJButtonDelegate>
@end
@implementation UIButton (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createButton:(void(^)(id<KJButtonDelegate>))handle{
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.adjustsImageWhenDisabled = button.adjustsImageWhenHighlighted = NO;
    if (handle) handle(button);
    return button;
}
UIButton * kDoraemonBoxCreateButton(void(^handle)(id<KJButtonDelegate>)){
    return [UIButton kj_createButton:handle];
}
#pragma mark - KJQuickCreateHandle
Quick_Create_Common
- (id<KJImageViewDelegate>(^)(UIImage *))kj_image{
    return ^(UIImage * image) {
        [self setImage:image forState:UIControlStateNormal];
        return self;
    };
}
- (id<KJImageViewDelegate>(^)(NSString *))kj_imageName{
    return ^(NSString * name) {
        UIImage *image = [UIImage imageNamed:name];
        if (image) [self setImage:image forState:UIControlStateNormal];
        return self;
    };
}
- (id<KJLabelDelegate>(^)(NSString *))kj_text{
    return ^(NSString * text) {
        [self setTitle:text forState:(UIControlStateNormal)];
        return self;
    };
}
- (id<KJLabelDelegate>(^)(UIFont *))kj_font{
    return ^(UIFont * font) {
        self.titleLabel.font = font;
        return self;
    };
}
- (id<KJLabelDelegate>(^)(CGFloat))kj_fontSize{
    return ^(CGFloat size) {
        self.titleLabel.font = [UIFont systemFontOfSize:size];
        return self;
    };
}
- (id<KJLabelDelegate>(^)(UIColor *))kj_textColor{
    return ^(UIColor * color) {
        [self setTitleColor:color forState:(UIControlStateNormal)];
        return self;
    };
}
- (id<KJButtonDelegate>(^)(UIImage *,UIControlState))kj_stateImage{
    return ^(UIImage * image,UIControlState state) {
        [self setImage:image forState:state];
        return self;
    };
}
- (id<KJButtonDelegate>(^)(NSString*,UIColor*,UIControlState))kj_stateTitle{
    return ^(NSString*string, UIColor *color, UIControlState state) {
        [self setTitle:string forState:state];
        [self setTitleColor:color forState:state];
        return self;
    };
}

@end

/* **************************** 快捷创建文本 ****************************/
@interface UILabel ()<KJLabelDelegate>
@end
@implementation UILabel (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createLabel:(void(^)(id<KJLabelDelegate>))handle{
    UILabel *label = [[self alloc] init];
    if (handle) handle(label);
    return label;
}
UILabel * kDoraemonBoxCreateLabel(void(^handle)(id<KJLabelDelegate>)){
    return [UILabel kj_createLabel:handle];
}
#pragma mark - KJQuickCreateHandle
Quick_Create_Common
- (id<KJLabelDelegate>(^)(NSString *))kj_text{
    return ^(NSString * text) {
        self.text = text;
        return self;
    };
}
- (id<KJLabelDelegate>(^)(UIFont *))kj_font{
    return ^(UIFont * font) {
        self.font = font;
        return self;
    };
}
- (id<KJLabelDelegate>(^)(CGFloat))kj_fontSize{
    return ^(CGFloat size) {
        self.font = [UIFont systemFontOfSize:size];
        return self;
    };
}
- (id<KJLabelDelegate>(^)(UIColor *))kj_textColor{
    return ^(UIColor * color) {
        self.textColor = color;
        return self;
    };
}

@end

// UIImageView
@interface UIImageView ()<KJImageViewDelegate>
@end
@implementation UIImageView (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createImageView:(void(^)(id<KJImageViewDelegate>))handle{
    UIImageView *imageView = [[UIImageView alloc] init];
    if (handle) handle(imageView);
    return imageView;
}
UIImageView * kDoraemonBoxCreateImageView(void(^handle)(id<KJImageViewDelegate>)){
    return [UIImageView kj_createImageView:handle];
}
#pragma mark - KJQuickCreateHandle
Quick_Create_Common
- (id<KJImageViewDelegate>(^)(UIImage *))kj_image{
    return ^(UIImage * image) {
        self.image = image;
        return self;
    };
}
- (id<KJImageViewDelegate>(^)(NSString *))kj_imageName{
    return ^(NSString * name) {
        UIImage *image = [UIImage imageNamed:name];
        if (image) self.image = image;
        return self;
    };
}
@end

@interface UIView ()<KJViewDelegate>
@end
@implementation UIView (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createView:(void(^)(id<KJViewDelegate>))handle{
    UIView *view = [[UIView alloc] init];
    if (handle) handle(view);
    return view;
}
UIView * kDoraemonBoxCreateView(void(^handle)(id<KJViewDelegate>)){
    return [UIView kj_createView:handle];
}
#pragma mark - KJQuickCreateHandle
Quick_Create_Common


@end

@interface UITableView ()<KJTableViewCreateDelegate>
//@property(nonatomic,strong)_KJQuickCreateBox *listDataSource;
@end
@implementation UITableView (KJCreate)
+ (instancetype)kj_createTableView:(void(^)(id<KJTableViewCreateDelegate>tableView))handle{
    UITableView *tableView = [[UITableView alloc]init];
    if (handle) handle(tableView);
    [tableView setConfig];
    return tableView;
}
UITableView * kDoraemonBoxCreateTableView(void(^handle)(id<KJTableViewCreateDelegate>)){
    return [UITableView kj_createTableView:handle];
}
- (void)setConfig{
    if (self.callback) {
        _KJQuickCreateBox *listDataSource = [[_KJQuickCreateBox alloc]initWithDatas:self.datas identifier:self.identifier cellCallBack:self.callback];
        self.dataSource = listDataSource;
    }
}
- (NSString*)identifier{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setIdentifier:(NSString*)identifier{
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSArray*)datas{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setDatas:(NSArray*)datas{
    objc_setAssociatedObject(self, @selector(datas), datas, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void(^)(id,id,NSIndexPath*))callback{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setCallback:(void(^)(id,id,NSIndexPath*))callback{
    objc_setAssociatedObject(self, @selector(callback), callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark - KJQuickCreateHandle
Quick_Create_Common
- (id<KJTableViewCreateDelegate>(^)(void(^)(UITableViewCell *, id, NSIndexPath *), NSArray *, NSString *))kj_dataSource{
    return ^(void(^callback)(UITableViewCell * cell, id data, NSIndexPath *indexPath), NSArray *datas, NSString *identifier){
        self.datas = datas;
        self.identifier = identifier ?: @"UITableViewCell";
        self.callback = callback;
        return self;
    };
}

@end
