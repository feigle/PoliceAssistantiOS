//
//  DDMissDealCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/4.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDMissDealCell.h"

@implementation DDMissDealCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat ww=70;
        CGFloat www=7.5;
        self.Touchimg=[[UIImageView alloc]initWithFrame:CGRectMake(width-23, 21, 8, 13)];
        self.Touchimg.image=[UIImage imageNamed:@"common_small_arrow_icon"];
        //  [self.contentView addSubview:self.Touchimg];
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, www)];
        view1.backgroundColor=RGB(10, 8, 25);
        [self.contentView addSubview:view1];
        UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(15, www, width-30, 170)];
        bgview.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:bgview];
        bgview.layer.borderWidth = 0.5;
        //倒角
        bgview.layer.cornerRadius = 5;
        bgview.layer.borderColor = [LINECOLOR CGColor];
        
        DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:TEXCOLOR myfram:CGRectMake(15, 0+www, ww, 30) mytext:@"任务编号："];
        [bgview addSubview:lab1];
        
        DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:TEXCOLOR myfram:CGRectMake(15, 30+www, ww, 30) mytext:@"类       型："];
        [bgview addSubview:lab2];
        
        DDLabel *lab3=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:TEXCOLOR myfram:CGRectMake(15, 60+www, ww, 30) mytext:@"处理人员："];
        [bgview addSubview:lab3];
        
        DDLabel *lab4=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:TEXCOLOR myfram:CGRectMake(15, 120+www, ww, 30) mytext:@"地       址："];
        [bgview addSubview:lab4];
        
        DDLabel *lab5=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:TEXCOLOR myfram:CGRectMake(15, 90+www, ww, 30) mytext:@"完成时间："];
        [bgview addSubview:lab5];
        
        DDLabel *lab6=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:DaohangCOLOR myfram:CGRectMake(80, www, width-100, 30) mytext:@"23123123"];
        self.idLab=lab6;
        [bgview addSubview:self.idLab];
        
        DDLabel *lab7=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:MAINTEX myfram:CGRectMake(80, 30+www, width-100, 30) mytext:@"人员信息登记"];
        self.typeLab=lab7;
        [bgview addSubview:self.typeLab];
        
        DDLabel *lab8=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:MAINTEX myfram:CGRectMake(80, 60+www, width-100, 30) mytext:@"张林"];
        self.filishLab=lab8;
        [bgview addSubview:self.filishLab];
        
        DDLabel *lab9=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:MAINTEX myfram:CGRectMake(80, 120+www, width-100, 32) mytext:@"龙联花园1栋1单元1502"];
        self.AddressLab=lab9;
        self.AddressLab.numberOfLines=0;
        [bgview addSubview:self.AddressLab];
        
        DDLabel *lab10=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:MAINTEX myfram:CGRectMake(80, 90+www, width-100, 30) mytext:@"06-25 12:45"];
        self.timeLab=lab10;
        [bgview addSubview:self.timeLab];
        
        DDLabel *lab11=[[DDLabel alloc]initWithAlertViewHeight:13 mycolor:TEXCOLOR myfram:CGRectMake(width-130, 30+www, 85, 30) mytext:@"已完成"];
        self.StateLab=lab11;
        self.StateLab.textAlignment=NSTextAlignmentRight;
        [bgview addSubview:self.StateLab];
        
        
    }
    return self;
}
- (void)adddic:(NSDictionary *)dic
{
    self.idLab.text=[NSString stringWithFormat:@"%@",dic[@"missionid"]];
    self.timeLab.text=[[NSString stringWithFormat:@"%@",dic[@"finishtime"]] substringToIndex:16];
    self.AddressLab.text=[NSString stringWithFormat:@"%@",dic[@"address"]];
    self.filishLab.text=[NSString stringWithFormat:@"%@",dic[@"real_name"]];
    NSString *missiontype=[NSString stringWithFormat:@"%@",dic[@"missiontype"]];
    switch ([missiontype intValue]) {
        case 1:
            self.typeLab.text=[NSString stringWithFormat:@"其他"];
            break;
        case 2:
            self.typeLab.text=[NSString stringWithFormat:@"上门走访"];
            break;
        case 3:
            self.typeLab.text=[NSString stringWithFormat:@"人员信息登记"];
            break;
        default:
            break;
    }
    
    NSString *missionstatus=[NSString stringWithFormat:@"%@",dic[@"missionstatus"]];
    switch ([missionstatus intValue]) {
        case 1:
            self.StateLab.text=[NSString stringWithFormat:@"待处理"];
            self.StateLab.textColor=RGB(255, 150, 0);
            break;
        case 2:
            self.StateLab.text=[NSString stringWithFormat:@"处理中"];
            self.StateLab.textColor=DaohangCOLOR;
            break;
        case 3:
            self.StateLab.text=[NSString stringWithFormat:@"已完成"];
            break;
        default:
            break;
    }
    
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
