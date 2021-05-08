//
//  KJHomeEmitterView.m
//  MoLiao
//
//  Created by 杨科军 on 2018/7/30.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "KJEmitterView.h"

#define KJEmitterGetImage(imageName)  ((__bridge id _Nullable)([UIImage imageNamed:[NSString stringWithFormat:@"KJEmitter.bundle/%@",imageName]].CGImage))

@interface KJEmitterView()<CAAnimationDelegate>

@end

@implementation KJEmitterView

// 配置信息
- (void)config{
    _dissmissTime = 1.0;
}

+ (instancetype)createEmitterViewWithType:(KJEmitterType)type Block:(void(^)(KJEmitterView *obj))block{
    KJEmitterView *obj = [[self alloc] init];
    [obj config];
    if (block) block(obj);
    switch (type) {
        case KJEmitterTypeStarrySky:// 星空粒子效果
            [obj StarrySkyEmitter:obj];
            break;
        case KJEmitterTypeBubble:// 气泡粒子效果
            [obj BubbleEmitter:obj];
            break;
        case KJEmitterTypeFireworks:// 烟花粒子效果
            [obj FireworksEmitter:obj];
            break;
        case KJEmitterTypeSnowflake:// 雪花粒子效果
            [obj SnowflakeEmitter:obj];
            break;
        default:
            break;
    }
    return obj;
}

#pragma mark - 烟花粒子
- (void)FireworksEmitter:(UIView*)view{
    //创建发射器
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    //发射器中心点
    emitter.emitterPosition = CGPointMake(view.bounds.size.width/2, view.bounds.size.height);
    //发射器尺寸
    emitter.emitterSize = CGSizeMake(1, 0);
    /* 发射器发射模式
     kCAEmitterLayerPoints;//从发射器中发出
     kCAEmitterLayerOutline;//从发射器边缘发出
     kCAEmitterLayerSurface;//从发射器表面发出
     kCAEmitterLayerVolume;//从发射器中点发出
     */
    emitter.emitterMode = kCAEmitterLayerOutline;
    /* 发射器形状
     kCAEmitterLayerPoint;//点的形状，粒子从一个点发出
     kCAEmitterLayerLine;//线的形状，粒子从一条线发出
     kCAEmitterLayerRectangle;//矩形形状，粒子从一个矩形中发出
     kCAEmitterLayerCuboid;//立方体形状，会影响Z平面的效果
     kCAEmitterLayerCircle;//圆形，粒子会在圆形范围发射
     kCAEmitterLayerSphere;//球型
     */
    emitter.emitterShape = kCAEmitterLayerLine;
    /* 发射器粒子渲染效果
     kCAEmitterLayerUnordered;//粒子无序出现
     kCAEmitterLayerOldestFirst;//声明久的粒子会被渲染在最上层
     kCAEmitterLayerOldestLast;//年轻的粒子会被渲染在最上层
     kCAEmitterLayerBackToFront;//粒子的渲染按照Z轴的前后顺序进行
     kCAEmitterLayerAdditive;//粒子混合
     */
    emitter.renderMode = kCAEmitterLayerAdditive;
    
    //创建烟花子弹
    CAEmitterCell *bullet = [CAEmitterCell emitterCell];
    bullet.birthRate = 2.0; //子弹诞生速度,每秒诞生个数
    bullet.lifetime = 2.02;//子弹的停留时间,即多少秒后消失
    //子弹的样式,可以给图片
    bullet.contents = KJEmitterGetImage(@"fire");
    //子弹的发射弧度
    bullet.emissionRange = 0.15 * M_PI;
    //子弹的速度
    bullet.velocity = 400;
    //随机速度范围
    bullet.velocityRange = 150;
    //y轴加速度
    bullet.yAcceleration = 0;
    //自转角速度
    bullet.spin = M_PI;
    bullet.scale = 0.5;
    
    //三种随机色
    bullet.redRange = 1.0;
    bullet.greenRange = 1.0;
    bullet.blueRange = 1.0;
    
    //开始爆炸
    CAEmitterCell *burst = [CAEmitterCell emitterCell];
    //属性同上
    burst.birthRate = 1.0;
    burst.velocity = 0;
    burst.scale = 2.5;
    burst.redSpeed = -1.5;
    burst.blueSpeed = 1.5;
    burst.greenSpeed = 1.0;
    burst.lifetime = 0.35;
    
    //爆炸后的烟花
    CAEmitterCell *spark = [CAEmitterCell emitterCell];
    //属性设置同上
    spark.birthRate = 666;
    spark.lifetime = 3;
    spark.velocity = 125;
    spark.velocityRange = 100;
    spark.emissionRange = 2 * M_PI;
    
    spark.contents = KJEmitterGetImage(@"fire");
    spark.scale = 0.1;
    spark.scaleRange = 0.05;
    
    spark.greenSpeed = -0.1;
    spark.redSpeed = 0.4;
    spark.blueSpeed = -0.1;
    spark.alphaSpeed = -0.5;
    spark.spin = 2 * M_PI;
    spark.spinRange = 2 * M_PI;
    
    //这里是重点,先将子弹添加给发射器
    emitter.emitterCells = @[bullet];
    
    //子弹发射后,将爆炸cell添加给子弹cell
    bullet.emitterCells = @[burst];
    
    //将烟花cell添加给爆炸效果cell
    burst.emitterCells = @[spark];
    
    [view.layer addSublayer:emitter];
}

#pragma mark - 气泡粒子
- (void)BubbleEmitter:(UIView*)view{
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.emitterPosition = CGPointMake(view.bounds.size.width/2, view.bounds.size.height);
    emitter.emitterSize = CGSizeMake(view.bounds.size.width, 0);
    emitter.emitterZPosition = -1;
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.emitterMode = kCAEmitterLayerAdditive;//粒子混合
    emitter.preservesDepth = YES;
    emitter.emitterDepth = 10;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.contents = KJEmitterGetImage(@"bubble");
    cell.birthRate = 5;
    cell.lifetime = 20;
    cell.lifetimeRange = 10;
    cell.velocity = 30;
    cell.velocityRange = 10;
    cell.yAcceleration = -2;
    cell.zAcceleration = -2;
    cell.enabled = YES;
    cell.scale = 1;
    cell.scaleRange = 2;
    cell.alphaRange = 0.5f;
    cell.alphaSpeed = -0.3f;      // 粒子消逝的速度
    // 三种随机色
    cell.redRange = 1.0;
    cell.greenRange = 1.0;
    cell.blueRange = 1.0;
    emitter.emitterCells = @[cell];
    [view.layer addSublayer:emitter];
}

#pragma mark - 雪花粒子
- (void)SnowflakeEmitter:(UIView*)view{
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.emitterPosition = CGPointMake(view.bounds.size.width*.5, -20);//发射点
    emitter.emitterSize = CGSizeMake(view.bounds.size.width, 0);
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.emitterMode = kCAEmitterLayerOutline;//发射模式
    emitter.preservesDepth = YES;
    emitter.emitterDepth = 10;
    // 阴影的 不透明度
    emitter.shadowOpacity = 1;
    // 阴影化开的程度（就像墨水滴在宣纸上化开那样）
    emitter.shadowRadius = 8;
    // 阴影的偏移量
    emitter.shadowOffset = CGSizeMake(3, 3);
    // 阴影的颜色
    emitter.shadowColor = [[UIColor whiteColor] CGColor];

    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = KJEmitterGetImage(@"ball");
    // 缩放比例
    snowCell.scale = 0.4;
    snowCell.scaleRange = 0.7;
    // 每秒产生的数量
    snowCell.birthRate = 20;
    snowCell.lifetime = 80;
    // 每秒变透明的速度
    snowCell.alphaSpeed = -0.01;
    // 秒速“五”厘米～～
    snowCell.velocity = 40;
    snowCell.velocityRange = 60;
    // 掉落的角度范围
    snowCell.emissionRange = M_PI;
    // 旋转的速度
    snowCell.spin = M_PI_4;
    
    emitter.emitterCells = @[snowCell];
    [view.layer addSublayer:emitter];
}

#pragma mark - 星空粒子
- (void)StarrySkyEmitter:(UIView*)view{
//    view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
    // 粒子容器
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = view.center;
    emitterLayer.emitterSize = view.frame.size;
    emitterLayer.emitterMode = kCAEmitterLayerVolume;
    emitterLayer.emitterShape = kCAEmitterLayerRectangle;
    emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    
    // 色块粒子
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    // 和CALayer一样，只是用来设置图片
    cell.contents = KJEmitterGetImage(@"blue");
    // enabled:粒子是否被渲染；
    cell.enabled = YES;
    
    cell.lifetime = 5;      // 粒子存活时间
    cell.lifetimeRange = 0; // 生命周期范围
    cell.alphaRange = 0.5f;
    cell.alphaSpeed = -0.3f;// 粒子消逝的速度
    
    //发射器
    cell.birthRate = 20;// 每秒生成粒子的个数
    cell.xAcceleration = 5;
    cell.yAcceleration = 2; // 粒子的初始加速度
    cell.zAcceleration = 2;
    cell.velocity = 20; // 粒子运动的速度均值
    cell.velocityRange = 30.f;// 粒子运动的速度扰动范围
    cell.emissionRange = 2*M_PI; // 粒子发射角度范围
    
    cell.scale = 0.05; // 缩放比例
    cell.scaleRange = 0.1;// 缩放比例范围
    cell.scaleSpeed = 0.05;
    cell.spin = M_PI;// 自旋转角度
    cell.spinRange = 2 * M_PI;// 自旋转角度范围
    
    emitterLayer.emitterCells = @[cell];
    [view.layer addSublayer:emitterLayer];
    
//    // 粒子运动
//    CABasicAnimation *starBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.whiteColor.birthRate"];
//    starBurst.fromValue = [NSNumber numberWithFloat:30];
//    starBurst.toValue = [NSNumber numberWithFloat:0.0];
//    starBurst.duration = 0.5;
//    starBurst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.animations = @[starBurst];
//    group.delegate = self;
//    [emitterLayer addAnimation:group forKey:@"whiteColor"];
}

#pragma mark - <CAAnimationDelegate>
- (void)animationDidStart:(CAAnimation *)anim{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, _dissmissTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        // 撒花结束,移除父视图
        [self removeFromSuperview];
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    !self.EndAnimation?:self.EndAnimation();
}

#pragma mark - 获取颜色图片色块
- (UIImage*)imageWithColor:(UIColor*)color Size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 链接编程设置View的一些属性
- (KJEmitterView *(^)(CGRect))KJFrame {
    return ^(CGRect frame) {
        self.frame = frame;
        return self;
    };
}
- (KJEmitterView *(^)(UIColor *))KJBackgroundColor {
    return ^(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}
- (KJEmitterView *(^)(NSInteger))KJTag {
    return ^(NSInteger tag){
        self.tag = tag;
        return self;
    };
}
- (KJEmitterView *(^)(UIView*))KJAddView {
    return ^(UIView *superView){
        [superView addSubview:self];
        return self;
    };
}

@end
