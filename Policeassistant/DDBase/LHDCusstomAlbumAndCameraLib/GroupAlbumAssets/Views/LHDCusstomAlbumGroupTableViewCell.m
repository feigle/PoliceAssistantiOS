//
//  CusstomAlbumGroupTableViewCell.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/20.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDCusstomAlbumGroupTableViewCell.h"

@interface LHDCusstomAlbumGroupTableViewCell ()

@property (strong, nonatomic) UIImageView *groupImageView;
@property (strong, nonatomic) UILabel *groupNameLabel;
@property (strong, nonatomic) UILabel *groupPicCountLabel;

@end

@implementation LHDCusstomAlbumGroupTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _groupImageView = [[UIImageView alloc] init];
        _groupImageView.frame = CGRectMake(15, 10, 40, 40);
        _groupImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_groupImageView];
        _groupNameLabel = [[UILabel alloc] init];
        _groupNameLabel.frame = CGRectMake(65, 13, self.frame.size.width - 100, 20);
        [self.contentView addSubview:_groupNameLabel];
        _groupPicCountLabel = [[UILabel alloc] init];
        _groupPicCountLabel.font = [UIFont systemFontOfSize:13];
        _groupPicCountLabel.textColor = [UIColor lightGrayColor];
        _groupPicCountLabel.frame = CGRectMake(65, 36, self.frame.size.width - 100, 20);
        [self.contentView addSubview:_groupPicCountLabel];
        
    }
    return self;
}

- (void)setGroupModel:(LHDCusstomAlbumGroupModel *)groupModel
{
    _groupModel = groupModel;
    self.groupNameLabel.text = groupModel.groupName;
    self.groupImageView.image = groupModel.thumbImage;
    self.groupPicCountLabel.text = [NSString stringWithFormat:@"(%ld)",groupModel.assetsCount];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
