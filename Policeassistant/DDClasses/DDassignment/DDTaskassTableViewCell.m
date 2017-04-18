//
//  DDTaskassTableViewCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/30.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDTaskassTableViewCell.h"


@implementation DDTaskassTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat ww=85;
        CGFloat www=7.5;
        self.Touchimg=[[UIImageView alloc]initWithFrame:CGRectMake(width-23, 21, 8, 13)];
        self.Touchimg.image=[UIImage imageNamed:@"common_small_arrow_icon"];
        //  [self.contentView addSubview:self.Touchimg];
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, www)];
        view1.backgroundColor=TableViewBg;
        [self.contentView addSubview:view1];
        
        DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, 0+www, ww, 30) mytext:@"任务编号："];
        [self.contentView addSubview:lab1];
        
        DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, 30+www, ww, 30) mytext:@"类       型："];
        [self.contentView addSubview:lab2];
        
        DDLabel *lab3=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, 60+www, ww, 30) mytext:@"处理人员："];
        [self.contentView addSubview:lab3];
        
        DDLabel *lab4=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, 120+www+5, ww, 30) mytext:@"地       址："];
        [self.contentView addSubview:lab4];
        
        DDLabel *lab5=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, 90+www, ww, 30) mytext:@"受理时间："];
        self.StateLabType=lab5;
        [self.contentView addSubview:lab5];
        
        DDLabel *lab6=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:DaohangCOLOR myfram:CGRectMake(90, www, width-100, 30) mytext:@"23123123"];
        self.idLab=lab6;
        [self.contentView addSubview:self.idLab];
        
        DDLabel *lab7=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, 30+www, width-100, 30) mytext:@"人员信息登记"];
        self.typeLab=lab7;
        [self.contentView addSubview:self.typeLab];
        
        DDLabel *lab8=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, 60+www, width-100, 30) mytext:@"张林"];
        self.filishLab=lab8;
        [self.contentView addSubview:self.filishLab];
        
        DDLabel *lab9=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, 120+www, width-100, 40) mytext:@"龙联花园1栋1单元1502室"];
        self.AddressLab=lab9;
        self.AddressLab.numberOfLines=0;
        [self.contentView addSubview:self.AddressLab];
        
        DDLabel *lab10=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, 90+www, width-100, 30) mytext:@"06-25 12:45"];
        self.timeLab=lab10;
        [self.contentView addSubview:self.timeLab];
        
        DDLabel *lab11=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(width-100, 30+www, 85, 30) mytext:@"已完成"];
        self.StateLab=lab11;
        self.StateLab.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.StateLab];
        
        self.LevelBtn=[[UIButton alloc]initWithFrame:CGRectMake(width-69, 12.5, 54, 22)];
//        [self.LevelBtn setTitle:@"紧急" forState:UIControlStateNormal];
//        [self.LevelBtn setBackgroundImage:[UIImage imageNamed:@"first_police"] forState:UIControlStateNormal];
        self.LevelBtn.titleLabel.font=sysFont16;
        [self.contentView addSubview:self.LevelBtn];
        
    }
    return self;
}
- (void)adddic:(NSDictionary *)dic
{
    self.idLab.text=[NSString stringWithFormat:@"%@",dic[@"missionid"]];
    
    self.AddressLab.text=[NSString stringWithFormat:@"%@",dic[@"address"]];
    self.filishLab.text=[NSString stringWithFormat:@"%@",dic[@"real_name"]];
    NSString *missionlv=[NSString stringWithFormat:@"%@",dic[@"missionlv"]];
    switch ([missionlv intValue]) {
        case 1:
            [self.LevelBtn setTitle:@"" forState:UIControlStateNormal];
            [self.LevelBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            break;
        case 2:
            [self.LevelBtn setTitle:@"紧急" forState:UIControlStateNormal];
            [self.LevelBtn setBackgroundImage:[UIImage imageNamed:@"first_police"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
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
            self.StateLabType.text=[NSString stringWithFormat:@"下发时间："];
            self.timeLab.text=[[NSString stringWithFormat:@"%@",dic[@"time"]] substringToIndex:16];
            break;
        case 2:
            self.StateLab.text=[NSString stringWithFormat:@"处理中"];
            self.StateLab.textColor=DaohangCOLOR;
            self.StateLabType.text=[NSString stringWithFormat:@"受理时间："];
            self.timeLab.text=[[NSString stringWithFormat:@"%@",dic[@"committime"]] substringToIndex:16];
            break;
        case 3:
            self.StateLab.text=[NSString stringWithFormat:@"已完成"];
            self.StateLab.textColor=TEXCOLOR;
            self.StateLabType.text=[NSString stringWithFormat:@"完成时间："];
            self.timeLab.text=[[NSString stringWithFormat:@"%@",dic[@"finishtime"]] substringToIndex:16];
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
