//
//  DDRoomDetaiCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/1.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDRoomDetaiCell.h"

@implementation DDRoomDetaiCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.Iconimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 19.5, 70, 70)];
        self.Iconimg.image=[UIImage imageNamed:@"jsbier"];
        [self.contentView addSubview:self.Iconimg];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 100, KScreenWidth, 7.5)];
        view.backgroundColor=TableViewBg;
        [self.contentView addSubview:view];
        
        
        
        
        DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:17 mycolor:MAINTEX myfram:CGRectMake(100, 20, width-115, 25) mytext:@"买买提"];
        self.NameLab=lab1;
        [self.contentView addSubview:self.NameLab];
        
        self.Touchimg=[[UIImageView alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(lab1.frame)+5, 20, 20)];
        self.Touchimg.image=[UIImage imageNamed:@"phone"];
      //  [self.contentView addSubview:self.Touchimg];
        
        DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(120, CGRectGetMaxY(lab1.frame), width-135, 30) mytext:@"18667898765"];
        self.phoneLab=lab2;
     //   [self.contentView addSubview:self.phoneLab];
        
        
        DDLabel *lab3=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:TEXCOLOR myfram:CGRectMake(100, CGRectGetMaxY(lab1.frame)+10, width-135, 20) mytext:@"入住时间:2016-09-07"];
        self.StateLab=lab3;
        [self.contentView addSubview:self.StateLab];
        
        
    }
    return self;
}
- (void)adddic:(NSDictionary *)dic
{
    self.NameLab.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
    self.phoneLab.text=[NSString stringWithFormat:@"%@",dic[@"mobilePhone"]];
    NSString *str=[NSString stringWithFormat:@"%@",dic[@"pic_1"]];
    [self.Iconimg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"Group@3x"] options:SDWebImageAllowInvalidSSLCertificates];
    self.StateLab.text=[NSString stringWithFormat:@"入住时间:%@",[dic[@"create_time"] substringToIndex:11]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
