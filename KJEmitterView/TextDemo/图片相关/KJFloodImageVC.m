//
//  KJSetDrawVC.m
//  专属橱窗
//
//  Created by 杨科军 on 2018/10/25.
//  Copyright © 2018 杨科军. All rights reserved.
//

#import "KJFloodImageVC.h"
#import "UIImage+KJFloodFill.h" /// 图片泛洪算法

@interface KJFloodImageVC (){
    UIColor *currentColor;
    UIImage *lastImage;
}

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (strong, nonatomic) UIView *indicatorView;

@end

@implementation KJFloodImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lastImage = [UIImage imageNamed:@"zuqiu"];
    currentColor = [UIColor redColor];
    [self setUI];
}

- (void)setUI{
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.indicatorView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (CGRectEqualToRect(self.indicatorView.frame, CGRectZero)) {
        _indicatorView.frame = CGRectMake(self.redButton.frame.origin.x+2, self.redButton.frame.origin.y + self.redButton.frame.size.height+5, self.redButton.frame.size.width-4, 2);
    }
    
    self.bigImageView.image = lastImage;
}
- (IBAction)changeColor:(UIButton *)sender {
    currentColor = sender.backgroundColor;
    self.indicatorView.backgroundColor = currentColor;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.indicatorView.frame;
        frame.origin.x = sender.frame.origin.x+2;
        frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 5;
        self.indicatorView.frame = frame;
    }];
}

- (IBAction)ClickDelButton:(UIButton *)sender {
    NSLog(@"后退");
    if (lastImage!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bigImageView.image = self->lastImage;
        });
    }
}

#pragma mark - 点击手势
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_bigImageView];
    if (![_bigImageView pointInside:point withEvent:event]) {
        NSLog(@"点远了");
        return;
    }
    
    point.x = roundf(_bigImageView.image.size.width / _bigImageView.bounds.size.width * point.x);
    point.y = roundf(_bigImageView.image.size.height / _bigImageView.bounds.size.height * point.y);
    [self covertImageToBitmapWithPoint:point];
}


- (void)covertImageToBitmapWithPoint:(CGPoint)point {
    lastImage = _bigImageView.image;
    self.bigImageView.image = [lastImage kj_FloodFillImageFromStartPoint:point NewColor:currentColor Tolerance:5 UseAntialias:YES];
}

@end
