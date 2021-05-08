//
//  KJSelectController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/4/14.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJSelectController.h"
#import "KJSelectControl.h"

@interface KJSelectController ()<KJSelectControlDelegate>
@property (weak, nonatomic) IBOutlet KJSelectControl *selectControl_1;
@property (weak, nonatomic) IBOutlet KJSelectControl *selectControl_2;

@end

@implementation KJSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.selectControl_1.delegate = self;
    self.selectControl_2.delegate = self;
    
    self.selectControl_2.animationDuration = 1.0;
    self.selectControl_2.kType = KJSelectControlTypeSolidCircle;
    self.selectControl_2.selected = YES;
}

- (void)kj_selectActionWithControl:(KJSelectControl *)control selected:(BOOL)selected{
    
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
