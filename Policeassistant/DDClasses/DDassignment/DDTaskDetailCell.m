//
//  DDTaskDetailCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/1.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDTaskDetailCell.h"

@implementation DDTaskDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat w=20;
        self.Touchimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 10, 10)];
        self.Touchimg.image=[UIImage imageNamed:@"state_height"];
        [self.contentView addSubview:self.Touchimg];
        self.upLine=[[UIView alloc]initWithFrame:CGRectMake(19.5, 0, 1, w)];
        self.upLine.backgroundColor=DaohangCOLOR;
        [self.contentView addSubview:self.upLine];
        
        self.downLine=[[UIView alloc]initWithFrame:CGRectMake(19.5, 30, 1, w)];
        self.downLine.backgroundColor=DaohangCOLOR;
        [self.contentView addSubview:self.downLine];
        
        DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(45, 15, 100, 20) mytext:@"下发时间："];
        self.TypeLab=lab1;
        [self.contentView addSubview:self.TypeLab];
        
        DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(120, 15, width-135, 20) mytext:@"06-30 12:23"];
        self.TimeLab=lab2;
        [self.contentView addSubview:self.TimeLab];
        
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
