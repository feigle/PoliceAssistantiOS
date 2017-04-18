//
//  DDLandlordRecordChoseAuthorizationPopView.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/9.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordRecordChoseAuthorizationPopView.h"
#import "LHDPopView.h"

@interface DDLandlordRecordChoseAuthorizationPopView ()

/**选中image*/
@property (nonatomic,strong) UIImageView * checkImageView;


@end

@implementation DDLandlordRecordChoseAuthorizationPopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

/**开通点击事件*/
- (void)dredgeLabelClicked
{
    if (_isDredge) {/**现在已经是开通状态*/
        [LHDPopView dismiss];
        return;
    }
    self.checkImageView.centerY6 = 100/4.0;
    if (self.retrunRefreshBlock) {
        self.retrunRefreshBlock(YES);
    }
    [LHDPopView dismiss];

}
/**关闭点击事件*/
- (void)closeLabelClicked
{
    if (!_isDredge) {/**现在已经是关闭状态*/
        [LHDPopView dismiss];
        return;
    }
    self.checkImageView.centerY6 = 100/4.0+100/2.0;
    if (self.retrunRefreshBlock) {
        self.retrunRefreshBlock(NO);
    }
    [LHDPopView dismiss];
}


- (void)configUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.width6 = 300/2.0;
    self.height6 = 200/2.0;
    UILabel * dredgeLabel = [ControlManager lableFrame:CGRectZero title:@"开通" font:font6Size(36/2.0) textColor:ColorHex(@"4A4A4A")];
    [dredgeLabel sizeToFit];
    dredgeLabel.x6 = 15;
    dredgeLabel.width6 = self.width6-15;
    dredgeLabel.centerY6 = 100/4.0;
    WeakSelf
    [dredgeLabel addLHDClickedHandle:^(id sender) {
        StrongSelf
        [strongSelf dredgeLabelClicked];
    }];
    [self addSubview:dredgeLabel];
    
    UIView * lineView = [ControlManager viewWithFrame:CGRectMake6(15, 0, self.width6-15, 0) backgroundColor:ColorHex(@"#DDDDDD")];
    lineView.height = 0.5;
    lineView.bottom = 100/2.0-0.25;
    [self addSubview:lineView];
    UILabel * closeLabel = [ControlManager lableFrame:CGRectZero title:@"关闭" font:font6Size(36/2.0) textColor:ColorHex(@"4A4A4A")];
    [closeLabel sizeToFit];
    closeLabel.x6 = 15;
    closeLabel.width6 = self.width6-15;
    closeLabel.centerY6 = 100/4.0+100/2.0;
    [closeLabel addLHDClickedHandle:^(id sender) {
        StrongSelf
        [strongSelf closeLabelClicked];
    }];
    [self addSubview:closeLabel];

    [self addSubview:self.checkImageView];
    
}

- (void)setIsDredge:(BOOL)isDredge
{
    _isDredge = isDredge;
    if (_isDredge) {//开通状态
        self.checkImageView.centerY6 = 100/4.0;
    } else {/**关闭状态*/
        self.checkImageView.centerY6 = 100/4.0+100/2.0;
    }
}

- (UIImageView *)checkImageView
{
    if (!_checkImageView) {
        _checkImageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 0, 36/2.0, 28/2.0) imageName:@"DDLandlordHouseListCheckmarkImage"];
        _checkImageView.right6 = self.width6-15;
        _checkImageView.centerY6 = 100/4.0;
    }
    return _checkImageView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
