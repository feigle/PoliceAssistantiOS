//
//  DDInfomationTableViewCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDInfomationTableViewCell.h"

@implementation DDInfomationTableViewCell
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
        
        
        self.NameLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 12, 200, 20)];
        NSString *str=@"深圳市公安局";
        self.NameLab.text=str;
        self.NameLab.font=[UIFont systemFontOfSize:15];
        self.NameLab.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        self.NameLab.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
        CGSize expectSize = [self.NameLab sizeThatFits:maximumLabelSize];
        if (expectSize.width<KScreenWidth-183) {
            self.NameLab.frame = CGRectMake(30, 12, expectSize.width, expectSize.height);
        }else{
            self.NameLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 12, KScreenWidth-183, 20)];
            self.NameLab.text=str;
            self.NameLab.font=[UIFont systemFontOfSize:15];
            self.NameLab.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        }
        
        [self.contentView addSubview:self.NameLab];
        
        self.alertimg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.NameLab.frame)+5, 10, 20, 20)];
        self.alertimg.image=[UIImage imageNamed:@"red_light"];
        [self.contentView addSubview:self.alertimg];
        
        self.AddressLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 32, width-45, 20)];
        self.AddressLab.text=@"小区安保升级改造";
        self.AddressLab.textColor=UIColorFromRGB(0x2452C3);
        self.AddressLab.numberOfLines=0;
        [self.contentView addSubview:self.AddressLab];
        
        self.LevelBtn=[[UILabel alloc]initWithFrame:CGRectMake(width-123, 12, 95, 20)];
        self.LevelBtn.text=@"上午 10:10";
        self.LevelBtn.textAlignment=NSTextAlignmentRight;
        self.LevelBtn.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        [self.contentView addSubview:self.LevelBtn];
        
        self.StateLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 52.5, width-45, 44)];
        self.StateLab.text=@"深圳市龙华新区明治街道龙华新村龙华小区180号深圳市龙华新区明治街道龙华新村龙华小区180号深圳市龙华新区明治街道龙华新村龙华小区180号";
        self.StateLab.numberOfLines=0;
        self.StateLab.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
        [self.contentView addSubview:self.StateLab];
        
        
        
        self.AddressLab.font=[UIFont systemFontOfSize:13];
        self.StateLab.font=[UIFont systemFontOfSize:13];
        self.LevelBtn.font=[UIFont systemFontOfSize:13];
        
        
    }
    return self;
}
- (void)adddic:(NSDictionary *)dic
{
    self.NameLab.text=[NSString stringWithFormat:@"%@",dic[@"dep_name"]];
    self.AddressLab.text=[NSString stringWithFormat:@"%@",dic[@"title"]];
    self.StateLab.text=[NSString stringWithFormat:@"%@",dic[@"content"]];
    NSString *string=[NSString stringWithFormat:@"%@",dic[@"time"]];
    self.LevelBtn.text=[string substringFromIndex:11];
//    "notice_id":1101,"dep_name":"客户定制小区","title":"kehuding","content":"qdi","publisher":null,"is_urgent":1,"is_top":1,"is_read":null,"time":"2016-07-12 14:22:43","is_system":0
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
