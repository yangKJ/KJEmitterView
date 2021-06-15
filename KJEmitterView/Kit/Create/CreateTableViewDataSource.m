//
//  CreateTableViewDataSource.m
//  KJEmitterView
//
//  Created by yangkejun on 2019/4/25.
//  https://github.com/yangKJ/KJEmitterView
//  快捷链式创建UI

#import "CreateTableViewDataSource.h"

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

@interface CreateTableViewDataSource ()
@property (nonatomic, strong) NSString *identifier;

@end
@implementation CreateTableViewDataSource
/// 初始化，目前只支持同种Cell处理
- (instancetype)initWithDatas:(NSArray *)datas identifier:(NSString *)identifier withBlock:(KJCreateTableBlock)block{
    if (self = [super init]) {
        self.datas = [NSMutableArray arrayWithArray:datas];
        self.identifier = identifier;
        self.cellForRowAtIndexPath = block;
        self.isAllowEdit = NO;
        _totalHeight = 0;
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    _totalHeight = 0;
    if (self.numberOfSectionsInTableView) {
        return self.numberOfSectionsInTableView(self.datas);
    } else {
        return 1;
    }
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    @try {
        if (self.numberOfRowsInSection) {
            return self.numberOfRowsInSection(section, [self kj_itemAtSection:section sectionKey:self.sectionKey]);
        } else if (self.numberOfSectionsInTableView) {
            NSArray *sectionArr = [self kj_itemAtSection:section sectionKey:self.sectionKey];
            return [sectionArr count];
        } else {
            return [self.datas count];
        }
    } @catch (NSException *exception) {
        return 0;
    }
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    id item;
    @try {
        if (self.kTableViewCell) {
            cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
            if (cell == nil) {
                cell = self.kTableViewCell(indexPath);
            }
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
        }
    } @catch (NSException *exception) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifier];
    }
    
    if (self.cellForRowAtCustom) {
        self.cellForRowAtCustom(cell, indexPath);
    } else if (self.cellForRowAtIndexPath) {
        item = [self kj_itemAtIndexPath:indexPath sectionKey:self.sectionKey rowKey:nil];
        self.cellForRowAtIndexPath(cell, indexPath, item);
    }
    return cell;
}
 
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id item = [self kj_itemAtIndexPath:indexPath sectionKey:self.sectionKey rowKey:nil];
        [self.datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.deleteRowAtIndexPath) {
            self.deleteRowAtIndexPath(indexPath, item);
        }
    }
}
 
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.canEditRowAtIndexPath) {
        id item = [self kj_itemAtIndexPath:indexPath sectionKey:self.sectionKey rowKey:nil];
        return self.canEditRowAtIndexPath(indexPath, item);
    }
    return self.isAllowEdit;
}
 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.titleForHeaderInSection) {
        return self.titleForHeaderInSection(section, [self.datas objectAtIndex:section]);
    } else {
        return nil;
    }
}
 
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (self.titleForFooterInSection) {
        return self.titleForFooterInSection(section, [self.datas objectAtIndex:section]);
    } else {
        return nil;
    }
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    if (self.heightForRowAtIndexPath) {
        id item = [self kj_itemAtIndexPath:indexPath sectionKey:self.sectionKey rowKey:nil];
        rowHeight = self.heightForRowAtIndexPath(indexPath, item);
    } else {
        rowHeight = tableView.rowHeight;
    }
    _totalHeight += rowHeight;
    return rowHeight;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    if (self.heightForHeaderInSection) {
        return self.heightForHeaderInSection(section, [self.datas objectAtIndex:section]);
    } else {
        return 0;
    }
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.heightForFooterInSection) {
        return self.heightForFooterInSection(section, [self.datas objectAtIndex:section]);
    } else {
        return 0;
    }
}
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.viewForHeaderInSection) {
        return self.viewForHeaderInSection(section, [self.datas objectAtIndex:section]);
    } else {
        return nil;
    }
}
 
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.viewForFooterInSection) {
        return self.viewForFooterInSection(section, [self.datas objectAtIndex:section]);
    } else {
        return nil;
    }
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item;
    if (!tableView.allowsMultipleSelection) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (self.didSelectRowAtCustom) {
        self.didSelectRowAtCustom(indexPath);
    } else if (self.didSelectRowAtIndexPath) {
        item = [self kj_itemAtIndexPath:indexPath sectionKey:self.sectionKey rowKey:self.rowKey];
        self.didSelectRowAtIndexPath(indexPath, item);
    }
}
 
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didDeselectRowAtIndexPath) {
        id item;
        item = [self kj_itemAtIndexPath:indexPath sectionKey:self.sectionKey rowKey:self.rowKey];
        self.didDeselectRowAtIndexPath(indexPath, item);
    }
}
 
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editingStyleForRowAtIndexPath) {
        return self.editingStyleForRowAtIndexPath(indexPath);
    } else if (self.isAllowEdit && tableView.allowsMultipleSelection) {
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
 
- (id)kj_itemAtSection:(NSInteger)section sectionKey:(NSString *)sectionKey{
    id value;
    @try {
        if (self.numberOfSectionsInTableView) {
            if (sectionKey) {
                value = [self.datas objectAtIndex:section][sectionKey];
            } else {
                value = [self.datas objectAtIndex:section];
            }
        }
    } @catch (NSException *exception) {
        value = nil;
#ifdef DEBUG
        @throw exception;
#endif
    } @finally {
        return value;
    }
}
 
- (id)kj_itemAtIndexPath:(NSIndexPath *)indexPath sectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey{
    if (self.datas.count == 0) return nil;
    id value;
    @try {
        if (self.numberOfSectionsInTableView) {
            if (sectionKey && rowKey) {
                value = self.datas[indexPath.section][sectionKey][indexPath.row][rowKey];
            } else if (sectionKey) {
                value = self.datas[indexPath.section][sectionKey][indexPath.row];
            } else if (rowKey) {
                value = self.datas[indexPath.section][indexPath.row][rowKey];
            } else {
                value = self.datas[indexPath.section][indexPath.row];
            }
        } else if (rowKey) {
            value = self.datas[indexPath.row][rowKey];
        } else {
            value = self.datas[indexPath.row];
        }
    } @catch (NSException *exception) {
        value = nil;
#ifdef DEBUG
        @throw exception;
#endif
    } @finally {
        return value;
    }
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
