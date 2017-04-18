//
//  DDLandlordSettingTableViewCell.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordSettingTableViewCell.h"

@interface DDLandlordSettingTableViewCell ()

/**图片*/
@property (nonatomic,strong) UIImageView * iconImageView;
/**名字*/
@property (nonatomic,strong) UILabel * nameLabel;


@end

@implementation DDLandlordSettingTableViewCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
}

- (void)setModel:(DDLandlordSettingModel *)model
{
    _model = model;
    self.iconImageView.image = [UIImage imageNamed:model.imageName];
    self.nameLabel.text = model.titleName;
    self.nameLabel.textColor = model.titleColor;
    self.iconImageView.size = self.iconImageView.image.size;
    [self.nameLabel sizeToFit];
    self.nameLabel.centerY = self.contentView.height/2.0;
    self.iconImageView.centerY = self.nameLabel.centerY;
    self.iconImageView.left6 = 15;
    self.nameLabel.left6 = self.iconImageView.right6+10;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [ControlManager imageViewWithFrame:CGRectZero];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [ControlManager lableFrame:CGRectMake(0, 0, KScreenWidth-100, font6Size(36/2.0).lineHeight) font:font6Size(36/2.0) textColor:ColorHex(@"#FF6666") textAligment:NSTextAlignmentLeft];
    }
    return _nameLabel;
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
