//
//  KJHomeModel.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/16.
//

#import "KJHomeModel.h"

@implementation KJHomeModel
- (instancetype)init{
    if (self=[super init]) {
        self.sectionTemps = @[@"其他相关",@"Kit扩展类",@"图片相关",@"效果类",@"粒子类",@"自定义控件"];
    }
    return self;
}
#pragma mark - lazy
- (NSArray*)temps{
    if (!_temps) {
        NSMutableArray *temp0 = [NSMutableArray array];
        [temp0 addObject:@{@"VCName":@"KJRuntimeTestVC",@"describeName":@"Runtime测试"}];
        [temp0 addObject:@{@"VCName":@"KJArrayTestVC",@"describeName":@"数组操作测试"}];
        [temp0 addObject:@{@"VCName":@"KJLanguageVC",@"describeName":@"多语言测试"}];
        [temp0 addObject:@{@"VCName":@"KJAnimationVC",@"describeName":@"动画效果测试"}];
        [temp0 addObject:@{@"VCName":@"KJToastVC",@"describeName":@"Toast处理"}];
        
        NSMutableArray *temp1 = [NSMutableArray array];
        [temp1 addObject:@{@"VCName":@"KJButtonVC",@"describeName":@"Button图文布局点赞粒子"}];
        [temp1 addObject:@{@"VCName":@"KJLabelVC",@"describeName":@"Label文本位置管理"}];
        [temp1 addObject:@{@"VCName":@"KJViewVC",@"describeName":@"View快速切圆角边框"}];
        [temp1 addObject:@{@"VCName":@"KJGestureVC",@"describeName":@"Gesture手势相关处理"}];
        [temp1 addObject:@{@"VCName":@"KJSliderVC",@"describeName":@"Slider渐变色滑块"}];
        [temp1 addObject:@{@"VCName":@"KJTextFieldVC",@"describeName":@"TextField输入扩展"}];
        [temp1 addObject:@{@"VCName":@"KJTextViewVC",@"describeName":@"TextView设置限制字数"}];
        [temp1 addObject:@{@"VCName":@"KJCollectionVC",@"describeName":@"CollectView滚动处理"}];
        [temp1 addObject:@{@"VCName":@"KJEmptyDataVC",@"describeName":@"TableView空数据状态"}];
        [temp1 addObject:@{@"VCName":@"KJImageViewVC",@"describeName":@"ImageView文字头像"}];
        [temp1 addObject:@{@"VCName":@"KJImageBlurVC",@"describeName":@"ImageView模糊处理"}];
        
        NSMutableArray *temp2 = [NSMutableArray array];
        [temp2 addObject:@{@"VCName":@"KJCodeImageVC",@"describeName":@"Image二维码生成器"}];
        [temp2 addObject:@{@"VCName":@"KJImageJointVC",@"describeName":@"Image拼接性能对比"}];
        [temp2 addObject:@{@"VCName":@"KJImageCompressVC",@"describeName":@"Image压缩性能对比"}];
        [temp2 addObject:@{@"VCName":@"KJFloodImageVC",@"describeName":@"Image填充同颜色区域"}];
        [temp2 addObject:@{@"VCName":@"KJImageVC",@"describeName":@"Image加水印和拼接"}];
        [temp2 addObject:@{@"VCName":@"KJCoreImageVC",@"describeName":@"CoreImage框架相关"}];
        [temp2 addObject:@{@"VCName":@"KJFilterImageVC",@"describeName":@"滤镜相关和特效渲染"}];
        
        NSMutableArray *temp3 = [NSMutableArray array];
        [temp3 addObject:@{@"VCName":@"KJRenderImageVC",@"describeName":@"滤镜渲染"}];
        
        NSMutableArray *temp4 = [NSMutableArray array];
        [temp4 addObject:@{@"VCName":@"KJEmiterLayerVC",@"describeName":@"图片粒子效果整理封装"}];
        [temp4 addObject:@{@"VCName":@"KJEmitterVC",@"describeName":@"粒子效果"}];
        [temp4 addObject:@{@"VCName":@"KJErrorVC",@"describeName":@"错误提示效果"}];
        
        NSMutableArray *temp5 = [NSMutableArray array];
        [temp5 addObject:@{@"VCName":@"KJAlertVC",@"describeName":@"两种AlertView"}];
        [temp5 addObject:@{@"VCName":@"KJSelectController",@"describeName":@"自定义动画选中控件"}];
        [temp5 addObject:@{@"VCName":@"KJSwitchVC",@"describeName":@"自定义动画Switch控件"}];
        [temp5 addObject:@{@"VCName":@"KJMarqueeLabelVC",@"describeName":@"跑马灯Label"}];

        _temps = @[temp0,temp1,temp2,temp3,temp4,temp5];
    }
    return _temps;
}

@end
