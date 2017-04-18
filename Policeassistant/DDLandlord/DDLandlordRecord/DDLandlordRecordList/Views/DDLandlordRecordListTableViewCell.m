//
//  DDLandlordRecordListTableViewCell.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/9.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordRecordListTableViewCell.h"

@interface DDLandlordRecordListTableViewCell ()

/**申请房号*/
@property (nonatomic,strong) UILabel * applyForRoomNumberLabel;
/**被授权人名字*/
@property (nonatomic,strong) UILabel * byAuthorizationPersonLabel;
/**app授权是否开通*/
@property (nonatomic,strong) UILabel * appAuthorizationLabel;
/**门禁卡授权是否开通*/
@property (nonatomic,strong) UILabel * cardAuthorizationLabel;

@end

@implementation DDLandlordRecordListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark - cell布局界面
- (void)configUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.cellHeightt = (10+88/2.0+45)*kScreen6ScaleH+font6Size(36/2.0).lineHeight*2;
#pragma mark - 上面的分割块
    UIView * topPartitionView = [ControlManager viewWithFrame:CGRectMake6(0, 0, kScreen6Width, 10) backgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00]];
    UIView * lineView = [ControlManager viewWithFrame:CGRectMake6(0, 0, topPartitionView.width6, 0.5) backgroundColor:ColorHex(@"#DDDDDD")];
    lineView.height = 0.5;
    lineView.bottom = topPartitionView.height;
    [topPartitionView addSubview:lineView];
    [self.contentView addSubview:topPartitionView];
#pragma mark - 申请房号
    UIView * applyForRoomNumberBgView = [ControlManager viewWithFrame:CGRectMake6(0, 0, kScreen6Width, 88/2.0) backgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00]];
    applyForRoomNumberBgView.top = topPartitionView.bottom;
    [self.contentView addSubview:applyForRoomNumberBgView];
    UILabel * applyForRoomNumberDesLabel = [ControlManager lableFrame:CGRectMake6(15, 0, 0, 0) title:@"申请房号" font:font6Size(36/2.0) textColor:ColorHex(@"#999999") textAligment:NSTextAlignmentLeft];
    [applyForRoomNumberDesLabel sizeToFit];
    applyForRoomNumberDesLabel.x6 = 15;
    applyForRoomNumberDesLabel.centerY = applyForRoomNumberBgView.height/2.0;
    [applyForRoomNumberBgView addSubview:applyForRoomNumberDesLabel];
    [applyForRoomNumberBgView addSubview:self.applyForRoomNumberLabel];
    self.applyForRoomNumberLabel.centerY = applyForRoomNumberDesLabel.centerY;
    UIImageView * arrowImageView = [ControlManager imageViewWithImageName:@"DDLandlordCommonarrowright"];
    arrowImageView.right6 = applyForRoomNumberBgView.width6-15;
    arrowImageView.centerY = applyForRoomNumberBgView.height/2.0;
    [applyForRoomNumberBgView addSubview:arrowImageView];
    self.applyForRoomNumberLabel.width6 = applyForRoomNumberBgView.width6 - applyForRoomNumberDesLabel.width6-60-arrowImageView.width6;
    self.applyForRoomNumberLabel.x6 = applyForRoomNumberDesLabel.right6+15;
#pragma mark -  被授权人
    UILabel * byAuthorizationDesLabel = [self commonDesAuthorizationLabel:@"被授权人" top:applyForRoomNumberBgView.bottom+15*kScreen6ScaleH];
    [byAuthorizationDesLabel sizeToFit];
    byAuthorizationDesLabel.x6 = 15;
    [self.contentView addSubview:byAuthorizationDesLabel];
    self.byAuthorizationPersonLabel.centerY = byAuthorizationDesLabel.centerY;
    self.byAuthorizationPersonLabel.width6 = kScreen6Width - byAuthorizationDesLabel.width6-60-arrowImageView.width6;
    self.byAuthorizationPersonLabel.x6 = byAuthorizationDesLabel.right6+15;
    [self.contentView addSubview:self.byAuthorizationPersonLabel];
#pragma mark - app授权
    UILabel * appAuthorizationDesLabel = [self commonDesAuthorizationLabel:@"APP授权" top:byAuthorizationDesLabel.bottom+15*kScreen6ScaleH];
    [self.contentView addSubview:appAuthorizationDesLabel];
    self.appAuthorizationLabel.top = appAuthorizationDesLabel.top;
    [self.contentView addSubview:self.appAuthorizationLabel];
#pragma mark - 门禁卡授权
    UILabel * cardAuthorizationDesLabel = [self commonDesAuthorizationLabel:@"门禁卡授权" top:appAuthorizationDesLabel.bottom+15*kScreen6ScaleH];
    [self.contentView addSubview:cardAuthorizationDesLabel];
    self.cardAuthorizationLabel.top = cardAuthorizationDesLabel.top;
    [self.contentView addSubview:self.cardAuthorizationLabel];
}

#pragma mark - 赋值

- (void)setModel:(DDLandlordRecordListModel *)model
{
    _model = model;
    self.applyForRoomNumberLabel.text = [NSString stringWithFormat:@"%@室",[model.apply_room_no toString]];
    self.byAuthorizationPersonLabel.text = [model.be_author toString];
    self.appAuthorizationLabel.text = [model.app_auth_status toString];
    self.cardAuthorizationLabel.text = [model.card_auth_status toString];
}

#pragma mark - 懒加载在这里
/**申请房号*/
- (UILabel *)applyForRoomNumberLabel
{
    if (!_applyForRoomNumberLabel) {
        _applyForRoomNumberLabel = [ControlManager lableFrame:CGRectZero title:@"0101室" font:font6Size(36/2.0) textColor:ColorHex(@"#4A4A4A")];
        _applyForRoomNumberLabel.height = font6Size(36/2.0).lineHeight;
    }
    return _applyForRoomNumberLabel;
}
/**被授权人名字*/
- (UILabel *)byAuthorizationPersonLabel
{
    if (!_byAuthorizationPersonLabel) {
        _byAuthorizationPersonLabel = [ControlManager lableFrame:CGRectZero title:@"好人" font:font6Size(36/2.0) textColor:ColorHex(@"#4A4A4A")];
        _byAuthorizationPersonLabel.height = font6Size(36/2.0).lineHeight;
    }
    return _byAuthorizationPersonLabel;
}

/**app授权是否开通*/
- (UILabel *)appAuthorizationLabel
{
    if (!_appAuthorizationLabel) {
        _appAuthorizationLabel = [ControlManager lableFrame:CGRectMake6(0, 0, 260, 0) title:@"开通" font:font6Size(36/2.0) textColor:ColorHex(@"4A4A4A") textAligment:NSTextAlignmentRight];
        _appAuthorizationLabel.height = font6Size(36/2.0).lineHeight;
        _appAuthorizationLabel.right6 = kScreen6Width-15;
    }
    return _appAuthorizationLabel;
}
/**门禁卡授权是否开通*/
- (UILabel *)cardAuthorizationLabel
{
    if (!_cardAuthorizationLabel) {
        _cardAuthorizationLabel = [ControlManager lableFrame:CGRectMake6(0, 0, 260, 0) title:@"开通" font:font6Size(36/2.0) textColor:ColorHex(@"4A4A4A") textAligment:NSTextAlignmentRight];
        _cardAuthorizationLabel.height = font6Size(36/2.0).lineHeight;
        _cardAuthorizationLabel.right6 = kScreen6Width-15;
    }
    return _cardAuthorizationLabel;
}

- (UILabel *)commonDesAuthorizationLabel:(NSString *)text top:(CGFloat)top
{
    UILabel * label = [ControlManager lableFrame:CGRectZero title:text font:font6Size(36/2.0) textColor:ColorHex(@"#999999")];
    [label sizeToFit];
    label.top = top;
    label.x6 = 15;
    return label;
}

+ (CGFloat)cellHeight
{
    static CGFloat cellheight = 0;
    if (cellheight) {
        return cellheight;
    }
    cellheight = (10+88/2.0+60)*kScreen6ScaleH+font6Size(36/2.0).lineHeight*3;
    return cellheight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
