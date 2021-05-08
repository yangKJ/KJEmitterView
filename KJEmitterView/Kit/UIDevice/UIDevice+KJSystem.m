//
//  UIDevice+KJSystem.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/23.
//  https://github.com/yangKJ/KJEmitterView

#import "UIDevice+KJSystem.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <LocalAuthentication/LocalAuthentication.h>// 指纹解锁必须的头文件

@implementation UIDevice (KJSystem)
@dynamic appCurrentVersion,appName,appIcon,deviceID,supportHorizontalScreen;
+ (NSString*)appCurrentVersion{
    static NSString * version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    });
    return version;
}
+ (NSString*)appName{
    static NSString * name;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    });
    return name;
}
+ (NSString*)deviceID{
    static NSString * identifier;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    });
    return identifier;
}
+ (UIImage*)appIcon{
    static UIImage * image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"];
        NSString *name = [iconFilename stringByDeletingPathExtension];
        image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:[iconFilename pathExtension]]];
    });
    return image;
}
+ (BOOL)supportHorizontalScreen{
    NSArray *temp = [NSBundle.mainBundle.infoDictionary objectForKey:@"UISupportedInterfaceOrientations"];
    if ([temp containsObject:@"UIInterfaceOrientationLandscapeLeft"] || [temp containsObject:@"UIInterfaceOrientationLandscapeRight"]) {
        return YES;
    }else{
        return NO;
    }
}
@dynamic launchImage,launchImageCachePath,launchImageBackupPath;
+ (UIImage*)launchImage{
    UIImage *lauchImage = nil;
    NSString *viewOrientation = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        viewOrientation = @"Landscape";
    }else{
        viewOrientation = @"Portrait";
    }
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return lauchImage;
}
+ (NSString*)launchImageCachePath{
    NSString *bundleID = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
    NSString *path = nil;
    if (@available(iOS 13.0, *)) {
        NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        path = [NSString stringWithFormat:@"%@/SplashBoard/Snapshots/%@ - {DEFAULT GROUP}", libraryDirectory, bundleID];
    }else{
        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        path = [[cachesDirectory stringByAppendingPathComponent:@"Snapshots"] stringByAppendingPathComponent:bundleID];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return path;
    }
    return nil;
}
+ (NSString*)launchImageBackupPath{
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesDirectory stringByAppendingPathComponent:@"ll_launchImage_backup"];
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:@{} error:nil];
    }
    return path;
}
/// 生成启动图
+ (UIImage*)kj_launchImageWithPortrait:(BOOL)portrait Dark:(BOOL)dark{
    return [self kj_launchImageWithStoryboard:@"LaunchScreen" Portrait:portrait Dark:dark];
}
/// 生成启动图，根据LaunchScreen名称、是否竖屏、是否暗黑
+ (UIImage*)kj_launchImageWithStoryboard:(NSString*)name Portrait:(BOOL)portrait Dark:(BOOL)dark{
    if (@available(iOS 13.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        window.overrideUserInterfaceStyle = dark?UIUserInterfaceStyleDark:UIUserInterfaceStyleLight;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIView *__view = storyboard.instantiateInitialViewController.view;
    __view.frame = [UIScreen mainScreen].bounds;
    CGFloat w = __view.frame.size.width;
    CGFloat h = __view.frame.size.height;
    if (portrait) {
        if (w > h) __view.frame = CGRectMake(0, 0, h, w);
    }else{
        if (w < h) __view.frame = CGRectMake(0, 0, h, w);
    }
    [__view setNeedsLayout];
    [__view layoutIfNeeded];
    UIGraphicsBeginImageContextWithOptions(__view.frame.size, NO, [UIScreen mainScreen].scale);
    [__view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *launchImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return launchImage;
}
@dynamic cameraAvailable;
+ (BOOL)cameraAvailable{
    NSArray *temps = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    BOOL canTakeVideo = NO;
    for (NSString *mediaType in temps) {
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
            canTakeVideo = YES;
            break;
        }
    }
    return canTakeVideo;
}
/// 对比版本号
+ (BOOL)kj_comparisonVersion:(NSString*)version{
    if ([version compare:UIDevice.appCurrentVersion] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}
/// 获取AppStore版本号和详情信息
+ (NSString*)kj_getAppStoreVersionWithAppid:(NSString*)appid Details:(void(^)(NSDictionary*))block{
    __block NSString *appVersion = UIDevice.appCurrentVersion;
    if (appid == nil) return appVersion;
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@",appid];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_async(dispatch_group_create(), queue, ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDictionary * dict = [json[@"results"] firstObject];
            appVersion = dict[@"version"];
            if (block) block(dict);
            dispatch_semaphore_signal(semaphore);
        }] resume];
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return appVersion;
}
/// 跳转到指定URL
+ (void)kj_openURL:(id)URL{
    if (URL == nil) return;
    if (![URL isKindOfClass:[NSURL class]]) {
        URL = [NSURL URLWithString:URL];
    }
    if ([[UIApplication sharedApplication] canOpenURL:URL]){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:URL];
#pragma clang diagnostic pop
        }
    }
}
/// 调用AppStore
+ (void)kj_skipToAppStoreWithAppid:(NSString*)appid{
    NSString *urlString = [@"http://itunes.apple.com/" stringByAppendingFormat:@"%@?id=%@",self.appName,appid];
    [self kj_openURL:urlString];
}
/// 调用自带浏览器safari
+ (void)kj_skipToSafari{
    [self kj_openURL:@"http://www.abt.com"];
}
/// 调用自带Mail
+ (void)kj_skipToMail{
    [self kj_openURL:@"mailto://admin@abt.com"];
}
/// 是否切换为扬声器
+ (void)kj_changeLoudspeaker:(BOOL)loudspeaker{
    if (loudspeaker) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
}
/// 是否开启手电筒
+ (void)kj_changeFlashlight:(BOOL)light{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![captureDevice hasTorch]) return;
    if (light) {
        NSError *error = nil;
        if ([captureDevice lockForConfiguration:&error]) {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
        }
    }else{
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:AVCaptureTorchModeOff];
    }
    [captureDevice unlockForConfiguration];
}
/// 指纹验证
+ (void)kj_fingerprintVerification:(void(^)(NSError *error, BOOL reset))block{
    LAContext * context = [[LAContext alloc]init];
    if (@available(iOS 10.0, *)) {
        context.localizedCancelTitle = NSLocalizedString(@"取消", nil);
    }
    NSError * error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:NSLocalizedString(@"验证指纹以确认你的身份", nil) reply:^(BOOL success, NSError *error) {
            if (success) {
                if (block) block(nil,YES);
            }else{
                if (block) block(error,NO);
            }
        }];
    }else{
        if (block) block(error,NO);
    }
}

@end
