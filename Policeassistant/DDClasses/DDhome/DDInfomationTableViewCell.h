//
//  DDInfomationTableViewCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDInfomationTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView * Iconimg;//是否已读
@property (nonatomic,strong) UIImageView * Touchimg;//箭头
@property (nonatomic,strong) UILabel * NameLab;//一级标题
@property (nonatomic,strong) UILabel * AddressLab;//二级标题
@property (nonatomic,strong) UILabel * LevelBtn;//时间
@property (nonatomic,strong) UILabel * StateLab;//内容
@property (nonatomic,strong) UIImageView * alertimg;//警报图标
- (void)adddic:(NSDictionary *)dic;
@end
