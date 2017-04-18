//
//  DDLandlordSettingTableViewHeaderView.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordSettingTableViewHeaderView.h"

@interface DDLandlordSettingTableViewHeaderView ()

@property (nonatomic,strong) UIView * bottomLineView;

@end

@implementation DDLandlordSettingTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _bottomLineView.bottom = [[self class] height];
}

- (void)configUI
{
    self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    [self.contentView addSubview:self.bottomLineView];
//    self.bottomLineView.backgroundColor = [UIColor orangeColor];
//    self.contentView.backgroundColor = [UIColor cyanColor];
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [ControlManager viewWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5) backgroundColor:ColorHex(@"#DDDDDD")];
    }
    return _bottomLineView;
}

+ (CGFloat)height
{
    return 10*kScreen6ScaleH;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
