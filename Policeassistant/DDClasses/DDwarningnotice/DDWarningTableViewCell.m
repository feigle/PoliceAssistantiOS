//
//  DDWarningTableViewCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/28.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDWarningTableViewCell.h"

@implementation DDWarningTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.Iconimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 19.5, 70, 70)];
        self.Iconimg.image=[UIImage imageNamed:@"jsbier"];
        [self.contentView addSubview:self.Iconimg];
        
        self.Touchimg=[[UIImageView alloc]initWithFrame:CGRectMake(width-23, 84.5, 8, 13)];
        self.Touchimg.image=[UIImage imageNamed:@"common_small_arrow_icon"];
        [self.contentView addSubview:self.Touchimg];
        
        self.NameLab=[[UILabel alloc]initWithFrame:CGRectMake(100, 7.5, width-180, 36)];
        self.NameLab.text=@"买买提";
        self.NameLab.numberOfLines=0;
        [self.contentView addSubview:self.NameLab];
        
        self.AddressLab=[[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(self.NameLab.frame), width-115, 32)];
        
        self.AddressLab.text=@"风家园－1栋－1单元－102室风家园－1栋－1单元－102室";
        self.AddressLab.textColor=[UIColor colorWithRed:183/255.0f green:183/255.0f blue:183/255.0f alpha:1];;
        self.AddressLab.numberOfLines=0;
        [self.contentView addSubview:self.AddressLab];
        
        self.LevelBtn=[[UIButton alloc]initWithFrame:CGRectMake(width-80, 15, 65, 20)];
        [self.LevelBtn setBackgroundImage:[UIImage imageNamed:@"police_other"] forState:UIControlStateNormal];
        [self.LevelBtn setTitle:@"二级警报" forState:UIControlStateNormal];
        self.LevelBtn.titleLabel.textColor=[UIColor whiteColor];
        self.LevelBtn.titleLabel.font=sysFont13;
        [self.contentView addSubview:self.LevelBtn];
        
        self.StateLab=[[UILabel alloc]initWithFrame:CGRectMake(100, 81, width-130, 20)];
        // self.StateLab.textAlignment=NSTextAlignmentRight;
        self.StateLab.text=@"犯罪前科人员入住";
        self.StateLab.textColor=[UIColor colorWithRed:255/255.0f green:150/255.0f blue:0/255.0f alpha:1];;
     //   [self.contentView addSubview:self.StateLab];
        
        self.lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 109, width, 7.5)];
        self.lineview.backgroundColor=TableViewBg;
        [self.contentView addSubview:self.lineview];
        
        self.NameLab.font=[UIFont systemFontOfSize:15];
        self.NameLab.textColor=MAINTEX;
        self.AddressLab.font=[UIFont systemFontOfSize:13];
        self.StateLab.font=[UIFont systemFontOfSize:13];
        
        
    }
    return self;
}
- (void)adddic:(NSDictionary *)dic
{
    self.NameLab.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
    self.AddressLab.text=[NSString stringWithFormat:@"%@%@%@%@",dic[@"dep_name"],dic[@"buildname"],dic[@"unit_name"],dic[@"roomid"]];
    
    [self.LevelBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"dangerousInfo"]] forState:UIControlStateNormal];
    NSString *dangerousLv=[NSString stringWithFormat:@"%@",dic[@"dangerousLv"]];
    if ([dangerousLv isEqualToString:@"1"]) {
        [self.LevelBtn setBackgroundImage:[UIImage imageNamed:@"first_police"] forState:UIControlStateNormal];
    }else if ([dangerousLv isEqualToString:@"2"])
    {
        [self.LevelBtn setBackgroundImage:[UIImage imageNamed:@"ploice_scend"] forState:UIControlStateNormal];
        
    }else if ([dangerousLv isEqualToString:@"3"]){
        
        [self.LevelBtn setBackgroundImage:[UIImage imageNamed:@"police_three"] forState:UIControlStateNormal];
    }else{
        [self.LevelBtn setBackgroundImage:[UIImage imageNamed:@"police_other"] forState:UIControlStateNormal];
    }
    NSString *str=[NSString stringWithFormat:@"%@",dic[@"pic_1"]];
    [self.Iconimg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"Group@3x"] options:SDWebImageAllowInvalidSSLCertificates];
   // self.ownerLab.text=[NSString stringWithFormat:@"%@",dic[@"ownerCount"]];
   // self.publicsecurityLab.text=[NSString stringWithFormat:@" %@",dic[@"securityCount"]];
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
