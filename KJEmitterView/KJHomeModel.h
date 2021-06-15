//
//  KJHomeModel.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJHomeModel : NSObject
@property(nonatomic,strong)NSArray *sectionTemps;
@property(nonatomic,strong)NSArray *temps;
@property(nonatomic,assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
