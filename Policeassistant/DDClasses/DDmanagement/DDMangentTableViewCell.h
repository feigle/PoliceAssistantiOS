//
//  DDMangentTableViewCell.h
//  Policeassistant
//
//  Created by DoorDu on 16/6/28.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMangentTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * NameLab;//小区名字
@property (nonatomic,strong) UIImageView * Touchimg;//箭
@property (nonatomic,strong) UILabel * HouseLab;//房栋
@property (nonatomic,strong) UILabel * publicsecurityLab;//保安
@property (nonatomic,strong) UILabel * ownerLab;//业主
@property (nonatomic,strong) UILabel * renterLab;//租客
@property (nonatomic,strong) UILabel * deployandcontrolLab;//布控
@property (nonatomic,strong) UILabel * controlledLab;//受控
@property (nonatomic,strong) UIView * lineview;//头部view
@property (nonatomic,strong) UIView * lineview1;//头部view
- (void)adddic:(NSDictionary *)dic;
@end
