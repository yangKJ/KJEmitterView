//
//  KJColorSlider.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/8/24.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView

#import "KJColorSlider.h"
#import "UIColor+KJExtension.h"
@interface KJColorSlider()
@property(nonatomic,strong) UIImageView *backImageView;
@property(nonatomic,assign) NSTimeInterval lastTime;
@property(nonatomic,assign) CGFloat progress;
@end

@implementation KJColorSlider
#pragma mark - public method
- (void)kj_setUI{ [self drawNewImage];}

#pragma mark - system method
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (CGRectEqualToRect(self.backImageView.frame, CGRectZero)) {
        CGRect imgViewFrame = self.backImageView.frame;
        imgViewFrame.size.width = self.frame.size.width;
        imgViewFrame.size.height = self.colorHeight;
        imgViewFrame.origin.y = (self.frame.size.height - self.colorHeight) * 0.5;
        self.backImageView.frame = imgViewFrame;
        [self drawNewImage];
    }
}
#pragma mark - private method
- (void)drawNewImage{
    self.backImageView.image = [UIColor kj_colorImageWithColors:_colors locations:_locations size:CGSizeMake(self.frame.size.width, _colorHeight) borderWidth:_borderWidth borderColor:_borderColor];
    self.progress = self.value;
}
- (void)setup{
    self.colors = @[UIColor.whiteColor];
    self.locations = @[@(1.)];
    self.colorHeight = 2.5;
    self.borderWidth = 0.0;
    self.borderColor = UIColor.blackColor;
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.backImageView];
    [self sendSubviewToBack:self.backImageView];
    self.tintColor = [UIColor clearColor];
    self.maximumTrackTintColor = self.minimumTrackTintColor = [UIColor clearColor];
    [self addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(endMove) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(endMove) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchCancel];
}
- (void)valueChange{
    self.progress = self.value;
    if (self.kValueChangeBlock) {
        if (_timeSpan == 0) {
            self.kValueChangeBlock(self.value);
        }else if (CFAbsoluteTimeGetCurrent() - self.lastTime > _timeSpan) {
            _lastTime = CFAbsoluteTimeGetCurrent();
            self.kValueChangeBlock(self.value);
        }
    }
}
- (void)endMove{
    self.progress = self.value;
    if (self.kMoveEndBlock) {
        self.kMoveEndBlock(self.value);
        return;
    }
    if (self.kValueChangeBlock) self.kValueChangeBlock(self.value);
}
- (void)touchCancel{
    self.progress = self.value;
    if (self.kMoveEndBlock) self.kMoveEndBlock(self.value);
}

@end
