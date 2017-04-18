//
//  DDAlarmCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/4.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDAlarmCell.h"

@implementation DDAlarmCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height=40;
        CGFloat www=7.5;
        UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(15, www, width-30, 240)];
        bgview.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:bgview];
        bgview.layer.borderWidth = 0.5;
        //倒角
        bgview.layer.cornerRadius = 5;
        bgview.layer.borderColor = [LINECOLOR CGColor];
        
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-30, height)];
        view1.backgroundColor=DaohangCOLOR;
        view1.layer.cornerRadius = 5;
        [bgview addSubview:view1];
        self.Touchimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
        self.Touchimg.image=[UIImage imageNamed:@"clock_normal"];
        [view1 addSubview:self.Touchimg];
        
        for (int i=0; i<3; i++) {
            UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 80+i*height, KScreenWidth-30, 0.5)];
            lineview.backgroundColor=LINECOLOR;
            [bgview addSubview:lineview];
        }
        
        DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(view1.frame), 90, height) mytext:@"姓       名"];
        [bgview addSubview:lab1];
        
        DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(lab1.frame), 90, height) mytext:@"电       话"];
        [bgview addSubview:lab2];
        
        DDLabel *lab3=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(lab2.frame), 90, height) mytext:@"申报地址"];
        [bgview addSubview:lab3];
        DDLabel *lab4=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(lab3.frame), 90, height*2) mytext:@"申报事由"];
        [bgview addSubview:lab4];
        
        
        DDLabel *lab7=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(95, CGRectGetMaxY(view1.frame), KScreenWidth-130, height) mytext:@"张三"];
        self.NameLab=lab7;
        [bgview addSubview:self.NameLab];
        
        DDLabel *lab8=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(95, CGRectGetMaxY(lab1.frame), width-130, height) mytext:@"18520827262"];
        self.PhoneLab=lab8;
        [bgview addSubview:self.PhoneLab];
        
        DDLabel *lab9=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(95, CGRectGetMaxY(lab2.frame), width-130, height) mytext:@"龙联花园1栋1单元1502室"];
        self.AddressLab=lab9;
        self.AddressLab.numberOfLines=0;
        [bgview addSubview:self.AddressLab];
        
        DDLabel *lab10=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:[UIColor whiteColor] myfram:CGRectMake(50, 0, width-80, height) mytext:@"2016-06-25 12:45"];
        self.timeLab=lab10;
        [bgview addSubview:self.timeLab];
        
        DDLabel *lab11=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(95, CGRectGetMaxY(lab3.frame), width-130, height*2) mytext:@"打架斗殴"];
        self.StateLab=lab11;
        self.StateLab.numberOfLines=0;
        [bgview addSubview:self.StateLab];
    }
    return self;
}
- (void)adddic:(NSDictionary *)dic
{
    self.NameLab.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
    self.AddressLab.text=[NSString stringWithFormat:@"%@",dic[@"address"]];
    self.PhoneLab.text=[NSString stringWithFormat:@"%@",dic[@"phone"]];
    self.StateLab.text=[NSString stringWithFormat:@" %@",dic[@"reason"]];
    self.timeLab.text=[NSString stringWithFormat:@" %@",dic[@"time"]];

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
