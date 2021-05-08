//
//  _KJQuickCreateBox.h
//  KJEmitterView
//
//  Created by yangkejun on 2019/4/25.
//  https://github.com/yangKJ/KJEmitterView
//  快捷链式创建UI

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 遵守 UITableView、UICollectionView 的 dataSource 协议，处理数据的传递，简化 viewController 中的代码
@interface _KJQuickCreateBox : NSObject<UITableViewDataSource, UICollectionViewDataSource>
@property (nonatomic, copy) NSArray *datas;/// 数据源，支持二级数据源
+ (instancetype)init NS_UNAVAILABLE;
/// 初始化，目前只支持同种Cell处理
- (instancetype)initWithDatas:(NSArray * _Nullable)datas
                   identifier:(NSString*)identifier
                 cellCallBack:(void(^)(id cell, id data, NSIndexPath *indexPath))callback;
/// 获取NSIndexPath位置数据
- (id)kj_dataAtIndexPath:(NSIndexPath*)indexPath;

@end

@protocol KJViewDelegate,KJLabelDelegate;
@protocol KJImageViewDelegate,KJButtonDelegate;
@protocol KJTableViewCreateDelegate;
// UIView
@interface UIView (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createView:(void(^)(id<KJViewDelegate>view))handle;
FOUNDATION_EXPORT UIView * kDoraemonBoxCreateView(void(^handle)(id<KJViewDelegate>view));

@end

// UILabel
@interface UILabel (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createLabel:(void(^)(id<KJLabelDelegate>label))handle;
FOUNDATION_EXPORT UILabel * kDoraemonBoxCreateLabel(void(^handle)(id<KJLabelDelegate>label));

@end

// UIImageView
@interface UIImageView (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createImageView:(void(^)(id<KJImageViewDelegate>imageView))handle;
FOUNDATION_EXPORT UIImageView * kDoraemonBoxCreateImageView(void(^handle)(id<KJImageViewDelegate>imageView));

@end

// UIButton
@interface UIButton (KJCreate)
/// 快速创建处理
+ (instancetype)kj_createButton:(void(^)(id<KJButtonDelegate>button))handle;
FOUNDATION_EXPORT UIButton * kDoraemonBoxCreateButton(void(^handle)(id<KJButtonDelegate>button));

@end

// UITableView
@interface UITableView (KJCreate)
+ (instancetype)kj_createTableView:(void(^)(id<KJTableViewCreateDelegate>tableView))handle;
FOUNDATION_EXPORT UITableView * kDoraemonBoxCreateTableView(void(^handle)(id<KJTableViewCreateDelegate>tableView));

@end

//****************************  协议委托  ****************************
@protocol KJCustomDelegate <NSObject>
@optional;
@property(nonatomic,copy,readonly)id<KJCustomDelegate>(^kj_frame)(CGFloat x,CGFloat y,CGFloat w,CGFloat h);
@property(nonatomic,copy,readonly)id<KJCustomDelegate>(^kj_add)(UIView*);
@property(nonatomic,copy,readonly)id<KJCustomDelegate>(^kj_background)(UIColor*);
@end

@protocol KJViewDelegate <KJCustomDelegate>
@optional;

@end

@protocol KJLabelDelegate <KJCustomDelegate>
@optional;
@property(nonatomic,copy,readonly)id<KJLabelDelegate>(^kj_text)(NSString*);
@property(nonatomic,copy,readonly)id<KJLabelDelegate>(^kj_font)(UIFont*);
@property(nonatomic,copy,readonly)id<KJLabelDelegate>(^kj_fontSize)(CGFloat);
@property(nonatomic,copy,readonly)id<KJLabelDelegate>(^kj_textColor)(UIColor*);
@end

@protocol KJImageViewDelegate <KJCustomDelegate>
@optional;
@property(nonatomic,copy,readonly)id<KJImageViewDelegate>(^kj_image)(UIImage*);
@property(nonatomic,copy,readonly)id<KJImageViewDelegate>(^kj_imageName)(NSString*);
@end

@protocol KJButtonDelegate <KJLabelDelegate,KJImageViewDelegate>
@optional;
@property(nonatomic,copy,readonly)id<KJButtonDelegate>(^kj_stateImage)(UIImage*,UIControlState);
@property(nonatomic,copy,readonly)id<KJButtonDelegate>(^kj_stateTitle)(NSString*,UIColor*,UIControlState);
@end

@protocol KJTableViewCreateDelegate <KJCustomDelegate>
@optional;
/// 数据源
@property(nonatomic,copy,readonly)id<KJTableViewCreateDelegate>(^kj_dataSource)(void(^callback)(UITableViewCell * cell, id data, NSIndexPath *indexPath), NSArray *datas, NSString *identifier);
@end

NS_ASSUME_NONNULL_END
