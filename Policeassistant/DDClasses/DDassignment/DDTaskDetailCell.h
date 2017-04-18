//
//  DDTaskDetailCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/1.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTaskDetailCell : UITableViewCell
@property (nonatomic,strong) UILabel * TypeLab;//小区名字
@property (nonatomic,strong) UIImageView * Touchimg;//蓝点
@property (nonatomic,strong) UILabel * TimeLab;//房栋
@property (nonatomic,strong) UIView * upLine;//上线
@property (nonatomic,strong) UIView * downLine;//下线
@end
