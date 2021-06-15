//
//  CreateTableViewDataSource.h
//  KJEmitterView
//
//  Created by yangkejun on 2019/4/25.
//  https://github.com/yangKJ/KJEmitterView
//  快捷链式创建UI

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KJCreateTableBlock)(id cell, NSIndexPath * indexPath, id item);
@interface CreateTableViewDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *datas;/// 数据源
@property (nonatomic, assign) BOOL isAllowEdit;
@property (nonatomic, strong) NSString *sectionKey;
@property (nonatomic, strong) NSString *rowKey;
@property (nonatomic, assign, readonly) CGFloat totalHeight;
//设置内容，
@property (nonatomic, copy, readwrite) KJCreateTableBlock cellForRowAtIndexPath;
@property (nonatomic, copy, readwrite) void (^cellForRowAtCustom)(id cell, NSIndexPath * indexPath);
@property (nonatomic, copy, readwrite) UITableViewCell * (^kTableViewCell)(NSIndexPath * indexPath);
//高度
@property (nonatomic, copy, readwrite) CGFloat (^heightForRowAtIndexPath)(NSIndexPath * indexPath, id item);
@property (nonatomic, copy, readwrite) void (^didSelectRowAtCustom)(NSIndexPath * indexPath);
@property (nonatomic, copy, readwrite) void (^didSelectRowAtIndexPath)(NSIndexPath * indexPath, id item);
@property (nonatomic, copy, readwrite) void (^didDeselectRowAtIndexPath)(NSIndexPath * indexPath, id item);

//Number
@property (nonatomic, copy, readwrite) NSInteger (^numberOfSectionsInTableView)(NSMutableArray * datas);
@property (nonatomic, copy, readwrite) NSInteger (^numberOfRowsInSection)(NSInteger section, id item);
@property (nonatomic, copy, readwrite) NSArray * (^sectionIndexTitlesForTableView)(void);
 
//Header
@property (nonatomic, copy, readwrite) CGFloat (^heightForHeaderInSection)(NSInteger section, id item);
@property (nonatomic, copy, readwrite) UIView *(^viewForHeaderInSection)(NSInteger section, id item);
@property (nonatomic, copy, readwrite) NSString * (^titleForHeaderInSection)(NSInteger section, id item);
 
//Footer
@property (nonatomic, copy, readwrite) CGFloat (^heightForFooterInSection)(NSInteger section, id item);
@property (nonatomic, copy, readwrite) UIView *(^viewForFooterInSection)(NSInteger section, id item);
@property (nonatomic, copy, readwrite) NSString * (^titleForFooterInSection)(NSInteger section, id item);
 
//编辑，删除
@property (nonatomic, copy, readwrite) UITableViewCellEditingStyle (^editingStyleForRowAtIndexPath)(NSIndexPath * indexPath);
@property (nonatomic, copy, readwrite) BOOL (^canEditRowAtIndexPath)(NSIndexPath * indexPath, id item);
@property (nonatomic, copy, readwrite) void (^deleteRowAtIndexPath)(NSIndexPath * indexPath, id item);

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
/// 初始化，目前只支持同种Cell处理
- (instancetype)initWithDatas:(NSArray * _Nullable)datas
                   identifier:(NSString *)identifier
                    withBlock:(KJCreateTableBlock)block;
/// 获取NSIndexPath位置数据
- (id)kj_itemAtSection:(NSInteger)section sectionKey:(NSString *)sectionKey;
 
- (id)kj_itemAtIndexPath:(NSIndexPath *)indexPath
              sectionKey:(NSString *)sectionKey
                  rowKey:(NSString * _Nullable)rowKey;

@end

@protocol KJViewDelegate,KJLabelDelegate;
@protocol KJImageViewDelegate,KJButtonDelegate;
@protocol KJTableViewCreateDelegate;
// UIView
@interface UIView (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createView:(void(^)(id<KJViewDelegate>view))handle;
+ (instancetype)kj_createView:(void(^)(id<KJViewDelegate>view))handle frame:(CGRect)frame;

@end

// UILabel
@interface UILabel (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createLabel:(void(^)(id<KJLabelDelegate>label))handle;

@end

// UIImageView
@interface UIImageView (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createImageView:(void(^)(id<KJImageViewDelegate>imageView))handle;
+ (instancetype)kj_createImageView:(void(^)(id<KJImageViewDelegate>imageView))handle frame:(CGRect)frame;

@end

// UIButton
@interface UIButton (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createButton:(void(^)(id<KJButtonDelegate>button))handle;

@end

// UITableView
@interface UITableView (KJCreate)
+ (instancetype)kj_createTableView:(void(^)(id<KJTableViewCreateDelegate>tableView))handle;

@end



//****************************  协议委托  ****************************
@protocol KJCustomDelegate <NSObject>
@optional;
@property(nonatomic,copy,readonly)id<KJCustomDelegate>(^kj_frame)(CGFloat x, CGFloat y, CGFloat w, CGFloat h);
@property(nonatomic,copy,readonly)id<KJCustomDelegate>(^kj_add)(UIView *);
@property(nonatomic,copy,readonly)id<KJCustomDelegate>(^kj_background)(UIColor *);

@end


@protocol KJViewDelegate <KJCustomDelegate>

@optional;

@end


@protocol KJLabelDelegate <KJCustomDelegate>
@optional;
@property(nonatomic,copy,readonly)id<KJLabelDelegate>(^kj_text)(NSString *);
@property(nonatomic,copy,readonly)id<KJLabelDelegate>(^kj_font)(UIFont *);
@property(nonatomic,copy,readonly)id<KJLabelDelegate>(^kj_fontSize)(CGFloat);
@property(nonatomic,copy,readonly)id<KJLabelDelegate>(^kj_textColor)(UIColor *);

@end


@protocol KJImageViewDelegate <KJCustomDelegate>
@optional;
@property(nonatomic,copy,readonly)id<KJImageViewDelegate>(^kj_image)(UIImage *);
@property(nonatomic,copy,readonly)id<KJImageViewDelegate>(^kj_imageName)(NSString *);

@end


@protocol KJButtonDelegate <KJLabelDelegate,KJImageViewDelegate>
@optional;
@property(nonatomic,copy,readonly)id<KJButtonDelegate>(^kj_stateImage)(UIImage *, UIControlState);
@property(nonatomic,copy,readonly)id<KJButtonDelegate>(^kj_stateTitle)(NSString *, UIColor *, UIControlState);

@end

NS_ASSUME_NONNULL_END
