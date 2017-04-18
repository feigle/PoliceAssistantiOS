//
//  DDNewAddTableViewCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDNewAddTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView * Iconimg;//头像
@property (nonatomic,strong) UIImageView * Touchimg;//箭头
@property (nonatomic,strong) UILabel * NameLab;//名字
@property (nonatomic,strong) UILabel * AddressLab;//地址
@property (nonatomic,strong) UILabel * LevelBtn;//警报级别
@property (nonatomic,strong) UILabel * StateLab;//入住状态
@property (nonatomic,strong) UIView * lineview;//底部view
- (void)adddic:(NSDictionary *)dic;
@end
