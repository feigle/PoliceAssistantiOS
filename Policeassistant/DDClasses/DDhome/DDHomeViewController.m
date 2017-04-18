//
//  DDHomeViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/28.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDHomeViewController.h"
#import "DDSettingViewController.h"
#import "DDHomeTableViewCell.h"
#import "RollLabel.h"
#import "DDNewAddViewController.h"
#import "DDTaskassignmentViewController.h"
#import "DDInfomationViewController.h"
#import "AppDelegate.h"
#import "DDLeftSliderManger.h"

@interface DDHomeViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    UIView *headview;
    UIView *footview, *labaview;
    RollLabel *_rollLabel;
    NSString *urlStr,*_rollstring;
    NSMutableArray *DataArray,*_dataArray;
    UILabel *mangLab,*owerLab,*tencentLab,*contorLab,*dangerLab;
    
}

@property (nonatomic,copy) NSArray * firstSection;//第一段数据
@property (nonatomic,copy) NSArray * secendSection;//第二段数据
@property (nonatomic , retain) UITableView *tableView;

@end

@implementation DDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"警务助手";
    self.view.backgroundColor=RGB(10, 9, 25);
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/transferrecord")];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getNetWorkData];
    UIBarButtonItem *leftbtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right_btn_change"] style:UIBarButtonItemStylePlain target:self action:@selector(jumptoLeftViewControl)];
    self.navigationItem.leftBarButtonItem =leftbtn ;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=54;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    [self.view addSubview:self.tableView];
    //第一段数据
    self.firstSection = @[
                          @{@"image":@"add_check_people_icon.png",@"type":@"新增入住人数",@"people":@"20"},
                          @{@"image":@"add_remove_people_icon.png",@"type":@"新搬走人数",@"people":@"10"},
                          @{@"image":@"add_high_ risk_people_icon.png",@"type":@"新增高危人数",@"people":@"2"}
                          ];
    self.secendSection = @[
                           @{@"mangertype":@"管理社区(个)",@"people":@"12"},
                           @{@"mangertype":@"业主人数(人)",@"people":@"30000"},
                           @{@"mangertype":@"租客人数(人)",@"people":@"12000"},
                           @{@"mangertype":@"布控房数(个)",@"people":@"10"},
                           @{@"mangertype":@"高危人数(个)",@"people":@"10"}
                           ];
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 185+KScreenWidth/2.5)];
    headview.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView=headview;
    [self creatTableheadview];
    [self uploadAndDownload];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPushMessage:) name:@"pushNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isRefresh:) name:@"isRefreshNotification" object:nil];
}

- (void)getPushMessage:(NSNotification *)notification
{
    //第三,实现通知中心内部的方法,并实现传值
    NSString * text = notification.object;
    _rollstring = text;
    
    //文字的滚动效果
    _rollLabel = [[RollLabel alloc] initWithFrame:CGRectMake(40, 11, KScreenWidth-55, 17) text:[DDUserDefault getPushMessage] font:[UIFont systemFontOfSize:17] textColor:UIColorFromRGB(0x222222)];
    [self.tableView reloadData];
    [labaview addSubview:_rollLabel];
    _rollLabel.backgroundColor = TableViewBg;
    [_rollLabel startRoll];
}
- (void)isRefresh:(NSNotification *)notification{
    NSString * text = notification.object;
    if ([DDUserDefault getJob]){
        if ([text isEqualToString:@"1"]) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
    NSLog(@",并实现传值%@",text);
}
- (void)viewWillAppear:(BOOL)animated{
    [_rollLabel startRoll];
    [self.tableView reloadData];
    self.tableView.userInteractionEnabled=YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_rollLabel pauseRoll];
   // [SVProgressHUD dismiss];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cell";
    DDHomeTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[DDHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary * dict = self.firstSection[indexPath.row];
    cell.Iconimg.image=[UIImage imageNamed:dict[@"image"]];
    cell.TypeLab.text=[NSString stringWithFormat:@"%@",dict[@"type"]];
    
    if (indexPath.row==0) {
       cell.PeopleLab.text=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_in"]];
    }else if (indexPath.row==1){
        cell.PeopleLab.text=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_out"]];
    }else if (indexPath.row==2){
        cell.PeopleLab.text=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_danger"]];
    }
    
    return cell;
}

- (void)creatTableheadview{
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(-1, 0, KScreenWidth+1, KScreenWidth/2.5)];
    img.image=[UIImage imageNamed:@"main_home_banner"];
    [headview addSubview:img];
    img.backgroundColor=[UIColor clearColor];
    img.contentMode = UIViewContentModeScaleToFill;
    
    labaview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame), KScreenWidth, 40)];
    labaview.backgroundColor=TableViewBg;
    [headview addSubview:labaview];
    UIImageView *labaimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    labaimg.image=[UIImage imageNamed:@"home_broadcast_icon"];
    [labaview addSubview:labaimg];
    
    if (![DDUserDefault getPushMessage]) {
        _rollLabel = [[RollLabel alloc] initWithFrame:CGRectMake(40, 11, KScreenWidth-55, 17) text:@"消息通知" font:[UIFont systemFontOfSize:17] textColor:UIColorFromRGB(0x222222)];
    }else{
    _rollLabel = [[RollLabel alloc] initWithFrame:CGRectMake(40, 11, KScreenWidth-55, 17) text:[DDUserDefault getPushMessage] font:[UIFont systemFontOfSize:17] textColor:UIColorFromRGB(0x222222)];
    }
    [labaview addSubview:_rollLabel];
    _rollLabel.backgroundColor = TableViewBg;

    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushtoInfomation)];
    [labaview addGestureRecognizer:tap];
    
    UIView *mangerview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(labaview.frame), KScreenWidth, 145)];
    [headview addSubview:mangerview];
    
    UILabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:TEXCOLOR myfram:CGRectMake(15, 10, KScreenWidth/3-15, 20) mytext:@"管理社区(个)"];
    [mangerview addSubview:lab1];
    
    UILabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:TEXCOLOR myfram:CGRectMake(15+KScreenWidth/3, 10, KScreenWidth/3-15, 20) mytext:@"业主人数(人)"];
    [mangerview addSubview:lab2];
    
    UILabel *lab3=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:TEXCOLOR myfram:CGRectMake(15+KScreenWidth*2/3, 10, KScreenWidth/3-15, 20) mytext:@"租客人数(人)"];
    [mangerview addSubview:lab3];
    
    UILabel *lab4=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:TEXCOLOR myfram:CGRectMake(15, 79, KScreenWidth/3-15, 20) mytext:@"布控房数(个)"];
    [mangerview addSubview:lab4];
    
    UILabel *lab5=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:TEXCOLOR myfram:CGRectMake(15+KScreenWidth/3, 79, KScreenWidth/3-15, 20) mytext:@"高危人数(个)"];
    [mangerview addSubview:lab5];
    
    
    
    mangLab=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:MAINTEX myfram:CGRectMake(15, CGRectGetMaxY(lab1.frame)+5, KScreenWidth/3-15, 20) mytext:[NSString stringWithFormat:@"%@",[DataArray firstObject][@"communityCount"]]];
    [mangerview addSubview:mangLab];
    
    owerLab=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:MAINTEX myfram:CGRectMake(15+KScreenWidth/3, CGRectGetMaxY(lab1.frame)+5, KScreenWidth/3-15, 20) mytext:[NSString stringWithFormat:@"%@",[DataArray firstObject][@"ownerCount"]]];
    [mangerview addSubview:owerLab];
    
    tencentLab=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:MAINTEX myfram:CGRectMake(15+KScreenWidth*2/3, CGRectGetMaxY(lab1.frame)+5, KScreenWidth/3-15, 20) mytext:[NSString stringWithFormat:@"%@",[DataArray firstObject][@"tenant"]]];
    [mangerview addSubview:tencentLab];
    
    contorLab=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:MAINTEX myfram:CGRectMake(15, CGRectGetMaxY(lab4.frame)+5, KScreenWidth/3-15, 20) mytext:@"--"];
    [mangerview addSubview:contorLab];
    
    dangerLab=[[DDLabel alloc]initWithAlertViewHeight:15 mycolor:MAINTEX myfram:CGRectMake(15+KScreenWidth/3, CGRectGetMaxY(lab5.frame)+5, KScreenWidth/3-15, 20) mytext:[NSString stringWithFormat:@"%@",[DataArray firstObject][@"noticeCount"]]];
    [mangerview addSubview:dangerLab];
    
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 137.5, KScreenWidth, 7.5)];
    lineview.backgroundColor=TableViewBg;
    [mangerview addSubview:lineview];
    
    UIView *lineview1=[[UIView alloc]initWithFrame:CGRectMake(0, 69, KScreenWidth, 1)];
    lineview1.backgroundColor=LINECOLOR;
    [mangerview addSubview:lineview1];
    
    UIView *lineview3=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/3, 9, 1, 50)];
    lineview3.backgroundColor=LINECOLOR;
    [mangerview addSubview:lineview3];
    
    UIView *lineview2=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth*2/3, 9, 1, 50)];
    lineview2.backgroundColor=LINECOLOR;
    [mangerview addSubview:lineview2];
    
    UIView *lineview4=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/3, 79, 1, 50)];
    lineview4.backgroundColor=LINECOLOR;
    [mangerview addSubview:lineview4];
    
    UIView *lineview5=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth*2/3, 79, 1, 50)];
    lineview5.backgroundColor=LINECOLOR;
    [mangerview addSubview:lineview5];
    }

- (void)jumptoLeftViewControl{
    
    if ([DDLeftSliderManger sharedInstance].LeftSlideVC.closed)
    {
        [[DDLeftSliderManger sharedInstance].LeftSlideVC openLeftView];
    }
    else
    {
        [[DDLeftSliderManger sharedInstance].LeftSlideVC closeLeftView];
    }
}
- (void)pushtoInfomation{
    NSString *str1=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_in"]];
    NSString *str2=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_out"]];
    NSString *str3=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_danger"]];
    NSString *str4=[NSString stringWithFormat:@"0"];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:str1,@"push_message_in",str2,@"push_message_out",str3,@"push_message_danger",str4,@"push_notice_count", nil];
    self.appDelegate.push_notice_count=0;
    NSString *str5=[NSString stringWithFormat:@"%d",self.appDelegate.push_flish_count];
    NSString *str6=[NSString stringWithFormat:@"%d",self.appDelegate.push_accept_count];
    NSArray *testArray = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,str6, nil];
    NSNumber *sum = [testArray valueForKeyPath:@"@sum.floatValue"];
    [DDTools SendUnreadMessageCount:sum];
    [DDUserDefault setPushInforMation:dict];
    DDInfomationViewController*vc=[[DDInfomationViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        DDNewAddViewController*vc=[[DDNewAddViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type=[NSString stringWithFormat:@"1"];
        vc.navigationItem.title=@"新增入住人数";
        NSString *str1=[NSString stringWithFormat:@"0"];
        NSString *str2=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_danger"]];
        NSString *str3=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_out"]];
        NSString *str4=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_notice_count"]];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:str1,@"push_message_in",str2,@"push_message_danger",str3,@"push_message_out",str4,@"push_notice_count", nil];
        self.appDelegate.push_message_in=0;
        NSString *str5=[NSString stringWithFormat:@"%d",self.appDelegate.push_flish_count];
        NSString *str6=[NSString stringWithFormat:@"%d",self.appDelegate.push_accept_count];
        NSArray *testArray = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,str6, nil];
        NSNumber *sum = [testArray valueForKeyPath:@"@sum.floatValue"];
        [DDTools SendUnreadMessageCount:sum];
        [DDUserDefault setPushInforMation:dict];
        [self.navigationController pushViewController:vc animated:YES];
    }if (indexPath.row==1) {
        DDNewAddViewController*vc=[[DDNewAddViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type=[NSString stringWithFormat:@"0"];
        vc.navigationItem.title=@"新搬走人数";
        NSString *str1=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_in"]];
        NSString *str2=[NSString stringWithFormat:@"0"];
        NSString *str3=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_danger"]];
        NSString *str4=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_notice_count"]];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:str1,@"push_message_in",str2,@"push_message_out",str3,@"push_message_danger",str4,@"push_notice_count", nil];
        self.appDelegate.push_message_out=0;
        NSString *str5=[NSString stringWithFormat:@"%d",self.appDelegate.push_flish_count];
        NSString *str6=[NSString stringWithFormat:@"%d",self.appDelegate.push_accept_count];
        NSArray *testArray = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,str6, nil];
        NSNumber *sum = [testArray valueForKeyPath:@"@sum.floatValue"];
        [DDTools SendUnreadMessageCount:sum];
        [DDUserDefault setPushInforMation:dict];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==2) {
        DDNewAddViewController*vc=[[DDNewAddViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type=[NSString stringWithFormat:@"2"];
        vc.navigationItem.title=@"新增高危人数";
        NSString *str1=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_in"]];
        NSString *str2=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_out"]];
        NSString *str3=[NSString stringWithFormat:@"0"];
        NSString *str4=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_notice_count"]];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:str1,@"push_message_in",str2,@"push_message_out",str3,@"push_message_danger",str4,@"push_notice_count", nil];
        self.appDelegate.push_message_danger=0;
        NSString *str5=[NSString stringWithFormat:@"%d",self.appDelegate.push_flish_count];
        NSString *str6=[NSString stringWithFormat:@"%d",self.appDelegate.push_accept_count];
        NSArray *testArray = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,str6, nil];
        NSNumber *sum = [testArray valueForKeyPath:@"@sum.floatValue"];
        [DDTools SendUnreadMessageCount:sum];
        [DDUserDefault setPushInforMation:dict];
        
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}
- (void)uploadAndDownload{
    // 下拉刷新
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_tableView.mj_header endRefreshing];
            NSLog(@"22222222222");
        });
        
        [self getNetWorkData];
    }];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [_tableView.mj_footer endRefreshing];
//            NSLog(@"上4444444444");
//        });
//        NSLog(@"上33333333333333");
//    }];
    
}
- (void)getNetWorkData{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"currentid",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:urlStr withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                [SVProgressHUD dismiss];
                DataArray=dic[@"data"];
                BOOL result = [DDNetCache saveJsonResponseToCacheFile:DataArray andURL:urlStr];
                if(result) NSLog(@"(同步)写入/更新缓存数据 成功");
                mangLab.text=[NSString stringWithFormat:@"%@",[DataArray firstObject][@"communityCount"]];
                owerLab.text=[NSString stringWithFormat:@"%@",[DataArray firstObject][@"ownerCount"]];
                tencentLab.text=[NSString stringWithFormat:@"%@",[DataArray firstObject][@"tenant"]];
                dangerLab.text=[NSString stringWithFormat:@"%@",[DataArray firstObject][@"noticeCount"]];
                [self.tableView reloadData];
            }
            else if ([Error_Code_Failed isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }else if ([Error_Code_RequestError isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }
            
        }else{
            
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){
//        [SVProgressHUD dismiss];
//        [DDProgressHUD showCenterWithText:@"网络异常" duration:1.0];
    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];

}
#pragma mark  － app代理
-(AppDelegate*)appDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

@end
