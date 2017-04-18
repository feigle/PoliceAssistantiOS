//
//  DDRoomDetaiCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/1.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDRoomDetaiCell : UITableViewCell
@property (nonatomic,strong) UIImageView * Iconimg;//头像
@property (nonatomic,strong) UIImageView * Touchimg;//手机
@property (nonatomic,strong) UILabel * NameLab;//名字
@property (nonatomic,strong) UILabel * phoneLab;//号码
@property (nonatomic,strong) UILabel * StateLab;//入住状态
- (void)adddic:(NSDictionary *)dic;
@end
