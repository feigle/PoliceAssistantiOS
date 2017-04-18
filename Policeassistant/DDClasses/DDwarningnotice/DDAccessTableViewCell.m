//
//  DDAccessTableViewCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDAccessTableViewCell.h"

@implementation DDAccessTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.TypeLab=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(35, 40, width-50, 40) mytext:@""];
        self.TypeLab.numberOfLines=0;
        [self.contentView addSubview:self.TypeLab];
        
        self.AddressLab=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(35, CGRectGetMaxY(self.TypeLab.frame)+5, width-35, 20) mytext:@"金桥花园4007"];
        [self.contentView addSubview:self.AddressLab];
        
        self.TimeLab=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:DaohangCOLOR myfram:CGRectMake(35, 20, 70, 20) mytext:@""];
        [self.contentView addSubview:self.TimeLab];

        self.Iconimg=[[UIImageView alloc]initWithFrame:CGRectMake(3, 2.5, 74, 50)];
        self.Iconimg.image=[UIImage imageNamed:@"jsbier"];
        self.Iconimg.layer.masksToBounds = YES;
        self.Iconimg.layer.cornerRadius = 5;
        
        self.Veidoimg=[[UIImageView alloc]initWithFrame:CGRectMake(3, 2.5, 74, 50)];
        self.Veidoimg.image=[UIImage imageNamed:@"jsbier"];
        self.Veidoimg.layer.masksToBounds = YES;
        self.Veidoimg.layer.cornerRadius = 5;
        
        _view1=[[UIView alloc]initWithFrame:CGRectMake(35,CGRectGetMaxY(self.AddressLab.frame)+10, 80, 55)];
        _view1.layer.borderWidth = 1;
        _view1.layer.masksToBounds = YES;
        _view1.layer.cornerRadius = 5;
        _view1.layer.borderColor = [LINECOLOR CGColor];
        
        _view3=[[UIView alloc]initWithFrame:CGRectMake(3, 2.5, 74, 50)];;
        _view3.backgroundColor=[UIColor blackColor];
        _view3.alpha=0.5;
        _view3.layer.masksToBounds = YES;
        _view3.layer.cornerRadius = 5;


        [self.contentView addSubview:_view1];
        [_view1 addSubview:self.Iconimg];

        
        _btn=[[UIButton alloc]init];
        _btn.frame=_view1.bounds;
        [_view1 addSubview:_btn];
        [_btn setImage:[UIImage imageNamed:@"av_play@3x"] forState:UIControlStateNormal];
        UIImage *image1=[DDTools buttonImageFromColor:RGB(73, 74, 75)];
        [_btn setBackgroundImage:image1 forState:UIControlStateNormal];
        _btn.hidden=YES;
        
        _btn1=[[UIButton alloc]init];
        _btn1.frame=_view1.bounds;
        _btn1.hidden=NO;
        [_view1 addSubview:_btn1];
        
        self.flagimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 10, 10)];
        self.flagimg.image=[UIImage imageNamed:@"blue_quan"];
        [self.contentView addSubview:self.flagimg];
        
        self.hengline=[[UIView alloc]initWithFrame:CGRectMake(100, 30, width-100, 1)];
        self.hengline.backgroundColor=LINECOLOR;
        [self.contentView addSubview:self.hengline];
        
        self.upline=[[UIView alloc]initWithFrame:CGRectMake(24, 0, 2, 23)];
        self.upline.backgroundColor=DaohangCOLOR;
        [self.contentView addSubview:self.upline];
        
        self.downline=[[UIView alloc]initWithFrame:CGRectMake(24, 37, 2, 133)];
        self.downline.backgroundColor=DaohangCOLOR;
        [self.contentView addSubview:self.downline];
        
        
        
    }
    return self;
}
- (void)adddic:(NSDictionary *)dic withtype:(NSString *)type
{
    NSString *datestr=[NSString stringWithFormat:@"%@",dic[@"log_time"]];
    NSString *str=[NSString stringWithFormat:@"%@",dic[@"pic"]];
    [self.Iconimg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"base_empty"] options:SDWebImageAllowInvalidSSLCertificates];
    if ([type isEqualToString:@"2"]) {
        _btn.hidden=NO;
        _btn1.hidden=YES;
    }else{
        _btn.hidden=YES;
        _btn1.hidden=NO;
    }
    NSString *string=[NSString stringWithFormat:@"%@",dic[@"type"]];
    NSString *namestr=[NSString stringWithFormat:@"%@",dic[@"user_name"]];
    NSString *doorstr=[NSString stringWithFormat:@"%@",dic[@"name"]];
    NSString *user_type=[NSString stringWithFormat:@"%@",dic[@"user_type"]];
    switch ([user_type intValue]) {
        case 0:
            _owner=@"业主";
            break;
        case 1:
            _owner=@"家人";
            break;
        case 2:
            _owner=@"租客";
            break;
        case 3:
            _owner=@"临时客人";
            break;
        default:
            break;
    }
    switch ([string intValue]) {
        case 1:
            self.TypeLab.text=[NSString stringWithFormat:@"%@(%@)使用IC卡开启了%@",namestr,_owner,doorstr];
            break;
        case 2:
            self.TypeLab.text=[NSString stringWithFormat:@"%@(%@)使用APP开启了%@",namestr,_owner,doorstr];
            break;
        case 3:
            self.TypeLab.text=[NSString stringWithFormat:@"%@(%@)被呼叫接通后开%@",namestr,_owner,doorstr];
            break;
        case 4:
            self.TypeLab.text=[NSString stringWithFormat:@"%@(%@)使用临时密码开启了%@",namestr,_owner,doorstr];
            break;
        case 5:
            self.TypeLab.text=[NSString stringWithFormat:@"%@(%@)主动查看门禁视频开启了%@",namestr,_owner,doorstr];
            break;
        case 6:
            self.TypeLab.text=[NSString stringWithFormat:@"%@(%@)被呼叫未接通时开%@",namestr,_owner,doorstr];
            break;
        case 7:
            self.TypeLab.text=[NSString stringWithFormat:@"%@(%@)没开%@",namestr,_owner,doorstr];
            break;
            
        default:
            break;
    }
    
    
    self.TimeLab.text=[NSString stringWithFormat:@"%@",[datestr substringFromIndex:11]];
    self.AddressLab.text=[NSString stringWithFormat:@"%@",dic[@"nowaddress"]];
    //[datestr substringFromIndex:11]字符串从第n 位开端截取，
    //[a substringToIndex:4]; 字符串截取到第n位
    
}
/*
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
