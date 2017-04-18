//
//  DDAlarmCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/4.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAlarmCell : UITableViewCell
@property (nonatomic,strong) UIImageView * Touchimg;//钟
@property (nonatomic,strong) UILabel * NameLab;//姓名
@property (nonatomic,strong) UILabel * PhoneLab;//电话
@property (nonatomic,strong) UILabel * timeLab;//完成时间
@property (nonatomic,strong) UILabel * AddressLab;//申报地址
@property (nonatomic,strong) UILabel * StateLab;//申报事由
- (void)adddic:(NSDictionary *)dic;
@end
