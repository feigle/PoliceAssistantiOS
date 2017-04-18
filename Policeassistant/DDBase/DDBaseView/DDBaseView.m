//
//  DDBaseView.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseView.h"

@implementation DDBaseView

- (void)returnObjectCallBlock:(__autoreleasing CallBackReturnObjectDataBlock)block
{
    self.retrunObjectBlock = block;
}

- (void)returnRefreshCallBlock:(__autoreleasing CallBackRefreshDataBlock)block
{
    self.retrunRefreshBlock = block;
}

- (void)pushVC:(UIViewController *)vc
{
    [self pushVC:vc animated:YES];
}

- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated
{
    [self.superViewController.navigationController pushViewController:vc animated:animated];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:%@",NSStringFromClass([self class]));
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
