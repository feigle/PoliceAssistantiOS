//
//  DDSystemMessCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/5.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDSystemMessCell.h"

@implementation DDSystemMessCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.Iconimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 12, 20, 20)];
        self.Iconimg.image=[UIImage imageNamed:@"blue_quan"];
        [self.contentView addSubview:self.Iconimg];
        
        self.Touchimg=[[UIImageView alloc]initWithFrame:CGRectMake(width-23, 15, 8, 13)];
        self.Touchimg.image=[UIImage imageNamed:@"common_small_arrow_icon"];
        [self.contentView addSubview:self.Touchimg];
        
        
        DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:[UIColor blackColor] myfram:CGRectMake(30, 12, 200, 20) mytext:@"任务取消"];
        self.NameLab=lab1;
        [self.contentView addSubview:self.NameLab];
        DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:MAINTEX myfram:CGRectMake(30, CGRectGetMaxY(lab1.frame)+5, width-45, 20) mytext:@"任务编号：47886565656"];
        self.AddressLab=lab2;
        [self.contentView addSubview:self.AddressLab];
        
        
        DDLabel *lab3=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(30, CGRectGetMaxY(lab2.frame)+5, width-45, 20) mytext:@"类型：人员登记"];
        self.StateLab=lab3;
        [self.contentView addSubview:self.StateLab];
        
        DDLabel *lab4=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(width-123, 12, 95, 20) mytext:@"上午 10:10"];
        self.LevelBtn=lab4;
        self.LevelBtn.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.LevelBtn];
        
    }
    return self;
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
