//
//  NSObject+KJDoraemonBox.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/29.
//  https://github.com/yangKJ/KJEmitterView

#import "NSObject+KJDoraemonBox.h"
#import "NSObject+KJRuntime.h"
@interface KJObjectDeallocTool : NSObject
@property (nonatomic, copy, readwrite) void(^xxobjectDeallocBlock)(void);
@end
@implementation KJObjectDeallocTool
- (void)dealloc {
    if (self.xxobjectDeallocBlock) {
        self.xxobjectDeallocBlock();
    }
}
@end
@interface NSObject ()
/// 记录已经添加监听的keyPath与对应的block
@property(nonatomic,strong,readonly)NSMutableDictionary *observeDictionary;
@end
@implementation NSObject (KJDoraemonBox)
/// 代码执行时间处理，block当中执行代码
CFTimeInterval kDoraemonBoxExecuteTimeBlock(void(^block)(void)){
    if (block) {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        block();
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"Linked in %f ms", linkTime * 1000.0);
        return linkTime * 1000;
    }
    return 0;
}
/// 延迟点击
void kDoraemonBoxAvoidQuickClick(float time){
    static BOOL canClick;
    if (canClick) return;
    canClick = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        canClick = NO;
    });
}
/// 对象释放时刻调用
static char kListKey;
- (void)kj_objectDeallocBlock:(void(^)(void))block{
    @synchronized (self) {
        NSMutableArray *list = objc_getAssociatedObject(self, &kListKey);
        if (list == nil) {
            list = [NSMutableArray array];
            objc_setAssociatedObject(self, &kListKey, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        KJObjectDeallocTool *tool = [KJObjectDeallocTool new];
        tool.xxobjectDeallocBlock = block;
        [list addObject:tool];
    }
}

#pragma mark - kvo键值监听封装，自动释放
/// kvo监听
- (void)kj_observeKey:(NSString*)keyPath ResultBlock:(KJObserveResultBlock)block{
    if (keyPath.length < 1 || [keyPath containsString:@"."]) return;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRuntimeMethodSwizzling([self class], NSSelectorFromString(@"dealloc"), @selector(kj_kvo_dealloc));
    });
    self.usekvo = YES;
    [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:(__bridge_retained void *)(block)];
    [self.observeDictionary setValue:block forKey:keyPath];
}
- (void)kj_kvo_dealloc{
    if (self.usekvo == NO) {
        [self kj_kvo_dealloc];
        return;
    }
    if (self.observeDictionary) {
        for (NSString *keyPath in self.observeDictionary.allKeys) {
            [self removeObserver:self forKeyPath:keyPath];
        }
        self.observeDictionary = nil;
    }
    [self kj_kvo_dealloc];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == self) {
        KJObserveResultBlock handler = (__bridge KJObserveResultBlock)context;
        handler(change[@"new"],change[@"old"]);
    }
}

#pragma mark - associated
- (BOOL)usekvo{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}
- (void)setUsekvo:(BOOL)usekvo{
    objc_setAssociatedObject(self, @selector(usekvo), @(usekvo), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSMutableDictionary*)observeDictionary{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    return dict;
}
- (void)setObserveDictionary:(NSMutableDictionary*)observeDictionary{
    objc_setAssociatedObject(self, @selector(observeDictionary), observeDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 轻量级解耦工具（信号）
/// 发送消息处理
- (id)kj_sendSemaphoreWithKey:(NSString*)key Message:(id)message Parameter:(id _Nullable)parameter{
#ifdef DEBUG
    NSLog(@"🍒🍒 发送信号消息 🍒🍒\nSenderKey:%@\n目标:%@\n发送者:%@\n携带参数:%@",key,message,self,parameter);
#endif
    if (self.semaphoreblock) return self.semaphoreblock(key,message,parameter);
    return nil;
}
/// 接收消息处理
- (void)kj_receivedSemaphoreBlock:(id _Nullable(^)(NSString *key, id message, id _Nullable parameter))block{
    self.semaphoreblock = block;
}
#pragma mark - associated
- (id _Nullable(^)(NSString *key, id message, id _Nullable parameter))semaphoreblock{
    return objc_getAssociatedObject(self, @selector(semaphoreblock));
}
- (void)setSemaphoreblock:(id _Nullable(^)(NSString *key, id message, id _Nullable parameter))semaphoreblock{
    objc_setAssociatedObject(self, @selector(semaphoreblock), semaphoreblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 路由框架（基于URL实现控制器转场）
+ (NSMutableDictionary*)routerDict{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    return dict;
}
+ (void)setRouterDict:(NSMutableDictionary*)routerDict{
    objc_setAssociatedObject(self, @selector(routerDict), routerDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
NS_INLINE NSString *keyFromURL(NSURL *URL){
    return URL ? [NSString stringWithFormat:@"%@://%@%@",URL.scheme,URL.host,URL.path] : nil;
}
/// 注册路由URL
+ (void)kj_routerRegisterWithURL:(NSURL*)URL Block:(UIViewController * (^)(NSURL *URL, UIViewController *))block{
    if (![self kj_reasonableURL:URL]) return;
    NSString *key = keyFromURL(URL) ?: @"kDefaultRouterKey";
    @synchronized (self) {
        if (self.routerDict[key]) {
            [self.routerDict[key] addObject:block];
        }else{
            self.routerDict[key] = [NSMutableArray arrayWithObject:block];
        }
    }
}
/// 移除路由URL
+ (void)kj_routerRemoveWithURL:(NSURL*)URL{
    if (![self kj_reasonableURL:URL]) return;
    NSString *key = keyFromURL(URL) ?: @"kDefaultRouterKey";
    if (self.routerDict[key]) [self.routerDict removeObjectForKey:key];
    self.routerDict = nil;
}
/// 执行跳转处理
+ (void)kj_routerTransferWithURL:(NSURL*)URL source:(UIViewController*)vc{
    [self kj_routerTransferWithURL:URL source:vc completion:nil];
}
+ (void)kj_routerTransferWithURL:(NSURL*)URL source:(UIViewController*)vc completion:(void(^_Nullable)(UIViewController*))completion{
    if (![self kj_reasonableURL:URL] || ![NSThread isMainThread]) return;
    NSMutableArray<NSArray*>* keys = [NSMutableArray array];
    NSString *currentKey = keyFromURL(URL);
    if (currentKey) [keys addObject:@[currentKey]];
    __block UIViewController *__vc = nil;
    __weak __typeof(&*self) weakself = self;
    [keys enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *temps = [weakself kj_effectiveWithKeys:obj];
        __vc = [weakself kj_getTargetViewControllerWith:temps URL:URL source:vc?:weakself.topViewController];
        *stop = !!__vc;
    }];
    if (__vc == nil) return;
    if (completion) completion(__vc);
}

+ (BOOL)kj_reasonableURL:(NSURL*)URL{
    if (!URL) {
        NSAssert(URL, @"URL can not be nil");
        return NO;
    }
    if ([URL.scheme length] <= 0) {
        NSAssert([URL.scheme length] > 0, @"URL.scheme can not be nil");
        return NO;
    }
    if ([URL.host length] <= 0) {
        NSAssert([URL.host length] > 0, @"URL.host can not be nil");
        return NO;
    }
    if ([URL.absoluteString isEqualToString:@""]) {
        NSAssert(![URL.absoluteString isEqualToString:@""], @"URL.absoluteString can not be nil");
        return NO;
    }
    return YES;
}
+ (NSArray*)kj_effectiveWithKeys:(NSArray*)keys{
    if (!keys || ![keys count]) return nil;
    NSMutableArray *temps = [NSMutableArray array];
    for (NSString *key in keys) {
        if(self.routerDict[key] && [self.routerDict[key] count] > 0) {
            [temps addObjectsFromArray:self.routerDict[key]];
        }
    }
    return temps.mutableCopy;
}
+ (UIViewController*)kj_getTargetViewControllerWith:(NSArray*)blocks URL:(NSURL*)URL source:(UIViewController*)vc{
    if (!blocks || ![blocks count]) return nil;
    __block UIViewController *__vc = nil;
    [blocks enumerateObjectsUsingBlock:^(UIViewController *(^obj)(NSURL *,UIViewController *), NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            __vc = obj(URL,vc);
            if (__vc == nil) *stop = YES;
        }
    }];
    return __vc;
}
+ (UIViewController*)topViewController{
    UIWindow *window = ({
        UIWindow *window;
        if (@available(iOS 13.0, *)) {
            window = [UIApplication sharedApplication].windows.firstObject;
        }else{
            window = [UIApplication sharedApplication].keyWindow;
        }
        window;
    });
    return [self topViewControllerForRootViewController:window.rootViewController];
}
+ (UIViewController*)topViewControllerForRootViewController:(UIViewController*)rootViewController{
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerForRootViewController:navigationController.viewControllers.lastObject];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerForRootViewController:tabBarController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self topViewControllerForRootViewController:rootViewController.presentedViewController];
    }
    if ([rootViewController isViewLoaded] && rootViewController.view.window) {
        return rootViewController;
    }
    return nil;
}

//  路由 - 基于URL实现控制器转场的框架
//  NSURL *URL = [NSURL URLWithString:@"https://www.test.com/xxxx/abc?className=KJVideoEncodeVC&title=title"];
//  URL.query          // className=KJVideoEncodeVC&title=title
//  URL.scheme         // https
//  URL.host           // www.test.com
//  URL.path           // /xxxx/abc
//  URL.absoluteString // https://www.test.com/xxxx/abc?className=KJVideoEncodeVC&title=title
/// 解析获取参数
+ (NSDictionary*)kj_analysisParameterGetQuery:(NSURL*)URL{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithString:URL.absoluteString];
    [URLComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

@end
