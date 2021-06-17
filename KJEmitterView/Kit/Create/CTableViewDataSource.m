//
//  CTableViewDataSource.m
//  KJEmitterView
//
//  Created by yangkejun on 2019/4/25.
//  https://github.com/yangKJ/KJEmitterView
//  快捷链式创建UI

#import "CTableViewDataSource.h"

@interface CTableViewDataSource ()
@property (nonatomic, copy, readwrite) void(^xxblock)(UITableViewCell * cell, NSIndexPath * indexPath);
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) CGFloat totalHeight;

@end
@implementation CTableViewDataSource

- (instancetype)initWithConfigureBlock:(void(^)(UITableViewCell * cell, NSIndexPath * indexPath))block{
    if (self = [super init]) {
        self.identifier = @"custom_table_identifier";
        self.xxblock = block;
        self.canEdit = NO;
        self.totalHeight = 0;
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.totalHeight = 0;
    if (self.tableViewNumberSections) {
        return self.tableViewNumberSections();
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    @try {
        if (self.numberOfRowsInSection) {
            return self.numberOfRowsInSection(section);
        }
    } @catch (NSException *exception) {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.identifierAtIndexPath) {//设置标识符
        self.identifier = self.identifierAtIndexPath(indexPath);
    }
    UITableViewCell * tableViewCell = nil;
    @try {
        if (self.tableViewCellAtIndexPath) {
            tableViewCell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
            if (tableViewCell == nil) {
                tableViewCell = self.tableViewCellAtIndexPath(self.identifier, indexPath);
            }
        } else {
            tableViewCell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
        }
    } @catch (NSException *exception) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifier];
    }
    //设置内容
    self.xxblock(tableViewCell, indexPath);
    
    return tableViewCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.deleteRowAtIndexPath) {
            self.deleteRowAtIndexPath(indexPath);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.canEditRowAtIndexPath) {
        return self.canEditRowAtIndexPath(indexPath);
    }
    return self.canEdit;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.titleForHeaderInSection) {
        return self.titleForHeaderInSection(section);
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (self.titleForFooterInSection) {
        return self.titleForFooterInSection(section);
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    if (self.heightForRowAtIndexPath) {
        rowHeight = self.heightForRowAtIndexPath(indexPath);
    } else {
        rowHeight = tableView.rowHeight;
    }
    self.totalHeight += rowHeight;
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    if (self.heightForHeaderInSection) {
        return self.heightForHeaderInSection(section);
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.heightForFooterInSection) {
        return self.heightForFooterInSection(section);
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.viewForHeaderInSection) {
        return self.viewForHeaderInSection(section);
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.viewForFooterInSection) {
        return self.viewForFooterInSection(section);
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.allowsMultipleSelection == NO) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (self.didSelectRowAtIndexPath) {
        self.didSelectRowAtIndexPath(indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didDeselectRowAtIndexPath) {
        self.didDeselectRowAtIndexPath(indexPath);
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editingStyleForRowAtIndexPath) {
        return self.editingStyleForRowAtIndexPath(indexPath);
    } else if (self.canEdit && tableView.allowsMultipleSelection) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.sectionIndexTitlesForTableView) {
        return self.sectionIndexTitlesForTableView();
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"删除", nil);
}

@end


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

@interface UIView ()<KJViewDelegate>
@end
@implementation UIView (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createView:(void(^)(id<KJViewDelegate>))handle{
    id view = [[self alloc] init];
    if (handle) handle(view);
    return view;
}
+ (instancetype)kj_createView:(void(^)(id<KJViewDelegate>view))handle frame:(CGRect)frame{
    id view = [[self alloc] initWithFrame:frame];
    if (handle) handle(view);
    return view;
}
#pragma mark - KJQuickCreateHandle
Quick_Create_Common

@end


/* **************************** 快捷创建文本 ****************************/
@interface UILabel ()<KJLabelDelegate>
@end
@implementation UILabel (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createLabel:(void(^)(id<KJLabelDelegate>))handle{
    id label = [[self alloc] init];
    if (handle) handle(label);
    return label;
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
    id imageView = [[self alloc] init];
    if (handle) handle(imageView);
    return imageView;
}
+ (instancetype)kj_createImageView:(void(^)(id<KJImageViewDelegate>imageView))handle frame:(CGRect)frame{
    id imageView = [[self alloc] initWithFrame:frame];
    if (handle) handle(imageView);
    return imageView;
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
- (id<KJButtonDelegate>(^)(NSString *,UIColor *,UIControlState))kj_stateTitle{
    return ^(NSString * string, UIColor * color, UIControlState state) {
        [self setTitle:string forState:state];
        [self setTitleColor:color forState:state];
        return self;
    };
}

@end
