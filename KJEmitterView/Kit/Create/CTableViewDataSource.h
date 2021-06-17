//
//  CTableViewDataSource.h
//  KJEmitterView
//
//  Created by yangkejun on 2019/4/25.
//  https://github.com/yangKJ/KJEmitterView
//  快捷链式创建UI

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign, readonly) CGFloat totalHeight;//总高度
@property (nonatomic, assign) BOOL canEdit;//是否可以编辑
/// 设置不同类型的Cell
@property (nonatomic, copy, readwrite) __kindof UITableViewCell * (^tableViewCellAtIndexPath)(NSString * identifier, NSIndexPath * indexPath);
/// 设置不同类型Cell的标识符
@property (nonatomic, copy, readwrite) NSString * (^identifierAtIndexPath)(NSIndexPath * indexPath);
/// 设置不同Cell高度
@property (nonatomic, copy, readwrite) CGFloat (^heightForRowAtIndexPath)(NSIndexPath * indexPath);
/// 返回多少组Section
@property (nonatomic, copy, readwrite) NSInteger (^tableViewNumberSections)(void);
/// 返回每组Section有多少个Cell
@property (nonatomic, copy, readwrite) NSInteger (^numberOfRowsInSection)(NSInteger section);
/// 系统自带右侧标题索引
@property (nonatomic, copy, readwrite) NSArray * (^sectionIndexTitlesForTableView)(void);

//Header
@property (nonatomic, copy, readwrite) CGFloat (^heightForHeaderInSection)(NSInteger section);
@property (nonatomic, copy, readwrite) UIView *(^viewForHeaderInSection)(NSInteger section);
@property (nonatomic, copy, readwrite) NSString * (^titleForHeaderInSection)(NSInteger section);

//Footer
@property (nonatomic, copy, readwrite) CGFloat (^heightForFooterInSection)(NSInteger section);
@property (nonatomic, copy, readwrite) UIView *(^viewForFooterInSection)(NSInteger section);
@property (nonatomic, copy, readwrite) NSString * (^titleForFooterInSection)(NSInteger section);
 
//点击处理
@property (nonatomic, copy, readwrite) void (^didSelectRowAtIndexPath)(NSIndexPath * indexPath);
@property (nonatomic, copy, readwrite) void (^didDeselectRowAtIndexPath)(NSIndexPath * indexPath);

//编辑，删除
@property (nonatomic, copy, readwrite) UITableViewCellEditingStyle (^editingStyleForRowAtIndexPath)(NSIndexPath * indexPath);
@property (nonatomic, copy, readwrite) BOOL (^canEditRowAtIndexPath)(NSIndexPath * indexPath);
@property (nonatomic, copy, readwrite) void (^deleteRowAtIndexPath)(NSIndexPath * indexPath);

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
- (instancetype)initWithConfigureBlock:(void(^)(UITableViewCell * cell, NSIndexPath * indexPath))block;

@end

@protocol KJViewDelegate,KJLabelDelegate;
@protocol KJImageViewDelegate,KJButtonDelegate;
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
