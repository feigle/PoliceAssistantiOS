//
//  DDLandlordRecordEmptyListView.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/17.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordRecordEmptyListView.h"

@implementation DDLandlordRecordEmptyListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    self.userInteractionEnabled = YES;
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
    UILabel * labelOne = [ControlManager lableFrame:CGRectMake(0, 0, KScreenWidth, font6Size(48/2.0).lineHeight) title:@"暂无住户" font:font6Size(48/2.0) textColor:ColorHex(@"#999999") textAligment:NSTextAlignmentCenter];
    labelOne.top6 = 585/2.0;
    labelOne.top -= 64;
    [self addSubview:labelOne];
    UILabel * labelTwo = [ControlManager lableFrame:CGRectMake(0, 0, KScreenWidth, font6Size(36/2.0).lineHeight) title:@"当有授权住户时，您可以点击进入这里查看" font:font6Size(36/2.0) textColor:ColorHex(@"#999999") textAligment:NSTextAlignmentCenter];
    labelTwo.width6 = kScreen6Width - 90;
    labelTwo.numberOfLines = 0;
    [labelTwo setStringHeight];
    labelTwo.top6 = labelOne.bottom6 + 30/2.0;
    labelTwo.centerX = KScreenWidth/2.0;
    [self addSubview:labelTwo];
    UIButton * addStepButton = [ControlManager buttonTitle:@"添加新住户" font:font6Size(36/2.0) textColor:ColorHex(@"#FFFFFF") frame:CGRectMake(0, 0, KScreenWidth, 0) target:self selector:@selector(addStepButtonClicked)];
    addStepButton.height6 = 88/2.0;
    addStepButton.backgroundColor = DaohangCOLOR;
    addStepButton.bottom = KScreenHeight-64;
    [self addSubview:addStepButton];
}
#pragma mark - 添加新住户点击事件
- (void)addStepButtonClicked
{
    if (self.retrunRefreshBlock) {
        self.retrunRefreshBlock(YES);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
