//
//  DDTaskDetailViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/1.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDTaskDetailViewController.h"
#import "DDTaskDetailCell.h"
#import "DDTaskOrderVC.h"

@interface DDTaskDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    CGFloat h;
    NSString *rightitle,*mission_type,*taskid,*request_time;
    int rightag;
}
@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic, strong) UIView  *headView;
@property (nonatomic, strong) UIView  *footView;
@property (nonatomic,strong)NSDictionary *datadic;
@end

@implementation DDTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"任务详情";
    
    NSString *missionstatus=[NSString stringWithFormat:@"%@",_datadic[@"missionstatus"]] ;
    switch ([missionstatus intValue]) {
        case 1:
            rightitle=@"删除";
            rightag=1001;
            break;
        case 2:
            rightitle=@"";
            rightag=1002;
            break;
        case 3:
            rightitle=@"";
            rightag=1003;
            break;
        default:
            break;
    }
    UIBarButtonItem *rightbtn=[[UIBarButtonItem alloc]initWithTitle:rightitle style:UIBarButtonItemStylePlain target:self action:@selector(deletaorder)];
    self.navigationItem.rightBarButtonItem =rightbtn ;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=50;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 145)];
    _headView.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=_headView;
    
    [self creatTableViewheadview];
    _footView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-89, self.view.frame.size.width, h)];
    _footView.backgroundColor=[UIColor whiteColor];
    
    [self creatTableViewfootview];
    
}

- (void)creatTableViewheadview{
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 15)];
    view1.backgroundColor=TableViewBg;
    [_headView addSubview:view1];
    
    DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(15, CGRectGetMaxY(view1.frame), 85, 48) mytext:@"任务编号："];
    [_headView addSubview:lab1];
    
    DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:DaohangCOLOR myfram:CGRectMake(90, CGRectGetMaxY(view1.frame), KScreenWidth-135, 48) mytext:[NSString stringWithFormat:@"%@",_datadic[@"missionid"]]];
    [_headView addSubview:lab2];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab2.frame), KScreenWidth, 1)];
    view2.backgroundColor=LINECOLOR;
    [_headView addSubview:view2];
    
    DDLabel *lab11=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(view2.frame), 85, 40) mytext:@"类       型："];
    [_headView addSubview:lab11];
    
    
    NSString *missiontype=[NSString stringWithFormat:@"%@",_datadic[@"missiontype"]];
    switch ([missiontype intValue]) {
        case 1:
            mission_type=[NSString stringWithFormat:@"其他"];
            break;
        case 2:
            mission_type=[NSString stringWithFormat:@"上门走访"];
            break;
        case 3:
            mission_type=[NSString stringWithFormat:@"人员信息登记"];
            break;
        default:
            break;
    }
    DDLabel *lab22=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, CGRectGetMaxY(view2.frame), KScreenWidth/2-60, 40) mytext:mission_type];
    [_headView addSubview:lab22];
    
    DDLabel *lab13=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(lab11.frame), 85, 40) mytext:@"要求时间："];
    [_headView addSubview:lab13];
    
    NSString *timeStr=[NSString stringWithFormat:@"%@",_datadic[@"time"]];
    NSString *deadline=[NSString stringWithFormat:@"%@",_datadic[@"deadline"]];
    switch ([deadline intValue]) {
        case 1:
            request_time=[[NSString stringWithFormat:@"%@",[DDTools datejishuangYear:0 Month:0 Day:0 withData:timeStr]] substringToIndex:10];
            break;
        case 2:
            request_time=[[NSString stringWithFormat:@"%@",[DDTools datejishuangYear:0 Month:0 Day:1 withData:timeStr]] substringToIndex:10];
            break;
        case 3:
            request_time=[[NSString stringWithFormat:@"%@",[DDTools datejishuangYear:0 Month:0 Day:6 withData:timeStr]] substringToIndex:10];
            break;
        default:
            break;
    }
    DDLabel *lab23=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:UIColorFromRGB(0xF2001E) myfram:CGRectMake(90, CGRectGetMaxY(lab11.frame), KScreenWidth-135, 40) mytext:request_time];
    [_headView addSubview:lab23];
    
    DDLabel *lab34=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(KScreenWidth/2+30, CGRectGetMaxY(view2.frame), 85, 40) mytext:@"状       态："];
    [_headView addSubview:lab34];
    
    
    DDLabel *lab24=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:UIColorFromRGB(0xFF9900) myfram:CGRectMake(KScreenWidth/2+100, CGRectGetMaxY(view2.frame), KScreenWidth-135, 40) mytext:@"待处理"];
    NSString *missionstatus=[NSString stringWithFormat:@"%@",_datadic[@"missionstatus"]];
    switch ([missionstatus intValue]) {
        case 1:
            lab24.text=[NSString stringWithFormat:@"待处理"];
            lab24.textColor=RGB(255, 150, 0);
            break;
        case 2:
            lab24.text=[NSString stringWithFormat:@"处理中"];
            lab24.textColor=DaohangCOLOR;
            break;
        case 3:
            lab24.text=[NSString stringWithFormat:@"已完成"];
            lab24.textColor=TEXCOLOR;
            break;
        default:
            break;
    }

    [_headView addSubview:lab24];
    
    UIView *view22=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab13.frame), KScreenWidth, 1)];
    view22.backgroundColor=LINECOLOR;
    [_headView addSubview:view22];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-69, 27, 54, 24)];
    NSString *missionlv=[NSString stringWithFormat:@"%@",_datadic[@"missionlv"]];
    switch ([missionlv intValue]) {
        case 1:
            [btn setTitle:@"一般" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            break;
        case 2:
            [btn setTitle:@"紧急" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"first_police"] forState:UIControlStateNormal];
            break;
            default:
            break;
    }
    btn.titleLabel.font=sysFont15;
    [_headView addSubview:btn];
}
- (void)creatTableViewfootview{
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 7.5)];
    view1.backgroundColor=TableViewBg;
    [_footView addSubview:view1];
    
    DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(view1.frame), 85, 40) mytext:@"处理人员："];
    [_footView addSubview:lab1];
    
    DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, CGRectGetMaxY(view1.frame), KScreenWidth-135, 40) mytext:[NSString stringWithFormat:@"%@",_datadic[@"real_name"]]];
    [_footView addSubview:lab2];
    
    
    DDLabel *lab11=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(lab2.frame), 85, 40) mytext:@"地       址："];
    [_footView addSubview:lab11];
    
    DDLabel *lab22=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, CGRectGetMaxY(lab2.frame), KScreenWidth-105, 40) mytext:[NSString stringWithFormat:@"%@",_datadic[@"address"]]];
    lab22.numberOfLines=0;
    
    [_footView addSubview:lab22];
    
    DDLabel *lab13=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(15, CGRectGetMaxY(lab11.frame), 85, 40) mytext:@"内       容："];
    [_footView addSubview:lab13];
    
    DDLabel *lab23=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(90, CGRectGetMaxY(lab11.frame), KScreenWidth-105, 40) mytext:[NSString stringWithFormat:@"%@",_datadic[@"content"]]];
    lab23.numberOfLines=0;
    CGSize maximumLabelSize = CGSizeMake(KScreenWidth-105, 9999);//labelsize的最大值
    CGSize expectSize = [lab23 sizeThatFits:maximumLabelSize];
    lab23.frame = CGRectMake(90, CGRectGetMaxY(lab11.frame)+11, expectSize.width, expectSize.height);
    [_footView addSubview:lab23];
    
    if (rightag==1001) {
        
        UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab23.frame)+30, KScreenWidth, 131)];
        view2.backgroundColor=TableViewBg;
        [_footView addSubview:view2];
        
        DDButton *button=[[DDButton alloc]initWithFrame:CGRectMake(15, 30,  KScreenWidth-30, 50) withTitle:@"编辑" touchBlock:^(DDButton *btn){
            [self checkIsSuccess];
        }];
        [view2 addSubview:button];
        h=lab23.frame.size.height+130+130;
    }else if (rightag==1002){
        h=lab23.frame.size.height+130;
    }else if (rightag==1003){
        UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab23.frame)+15, KScreenWidth, 7.5)];
        view3.backgroundColor=TableViewBg;
        
        DDLabel *lab111=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:RGB(255, 150, 0) myfram:CGRectMake(15, CGRectGetMaxY(view3.frame)+15, 185, 20) mytext:@"处理人员回复："];
        [_footView addSubview:lab111];
        
        DDLabel *lab112=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(85, CGRectGetMaxY(lab111.frame)+15, KScreenWidth-200, 20) mytext:[NSString stringWithFormat:@"%@",_datadic[@"real_name"]]];
        [_footView addSubview:lab112];
        
        DDLabel *lab113=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(KScreenWidth-115, CGRectGetMaxY(lab111.frame)+15, 100, 20) mytext:@""];
        lab113.textAlignment=NSTextAlignmentRight;
        [_footView addSubview:lab113];
        
        NSString *flishtime=[NSString stringWithFormat:@"%@",_datadic[@"finishtime"]];
        if ([flishtime isEqualToString:@"<null>"]) {
            lab113.text=[NSString stringWithFormat:@""];
        }else{
            lab113.text=[flishtime substringWithRange:NSMakeRange(5,11)];
        }
        
        DDLabel *lab114=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:MAINTEX myfram:CGRectMake(85, CGRectGetMaxY(lab113.frame)+7.5, KScreenWidth-100, 60) mytext:[NSString stringWithFormat:@"%@",_datadic[@"finishreason"]]];
        lab114.numberOfLines=0;
        CGSize maximumLabelSize = CGSizeMake(KScreenWidth-105, 9999);//labelsize的最大值
        CGSize expectSize = [lab114 sizeThatFits:maximumLabelSize];
        lab114.frame = CGRectMake(90, CGRectGetMaxY(lab113.frame)+11, expectSize.width, expectSize.height);
        [_footView addSubview:lab114];
        
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lab111.frame)+7.5, 45, 45)];
        imageview.image=[UIImage imageNamed:@"main_icon@3x"];
        [_footView addSubview:imageview];
        [_footView addSubview:view3];
        h=lab114.frame.size.height+220+lab23.frame.size.height;
    }else{
        
    }

    _footView.frame=CGRectMake(0, 0, KScreenWidth, h);
    _tableView.tableFooterView=_footView;
}
- (void)checkIsSuccess{
    DDTaskOrderVC*vc=[[DDTaskOrderVC alloc]init];
    vc.flag=@"1";
    vc.changDic=_datadic;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)deletaorder{
    switch (rightag) {
        case 1001:
            [self deletewithID];
            break;
        case 1002:
            NSLog(@"撤回");
            break;
        case 1003:
            NSLog(@"完成");
            break;
        default:
            break;
    }
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"删除任务" message:@"您是否确定删除任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
}
- (void)deletewithID{
    [DDAlertView initWithTitle:@"提示" message:@"确定删除该任务？" cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonAtIndex) {
        NSLog(@"click index ====%ld",(long)buttonAtIndex);
        if (buttonAtIndex == 1) {
            taskid=[NSString stringWithFormat:@"%@",_datadic[@"missionid"]];
            [self getNetWorkData:taskid];
            NSLog(@"删除");
        }
    }];
}
#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cell";
    DDTaskDetailCell*cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[DDTaskDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    if (indexPath.row==0) {
        cell.upLine.hidden=YES;
        cell.TypeLab.text=@"下发时间：";
        cell.TimeLab.text=[[NSString stringWithFormat:@"%@",_datadic[@"time"]] substringToIndex:16];
    }if (indexPath.row==1) {
        cell.TypeLab.text=@"受理时间：";
        cell.TimeLab.text=[NSString stringWithFormat:@"%@",_datadic[@"committime"]];
        if ([cell.TimeLab.text isEqualToString:@"<null>"]) {
            [cell.Touchimg setImage:[UIImage imageNamed:@"state_normal@3x"]];
            cell.TimeLab.text=[NSString stringWithFormat:@""];
        }else{
            cell.TimeLab.text=[[NSString stringWithFormat:@"%@",_datadic[@"committime"]] substringToIndex:16];
        }
    }
    if (indexPath.row==2) {
        cell.TypeLab.text=@"完成时间：";
        cell.downLine.hidden=YES;
        cell.TimeLab.text=[NSString stringWithFormat:@"%@",_datadic[@"finishtime"]];
        if ([cell.TimeLab.text isEqualToString:@"<null>"]) {
            [cell.Touchimg setImage:[UIImage imageNamed:@"state_normal@3x"]];
            cell.TimeLab.text=[NSString stringWithFormat:@""];
        }else{
            cell.TimeLab.text=[[NSString stringWithFormat:@"%@",_datadic[@"finishtime"]] substringToIndex:16];
        }
    }
    return cell;
}
/**
 *  删除任务
 */
- (void)getNetWorkData :(NSString *)task_id{
    [SVProgressHUD showWithStatus:@"正在删除..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:task_id,@"taskid",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:API_BASE_URL(@"v1/site/delmission") withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"success"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            NSNumber *msgCode1 =[dic objectForKey:@"error_code"];
            NSString *msg1=[NSString stringWithFormat:@"%@",msgCode1];
            
            if ([@"1" isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"删除成功" duration:1.0];
                [self.navigationController popViewControllerAnimated:YES];
                self.ButtonClick(@"1");
            }else if ([@"0" isEqualToString:msg]){
                if ([@"20009" isEqualToString:msg1]){
                    [DDProgressHUD showCenterWithText:@"该任务已被受理" duration:2.0];
                }
            }
            
            
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){

    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];
    
}



@end
