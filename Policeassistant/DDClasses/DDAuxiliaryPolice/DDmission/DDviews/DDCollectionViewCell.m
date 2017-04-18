//
//  DDCollectionViewCell.m
//  Policeassistant
//
//  Created by DoorDu on 16/8/8.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDCollectionViewCell.h"

@implementation DDCollectionViewCell
{
    UIView *headView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatCellView];
    }
    return self;
}
- (void)creatCellView{
    CGFloat w = KScreenWidth*2/3;
    CGFloat h =KScreenHeight*3/5;
    self.misslevbg = [[UIImageView alloc]init];
    self.misslevbg.frame = CGRectMake(w-50, 0, 50, 50);
    self.misslevbg.image = [UIImage imageNamed:@"Rectangle 227@3x"];
    [self addSubview:self.misslevbg];
    
    self.missidLab=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(15, 15, KScreenWidth-75, 20) mytext:@"任务编号："];
    [self addSubview:self.missidLab];
    
    self.clockbg=[[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_missidLab.frame)+8, 20, 20)];
    self.clockbg.image=[UIImage imageNamed:@"clock_height"];
    [self addSubview:self.clockbg];
    
    self.timeLab=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:TEXCOLOR myfram:CGRectMake(40, CGRectGetMaxY(_missidLab.frame)+8, KScreenWidth*0.8-90, 20) mytext:@""];
    [self addSubview:self.timeLab];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 72, KScreenWidth*0.8, 1)];
    line1.backgroundColor=LINECOLOR;
    [self addSubview:line1];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, h-91, KScreenWidth*0.8, 1)];
    line2.backgroundColor=LINECOLOR;
    [self addSubview:line2];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 73, KScreenWidth*0.8, h-164) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
    headView.backgroundColor=[UIColor whiteColor];
    tableView.tableHeaderView=headView;
    DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, 15, 100, 20) mytext:@"任务类型："];
    [headView addSubview:lab2];
    
    _typeLab=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, 15, KScreenWidth*0.8-90, 20) mytext:@""];
    [headView addSubview:_typeLab];
    
    DDLabel *lab21=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(lab2.frame)+7.5, 100, 20) mytext:@"完成时间："];
    [headView addSubview:lab21];
    _FilishLab=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:RGB(229, 33, 18) myfram:CGRectMake(90, CGRectGetMaxY(lab2.frame)+7.5, KScreenWidth*0.8-90, 20) mytext:@""];
    [headView addSubview:_FilishLab];
    
    DDLabel *lab22=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(lab21.frame)+7.5, 100, 40) mytext:@"地       址："];
    [headView addSubview:lab22];
    _addressLab=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, CGRectGetMaxY(lab21.frame)+7.5, KScreenWidth*2/3-105, 40) mytext:@""];
    _addressLab.numberOfLines=0;
    [headView addSubview:_addressLab];
    
    DDLabel *lab23=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(lab22.frame)+7.5, 100, 20) mytext:@"内       容："];
    [headView addSubview:lab23];
    
    _contentLab=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(15, CGRectGetMaxY(lab23.frame)+7.5, KScreenWidth*2/3-30, 60) mytext:@""];
    _contentLab.numberOfLines=0;
    [headView addSubview:_contentLab];
    
    _startLab=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:RGB(229, 33, 18) myfram:CGRectMake(15, CGRectGetMaxY(line2.frame), KScreenWidth*2/3-130, 71) mytext:@"已开始:5小时40分"];
    [self addSubview:_startLab];
    _startLab.numberOfLines=0;
    _startLab.hidden=YES;
    
    _acceptBtn=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth*2/15, CGRectGetMaxY(line2.frame)+15, KScreenWidth*0.4, 41)];
    [_acceptBtn setTitle:@"受理" forState:UIControlStateNormal];
    [_acceptBtn setBackgroundColor:DaohangCOLOR];
    _acceptBtn.layer.masksToBounds = YES;
    _acceptBtn.titleLabel.font=sysFont18;
    _acceptBtn.layer.cornerRadius = 5;
    [self addSubview:_acceptBtn];
    _acceptBtn.hidden=YES;
    
    _flishBtn=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth*2/3-95, CGRectGetMaxY(line2.frame)+15, 80, 41)];
    [_flishBtn setTitle:@"完成" forState:UIControlStateNormal];
    _flishBtn.layer.masksToBounds = YES;
    _flishBtn.titleLabel.font=sysFont18;
    _flishBtn.layer.cornerRadius = 5;
    _flishBtn.layer.borderWidth = 1;
    _flishBtn.layer.borderColor = [DaohangCOLOR CGColor];
    [_flishBtn setTitleColor:DaohangCOLOR forState:0];
    [self addSubview:_flishBtn];
    _flishBtn.hidden=YES;

}
#pragma mark- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GYPopOverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    cell.textLabel.text = @"123";
    cell.detailTextLabel.text=@"人员登记";
    
    return cell;
}
- (void)adddic:(NSDictionary *)dic{
    self.missidLab.text=[NSString stringWithFormat:@"任务编号：%@",dic[@"missionid"]];
    self.timeLab.text=[NSString stringWithFormat:@"%@",dic[@"time"]];
    NSString *missiontype=[NSString stringWithFormat:@"%@",dic[@"missiontype"]];
    switch ([missiontype intValue]) {
        case 1:
            _typeLab.text=[NSString stringWithFormat:@"其他"];
            break;
        case 2:
            _typeLab.text=[NSString stringWithFormat:@"上门走访"];
            break;
        case 3:
            _typeLab.text=[NSString stringWithFormat:@"人员信息登记"];
            break;
        default:
            break;
    }
    NSString *timeStr=[NSString stringWithFormat:@"%@",dic[@"time"]];
    NSString *deadline=[NSString stringWithFormat:@"%@",dic[@"deadline"]];
    switch ([deadline intValue]) {
        case 1:
            self.FilishLab.text=[[NSString stringWithFormat:@"%@",[DDTools datejishuangYear:0 Month:0 Day:0 withData:timeStr]] substringToIndex:10];
            break;
        case 2:
            self.FilishLab.text=[[NSString stringWithFormat:@"%@",[DDTools datejishuangYear:0 Month:0 Day:1 withData:timeStr]] substringToIndex:10];
            break;
        case 3:
            self.FilishLab.text=[[NSString stringWithFormat:@"%@",[DDTools datejishuangYear:0 Month:0 Day:6 withData:timeStr]] substringToIndex:10];
            break;
        default:
            break;
    }
    
    self.addressLab.text=[NSString stringWithFormat:@"%@",dic[@"address"]];
    self.contentLab.text=[NSString stringWithFormat:@"%@",dic[@"content"]];
    NSString *missionlv=[NSString stringWithFormat:@"%@",dic[@"missionlv"]];
    switch ([missionlv intValue]) {
        case 1:
            self.misslevbg.hidden=YES;
            break;
        case 2:
            self.misslevbg.hidden=NO;
            break;
            default:
            break;
    }
    NSString *bill_timeStr=[NSString stringWithFormat:@"%@",dic[@"committime"]];
    _startLab.text=[NSString stringWithFormat:@"已开始:%@",[DDTools intervalSinceNow:bill_timeStr]];

}
@end
