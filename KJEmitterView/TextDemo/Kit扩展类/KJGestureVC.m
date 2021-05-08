//
//  KJGestureVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/11/12.
//

#import "KJGestureVC.h"

@interface KJGestureVC ()
@property(nonatomic,strong)UIImageView *displayImageView;
@property(nonatomic,assign)CGRect originRect;
@property(nonatomic,assign)CGPoint originCenter;
@property(nonatomic,assign)CGFloat lastScale;
@property(nonatomic,assign)CGFloat minScale,maxScale;
@end

@implementation KJGestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.displayImageView.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.3];
    self.displayImageView.image = kGetImage(@"IMG_4931store_1024pt");
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.displayImageView];
    self.originRect = self.displayImageView.frame;
    self.originCenter = self.displayImageView.center;
    self.maxScale = 2;
    self.lastScale = self.minScale = 1;

    _weakself;
    [self.displayImageView kj_AddTapGestureRecognizerBlock:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        NSLog(@"单击");
    }];
    [self.displayImageView kj_AddGestureRecognizer:(KJGestureTypeDouble) block:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        NSLog(@"双击");
        view.frame = weakself.originRect;
        weakself.lastScale = 1;
    }];
    [self.displayImageView kj_AddGestureRecognizer:(KJGestureTypePan) block:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer*)gesture;
        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
        NSLog(@"移动%.2f",translation.x);
        switch (panGestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:{
                CGFloat minx = weakself.originCenter.x - (kScreenW*(weakself.lastScale-1))/2.;
                CGFloat maxx = weakself.originCenter.x + (kScreenW*(weakself.lastScale-1))/2.;
                CGFloat miny = weakself.originCenter.y - (kScreenH*(weakself.lastScale-1))/2.;
                CGFloat maxy = weakself.originCenter.y + (kScreenH*(weakself.lastScale-1))/2.;
                if (minx > view.center.x) {
                    view.centerX = minx;return;
                }else if (view.center.x > maxx) {
                    view.centerX = maxx;return;
                }else if (miny > view.center.y) {
                    view.centerY = miny;return;
                }else if (view.center.y > maxy) {
                    view.centerY = maxy;return;
                }
                if (minx <= view.center.x && view.center.x <= maxx && miny <= view.center.y && view.center.y <= maxy) {
                    [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
                    [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
                }
            }
                break;
            case UIGestureRecognizerStateEnded:
                break;
            default:
                break;
        }
    }];
    [self.displayImageView kj_AddGestureRecognizer:(KJGestureTypePinch) block:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        UIPinchGestureRecognizer *pinchGestureRecognizer = (UIPinchGestureRecognizer*)gesture;
        NSLog(@"缩放%.2f,%.2f",weakself.lastScale,pinchGestureRecognizer.scale);
        switch (pinchGestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
    //                weakself.lastScalePoint = [pinchGestureRecognizer locationInView:view];
    //                break;
            case UIGestureRecognizerStateChanged:{
                CGFloat scale = weakself.lastScale+pinchGestureRecognizer.scale-1;
                if (scale >= weakself.maxScale || scale <= weakself.minScale) {
                    return;
                }
                CGFloat w = kScreenW * scale;
                CGFloat h = kScreenH * scale;
                CGFloat x = weakself.originRect.origin.x - (kScreenW*(scale-1))/2.;
                CGFloat y = weakself.originRect.origin.y - (kScreenH*(scale-1))/2.;
                view.frame = CGRectMake(x, y, w, h);
            }
                break;
            case UIGestureRecognizerStateEnded:{
                CGFloat scale = weakself.lastScale+pinchGestureRecognizer.scale-1;
                if (scale >= weakself.maxScale) {
                    weakself.lastScale = weakself.maxScale;
                }else if (scale <= weakself.minScale) {
                    weakself.lastScale = weakself.minScale;
                }else{
                    weakself.lastScale += (pinchGestureRecognizer.scale-1);
                }
            }
                break;
            default:
                break;
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
