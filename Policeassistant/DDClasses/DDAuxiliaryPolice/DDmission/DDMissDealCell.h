//
//  DDMissDealCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/4.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMissDealCell : UITableViewCell
@property (nonatomic,strong) UIImageView * Touchimg;//箭头
@property (nonatomic,strong) UILabel * idLab;//任务编号
@property (nonatomic,strong) UILabel * typeLab;//类型
@property (nonatomic,strong) UILabel * filishLab;//处理人员
@property (nonatomic,strong) UILabel * timeLab;//完成时间
@property (nonatomic,strong) UILabel * AddressLab;//地址
@property (nonatomic,strong) UILabel * StateLab;//是否已经完成
- (void)adddic:(NSDictionary *)dic;
@end
