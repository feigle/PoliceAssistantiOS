//
//  DDMangentTableViewCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/28.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDMangentTableViewCell.h"

@implementation DDMangentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat basewidth=(width-45)/3;
        
        self.Touchimg=[[UIImageView alloc]initWithFrame:CGRectMake(width-23, 23, 8, 13)];
        self.Touchimg.image=[UIImage imageNamed:@"common_small_arrow_icon"];
        [self.contentView addSubview:self.Touchimg];
        
        self.NameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 7.5, width-100, 44)];
        self.NameLab.text=@"测试小区";
        [self.contentView addSubview:self.NameLab];
        
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(15, 65, basewidth, 13)];
        
        UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(22.5+basewidth, 65, basewidth, 13)];
        
        UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(30+basewidth*2, 65, basewidth, 13)];
        
        UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(15, 87, basewidth, 13)];
        
        UIView *view5=[[UIView alloc]initWithFrame:CGRectMake(22.5+basewidth, 87, basewidth, 13)];
        
        UIView *view6=[[UIView alloc]initWithFrame:CGRectMake(30+basewidth*2, 87, basewidth, 13)];
        
        [self.contentView addSubview:view1];
        [self.contentView addSubview:view2];
        [self.contentView addSubview:view3];
        [self.contentView addSubview:view4];
        [self.contentView addSubview:view5];
        [self.contentView addSubview:view6];
        
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 13)];
        lab1.text=@"房栋数";
        lab1.textColor=[UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1];
        lab1.font=sysFont13;
        [view1 addSubview:lab1];
        
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 13)];
        lab2.text=@"业主人数";
        lab2.textColor=[UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1];
        lab2.font=sysFont13;
        [view2 addSubview:lab2];
        
        UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 13)];
        lab3.text=@"管控人数";
        lab3.textColor=[UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1];
        lab3.font=sysFont13;
        [view3 addSubview:lab3];
        
        UILabel *lab4=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 13)];
        lab4.text=@"保安人数";
        lab4.textColor=[UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1];
        lab4.font=sysFont13;
        [view4 addSubview:lab4];
        
        UILabel *lab5=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 13)];
        lab5.text=@"租客人数";
        lab5.textColor=[UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1];
        lab5.font=sysFont13;
        [view5 addSubview:lab5];
        
        UILabel *lab6=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 13)];
        lab6.text=@"受控人数";
        lab6.textColor=[UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1];
        lab6.font=sysFont13;
     //   [view6 addSubview:lab6];
        
        _HouseLab=[[UILabel alloc]initWithFrame:CGRectMake(47.5, 0, basewidth-47.5, 13)];
        _HouseLab.text=@"--";
        _HouseLab.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        _HouseLab.font=sysFont13;
        [view1 addSubview:_HouseLab];
        
        _ownerLab=[[UILabel alloc]initWithFrame:CGRectMake(59.5, 0, basewidth-59.5, 13)];
        _ownerLab.text=@"--";
        _ownerLab.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        _ownerLab.font=sysFont13;
        [view2 addSubview:_ownerLab];
        
        _deployandcontrolLab=[[UILabel alloc]initWithFrame:CGRectMake(59.5, 0, basewidth-59.5, 13)];
        _deployandcontrolLab.text=@"--";
        _deployandcontrolLab.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        _deployandcontrolLab.font=sysFont13;
        [view3 addSubview:_deployandcontrolLab];
        
        _publicsecurityLab=[[UILabel alloc]initWithFrame:CGRectMake(59.5, 0, basewidth-59.5, 13)];
        _publicsecurityLab.text=@"--";
        _publicsecurityLab.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        _publicsecurityLab.font=sysFont13;
        [view4 addSubview:_publicsecurityLab];
        
        _renterLab=[[UILabel alloc]initWithFrame:CGRectMake(59.5, 0, basewidth-59.5, 13)];
        _renterLab.text=@"--";
        _renterLab.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        _renterLab.font=sysFont13;
        [view5 addSubview:_renterLab];
        
        _controlledLab=[[UILabel alloc]initWithFrame:CGRectMake(59.5, 0, basewidth-59.5, 13)];
        _controlledLab.text=@"--";
        _controlledLab.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        _controlledLab.font=sysFont13;
    //    [view6 addSubview:_controlledLab];
        
        self.lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 7.5)];
        self.lineview.backgroundColor=TableViewBg;
        [self.contentView addSubview:self.lineview];
        
        self.lineview1=[[UIView alloc]initWithFrame:CGRectMake(0, 51.5, width, 1)];
        self.lineview1.backgroundColor=TableViewBg;
        [self.contentView addSubview:self.lineview1];
        
        self.NameLab.font=[UIFont systemFontOfSize:18];
        self.NameLab.textColor=[UIColor colorWithRed:67.0/255 green:114.0/255 blue:226.0/255 alpha:1];
        
    }
    return self;
}
- (void)adddic:(NSDictionary *)dic
{
    self.NameLab.text=[NSString stringWithFormat:@"%@",dic[@"communityName"]];
    self.renterLab.text=[NSString stringWithFormat:@"%@",dic[@"tenant"]];
    self.ownerLab.text=[NSString stringWithFormat:@"%@",dic[@"ownerCount"]];
    self.HouseLab.text=[NSString stringWithFormat:@"%@",dic[@"buildcount"]];
    self.publicsecurityLab.text=[NSString stringWithFormat:@"%@",dic[@"securityCount"]];
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
