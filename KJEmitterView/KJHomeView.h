//
//  KJHomeView.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kHomeViewKey = @"kHomeView";
@interface KJHomeView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *sectionTemps;
@property(nonatomic,strong)NSArray *temps;

@end

NS_ASSUME_NONNULL_END
