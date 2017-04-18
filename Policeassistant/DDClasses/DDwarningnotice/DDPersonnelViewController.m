//
//  DDPersonnelViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/28.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDPersonnelViewController.h"
#import "DDPersonnelTableViewCell.h"
#import "DDAccessViewController.h"

@interface DDPersonnelViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *urlStr;
    NSMutableArray *DataArray;
}
@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic,copy) NSArray * firstSection;//第一段数据
@property (nonatomic,copy) NSArray * secendSection;//第二段数据
@property (nonatomic,strong)NSDictionary *datadic;
@end

@implementation DDPersonnelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@%@",API_BASE_URL(@"v1/site/info?cardid="),_cardid];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getNetWorkData];
    self.navigationItem.title=@"人员详情";
    NSLog(@"%@",_datadic);
//    UIBarButtonItem *rightbtn=[[UIBarButtonItem alloc]initWithTitle:@"处理" style:UIBarButtonItemStylePlain target:self action:@selector(jumptodispose)];
//    self.navigationItem.rightBarButtonItem =rightbtn ;
    //第一段数据
    self.firstSection = @[
                          @{@"typename":@"姓名",@"detainame":@"买买提"},
                          @{@"typename":@"性别",@"detainame":@"男"},
                          @{@"typename":@"出生",@"detainame":@"1986年6月5日出生"},
                          @{@"typename":@"证件类型",@"detainame":@"653125198306051496"},
                          @{@"typename":@"证件号码",@"detainame":@"653125198306051496"},
                          @{@"typename":@"户籍住址",@"detainame":@"新疆维吾尔自治区和田地区和田县汗艾日克乡"}
                          ];
    self.secendSection=@[
                         @{@"typename":@"详细住址",@"detainame":@"自然家园-5栋-712室"},
                         @{@"typename":@"入住时间",@"detainame":@"2016年4月15号"}
                         ];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-108) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=54;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    [self.view addSubview:self.tableView];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    [self uploadAndDownload];
    DDButton *loginbtn=[[DDButton alloc]initWithFrame:CGRectMake(0, KScreenHeight-108, KScreenWidth, 44) withTitle:@"出入记录" touchBlock:^(DDButton *btn){
        [self push];
    }];
    loginbtn.layer.cornerRadius=0;
    [self.view addSubview:loginbtn];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 6;
    }else{
        return 2;
    }
    
    
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cell";
    DDPersonnelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[DDPersonnelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSDictionary *dic=[DataArray firstObject];
    if (indexPath.section==0) {
        NSDictionary * dict = self.firstSection[indexPath.row];
        cell.TypeLab.text=[NSString stringWithFormat:@"%@",dict[@"typename"]];
        if (indexPath.row==0) {
            cell.PeopleLab.text=[NSString stringWithFormat:@"%@",_datadic[@"name"]];
        }if (indexPath.row==1) {
            NSString *string=[NSString stringWithFormat:@"%@",_datadic[@"sex"]];
            if ([string isEqualToString:@"1"]) {
                cell.PeopleLab.text=[NSString stringWithFormat:@"男"];
            }else{
                cell.PeopleLab.text=[NSString stringWithFormat:@"女"];
            }
            
        }if (indexPath.row==2) {
            cell.PeopleLab.text=[NSString stringWithFormat:@"%@",_datadic[@"birthday"]];
        }if (indexPath.row==3) {
           
            NSString *string=[NSString stringWithFormat:@"%@",dic[@"card_type"]];
            switch ([string intValue]) {
                case 1:
                    cell.PeopleLab.text=[NSString stringWithFormat:@"身份证"];
                    break;
                case 2:
                    cell.PeopleLab.text=[NSString stringWithFormat:@"护照"];
                    break;
                case 3:
                    cell.PeopleLab.text=[NSString stringWithFormat:@"港澳通行证"];
                    break;
                case 4:
                    cell.PeopleLab.text=[NSString stringWithFormat:@"台胞证"];
                    break;
                default:
                    cell.PeopleLab.text=[NSString stringWithFormat:@"身份证"];
                    break;
            }
            
        }if (indexPath.row==4) {
            cell.PeopleLab.text=[NSString stringWithFormat:@"%@",_datadic[@"cardId"]];
        }if (indexPath.row==5) {
            cell.PeopleLab.text=[NSString stringWithFormat:@"%@",_datadic[@"address"]];
        }
        
    }else if (indexPath.section==1){
        NSDictionary * dict = self.secendSection[indexPath.row];
        cell.TypeLab.text=[NSString stringWithFormat:@"%@",dict[@"typename"]];
        if (indexPath.row==0) {
            cell.PeopleLab.text=[NSString stringWithFormat:@"%@",dic[@"nowAddress"]];
        }
        if (indexPath.row==1) {
            cell.PeopleLab.text=[NSString stringWithFormat:@"%@",dic[@"inTime"]];
        }
    }
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return (KScreenWidth-45)/2+145;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 7.5;
    }else{
        return 0.5;
    }
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView *firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, (KScreenWidth-45)/2+145)];
        UIView *photoview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth, 45)];
        lab1.textColor=[UIColor colorWithRed:153.0/255.0f green:153.0/255.0f blue:153.0/255.0f alpha:1];
        lab1.font=sysFont15;
        lab1.text=@"人员照片";
        [photoview addSubview:lab1];
        [firstView addSubview:photoview];
        
        UIView *addview=[[UIView alloc]initWithFrame:CGRectMake(0, (KScreenWidth-45)/2+100, KScreenWidth, 45)];
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth, 45)];
        lab2.textColor=[UIColor colorWithRed:153.0/255.0f green:153.0/255.0f blue:153.0/255.0f alpha:1];
        lab2.font=sysFont15;
        lab2.text=@"现居地址";
        [addview addSubview:lab2];
        [firstView addSubview:addview];
        
        UIView *Imgview=[[UIView alloc]initWithFrame:CGRectMake(0, 45, KScreenWidth, (KScreenWidth-45)/2+55)];
        Imgview.backgroundColor=[UIColor whiteColor];
        [firstView addSubview:Imgview];
        
        UIImageView *imgview1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, (KScreenWidth-45)/2, (KScreenWidth-45)/2)];
        NSString *string1=[NSString stringWithFormat:@"%@",_datadic[@"pic_1"]];
        [imgview1 sd_setImageWithURL:[NSURL URLWithString:string1] placeholderImage:[UIImage imageNamed:@"Group"] options:SDWebImageAllowInvalidSSLCertificates];
        [Imgview addSubview:imgview1];
        
        UIImageView *imgview2=[[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth-45)/2+30, 15, (KScreenWidth-45)/2, (KScreenWidth-45)/2)];
        NSString *string2=[NSString stringWithFormat:@"%@",_datadic[@"pic_2"]];
        [imgview2 sd_setImageWithURL:[NSURL URLWithString:string2] placeholderImage:[UIImage imageNamed:@"Group"] options:SDWebImageAllowInvalidSSLCertificates];
        [Imgview addSubview:imgview2];
        
        UILabel *typelab1=[[UILabel alloc]initWithFrame:CGRectMake(15, (KScreenWidth-45)/2+15, (KScreenWidth-45)/2, 40)];
        typelab1.text=@"身份证";
        typelab1.font=sysFont16;
        typelab1.textColor=[UIColor colorWithRed:19/255.0f green:19/255.0f blue:19/255.0f alpha:1];
        typelab1.textAlignment=NSTextAlignmentCenter;
        [Imgview addSubview:typelab1];
        
        UILabel *typelab2=[[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth-45)/2+30, (KScreenWidth-45)/2+15, (KScreenWidth-45)/2, 40)];
        typelab2.text=@"入住登记照";
        typelab2.font=sysFont16;
        typelab2.textColor=[UIColor colorWithRed:19/255.0f green:19/255.0f blue:19/255.0f alpha:1];
        typelab2.textAlignment=NSTextAlignmentCenter;
        [Imgview addSubview:typelab2];
        
        
        return firstView;
    }else if (section==1){
        UIView *secendView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0)];
        return secendView;
    }
    else
        return nil;
}
- (void)push{
    NSLog(@"11111");
    DDAccessViewController *vc=[[DDAccessViewController alloc]init];
    vc.cardid=[NSString stringWithFormat:@"%@",_datadic[@"cardId"]];
    vc.Peo_Bulid_Room=@"3";
    vc.mangertype=_typestr;
    if ([_typestr isEqualToString:@"通知"]) {
       vc.roomid=[NSString stringWithFormat:@"%@",_datadic[@"room_number_id"]];
    }else if ([_typestr isEqualToString:@"社区管理"]){
        vc.roomid=[NSString stringWithFormat:@"%@",_roomid];
    }else{
        vc.roomid=[NSString stringWithFormat:@"%@",_datadic[@"room_number_id"]];
    }
    [self.navigationController pushViewController:vc animated:YES];
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
- (void)jumptodispose{
    NSLog(@"去处理");
}
- (void)getNetWorkData{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:_roomid,@"roomid",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:urlStr withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                DataArray=dic[@"data"];
                BOOL result = [DDNetCache saveJsonResponseToCacheFile:DataArray andURL:urlStr];
                if(result) NSLog(@"(同步)写入/更新缓存数据 成功");
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

    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];
    
}

@end
