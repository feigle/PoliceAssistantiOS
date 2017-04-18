//
//  DDSystemMessCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/5.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSystemMessCell : UITableViewCell
@property (nonatomic,strong) UIImageView * Iconimg;//是否已读
@property (nonatomic,strong) UIImageView * Touchimg;//箭头
@property (nonatomic,strong) UILabel * NameLab;//一级标题
@property (nonatomic,strong) UILabel * AddressLab;//二级标题
@property (nonatomic,strong) UILabel * LevelBtn;//时间
@property (nonatomic,strong) UILabel * StateLab;//内容
@end
