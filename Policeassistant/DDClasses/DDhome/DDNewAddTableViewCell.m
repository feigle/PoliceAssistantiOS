//
//  DDNewAddTableViewCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDNewAddTableViewCell.h"

@implementation DDNewAddTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.Iconimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 62.5, 70, 70)];
        self.Iconimg.image=[UIImage imageNamed:@"jsbier"];
        [self.contentView addSubview:self.Iconimg];
        
        self.Touchimg=[[UIImageView alloc]initWithFrame:CGRectMake(width-23, 21, 8, 13)];
        self.Touchimg.image=[UIImage imageNamed:@"common_small_arrow_icon"];
        [self.contentView addSubview:self.Touchimg];
        
        UILabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:TEXCOLOR myfram:CGRectMake(100, 52.5, 40, 32) mytext:@"姓名:"];
        [self.contentView addSubview:lab1];
        
        UILabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:TEXCOLOR myfram:CGRectMake(100, 85, 40, 20) mytext:@"性别:"];
        [self.contentView addSubview:lab2];
        
        UILabel *lab3=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:TEXCOLOR myfram:CGRectMake(100, 112.5, 40, 20) mytext:@"户籍:"];
        [self.contentView addSubview:lab3];
        
        self.NameLab=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:MAINTEX myfram:CGRectMake(140, 52.5, width-155, 32) mytext:@""];
        self.NameLab.numberOfLines=0;
        [self.contentView addSubview:self.NameLab];
        
        self.AddressLab=[[DDLabel alloc]initWithAlertViewHeight:18 mycolor:DaohangCOLOR myfram:CGRectMake(15, 7.5, width-40, 40) mytext:@""];
        self.AddressLab.numberOfLines=0;
        [self.contentView addSubview:self.AddressLab];
        
        self.LevelBtn=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:MAINTEX myfram:CGRectMake(140, 85, 100, 20) mytext:@""];
        [self.contentView addSubview:self.LevelBtn];
        
        self.StateLab=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:MAINTEX myfram:CGRectMake(140, 104, width-155, 38) mytext:@""];
        self.StateLab.numberOfLines=0;
        [self.contentView addSubview:self.StateLab];
        
        self.lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 7.5)];
        self.lineview.backgroundColor=TableViewBg;
        [self.contentView addSubview:self.lineview];
        
        UIView *tempview=[[UIView alloc]initWithFrame:CGRectMake(0, 47.5, width, 1)];
        tempview.backgroundColor=TableViewBg;
        [self.contentView addSubview:tempview];
            
    }
    return self;
}
- (void)adddic:(NSDictionary *)dic
{
    self.NameLab.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
    self.StateLab.text=[NSString stringWithFormat:@"%@",dic[@"address"]];
    NSString *string=[NSString stringWithFormat:@"%@",dic[@"sex"]];
    if ([string isEqualToString:@"1"]) {
        self.LevelBtn.text=[NSString stringWithFormat:@"男"];
    }else{
        self.LevelBtn.text=[NSString stringWithFormat:@"女"];
    }

   self.AddressLab.text=[NSString stringWithFormat:@"%@-%@-%@-%@",dic[@"dep_name"],dic[@"buildname"],dic[@"unitname"],dic[@"roomid"]];
 
    NSString *str=[NSString stringWithFormat:@"%@",dic[@"pic_1"]];
    [self.Iconimg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"Group"] options:SDWebImageAllowInvalidSSLCertificates];

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
