//
//  UIDevice+KJSystem.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/23.
//  https://github.com/yangKJ/KJEmitterView
//  系统相关的操作

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (KJSystem)
/// App版本号
@property(nonatomic,strong,class)NSString *appCurrentVersion;
/// App名称
@property(nonatomic,strong,class)NSString *appName;
/// 手机UUID
@property(nonatomic,strong,class)NSString *deviceID;
/// 获取App图标
@property(nonatomic,strong,class)UIImage *appIcon;
/// 判断App是否支持横屏
@property(nonatomic,assign,class)BOOL supportHorizontalScreen;
/// 获取启动页图片  
@property(nonatomic,strong,class)UIImage *launchImage;
/// 系统启动图缓存路径
@property(nonatomic,strong,class)NSString *launchImageCachePath;
/// 启动图备份文件路径
@property(nonatomic,strong,class)NSString *launchImageBackupPath;
/// 生成启动图，默认LaunchScreen中获取
/// @param portrait 是否竖屏
/// @param dark 是否暗黑
/// @return 返回启动图
+ (UIImage *)kj_launchImageWithPortrait:(BOOL)portrait
                                   Dark:(BOOL)dark;
/// 生成启动图
/// @param name LaunchScreen名称
/// @param portrait 是否竖屏
/// @param dark 是否暗黑
/// @return 返回启动图
+ (UIImage *)kj_launchImageWithStoryboard:(NSString *)name
                                 Portrait:(BOOL)portrait
                                     Dark:(BOOL)dark;

/// 判断相机是否可用
@property(nonatomic,assign,class)BOOL cameraAvailable;

/// 对比版本号
+ (BOOL)kj_comparisonVersion:(NSString *)version;

/// 获取AppStore版本号和详情信息
/// @param appid App商店版账号
/// @param block 数据信息
/// @return 返回AppStore版本号
+ (NSString *)kj_getAppStoreVersionWithAppid:(NSString *)appid
                                     Details:(void(^)(NSDictionary *userInfo))block;

/// 跳转到指定URL
+ (void)kj_openURL:(id)URL;
/// 调用AppStore
+ (void)kj_skipToAppStoreWithAppid:(NSString *)appid;
/// 调用自带浏览器safari
+ (void)kj_skipToSafari;
/// 调用自带Mail
+ (void)kj_skipToMail;
/// 是否切换为扬声器
+ (void)kj_changeLoudspeaker:(BOOL)loudspeaker;
/// 是否开启手电筒
+ (void)kj_changeFlashlight:(BOOL)light;

/// 指纹验证
+ (void)kj_fingerprintVerification:(void(^)(NSError *error, BOOL reset))block;

@end

NS_ASSUME_NONNULL_END
