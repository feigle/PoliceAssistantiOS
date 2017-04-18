//
//  DDLandlordHouseListTableViewCell.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordHouseListTableViewCell.h"

@interface DDLandlordHouseListTableViewCell ()

/**标题*/
@property (nonatomic,strong) UILabel * nameLabel;
/**选中image*/
@property (nonatomic,strong) UIImageView * checkImageView;
/**下划线*/
@property (nonatomic,strong) UIView * bottomLineView;

@end

@implementation DDLandlordHouseListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.checkImageView];
    [self.contentView addSubview:self.bottomLineView];
    self.nameLabel.centerY = [[self class] cellHeight]/2.0;
    self.checkImageView.centerY = [[self class] cellHeight]/2.0;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [ControlManager lableFrame:CGRectMake6(15, 0, kScreen6Width-30-50, 0) font:font6Size(36/2.0) textColor:ColorHex(@"#3F3F3F")];
        _nameLabel.height = font6Size(36/2.0).lineHeight;
        _nameLabel.text = @"和谐小区";
    }
    return _nameLabel;
}

- (UIImageView *)checkImageView
{
    if (!_checkImageView) {
        _checkImageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 0, 36/2.0, 28/2.0) imageName:@"DDLandlordHouseListCheckmarkImage"];
        _checkImageView.right6 = kScreen6Width-15;
    }
    return _checkImageView;
}
- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [ControlManager viewWithFrame:CGRectMake6(15, 0, kScreen6Width-15, 0) backgroundColor:ColorHex(@"#DDDDDD")];
        _bottomLineView.height = 0.5;
        _bottomLineView.alpha = 0.6;
        _bottomLineView.bottom = [[self class] cellHeight];
    }
    return _bottomLineView;
}

- (void)setModel:(DDLandlordHouseListModel *)model
{
    _model = model;
    if (model.selected) {
        self.checkImageView.hidden = NO;
    } else {
        self.checkImageView.hidden = YES;
    }
    self.nameLabel.text = [model.full_name toString];
}

+ (CGFloat)cellHeight
{
    return 120/2.0*kScreen6ScaleH;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
