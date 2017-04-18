//
//  DDTaskassignmentViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDTaskassignmentViewController.h"
#import "DDHeadView.h"
#import "DDTaskassTableViewCell.h"
#import "DDTaskDetailViewController.h"
#import "DDTaskOrderVC.h"
#import "AppDelegate.h"

@interface DDTaskassignmentViewController ()<UITableViewDataSource,UITableViewDelegate,DDHeadViewDelegate>
{
    NSArray *AllArray,*UnaccArray,*DoingArray,*FlishArray;
    NSString *typeStr;
    NSString *unAccStr,*AccStr,*FlishStr,*AllStr;
    BOOL fir,sec,three,four;
}
@property (nonatomic , retain) UITableView *tableView;
@property(nonatomic,strong)DDEmptyView *empview;
@property(nonatomic,strong)NSMutableArray *DataArray;
@property(nonatomic,strong)DDHeadView *segView;
@end

@implementation DDTaskassignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"任务列表";
    typeStr=@"4";
    fir=YES;
    UIBarButtonItem *rightbtn=[[UIBarButtonItem alloc]initWithTitle:@"任务委派" style:UIBarButtonItemStylePlain target:self action:@selector(jumptodispose)];
    self.navigationItem.rightBarButtonItem =rightbtn ;
    [rightbtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
    _segView=[[DDHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    [self.view addSubview:_segView];
    _segView.delegate = self;
    _segView.titles = @[@"全部",@"待处理",@"处理中",@"已完成"];
    _segView.titleFont = sysFont14;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-158) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=177.5;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self uploadAndDownload];
    
 
    _DataArray=[[NSMutableArray alloc]init];
    unAccStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/mission?type=1")];
    UnaccArray=[DDNetCache cacheJsonWithURL:unAccStr];

    

    AccStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/mission?type=2")];
    DoingArray=[DDNetCache cacheJsonWithURL:AccStr];

    
    
    FlishStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/mission?type=3")];
    FlishArray=[DDNetCache cacheJsonWithURL:FlishStr];
    
    AllStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/mission?type=4")];
    AllArray=[DDNetCache cacheJsonWithURL:AllStr];
    [self getNetWorkData];
    _empview=[[DDEmptyView alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPushMessage:) name:@"pushNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLabelText:) name:@"MissonNotification" object:nil];
}
-(void)getPushMessage:(NSNotification *)notification{
    NSString * text =[NSString stringWithFormat:@"%@",notification.object];
    if ([text isEqualToString:@"10"]) {
        [self getNetWorkData];
        [self getFlishNetWorkData];
    }else if ([text isEqualToString:@"11"]){
        [self getNetWorkData];
        [self getDoingNetWorkData];
        
    }else{
       NSLog(@"-------%@",text);
    }
}
-(void)showLabelText:(NSNotification *)notification{
    NSString * text =[NSString stringWithFormat:@"%@",notification.object];
    if ([text isEqualToString:@"123"]) {
        [self getNetWorkData];
        [self getUnAccNetWorkData];
    }else{
        NSLog(@"-------%@",text);
    }  
}
#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_DataArray.count) {
        [_empview showCenterWithSuperView:self.tableView icon:@"empty_fancy" state:@"暂无相关数据"];
        return 0;
    }else{
        [_empview removeFromSuperview];
        return [_DataArray count];
    }
    
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cell";
    DDTaskassTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[DDTaskassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSDictionary *dic=[_DataArray objectAtIndex:indexPath.row];
    [cell adddic:dic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *Dic=[_DataArray objectAtIndex:indexPath.row];
    DDTaskDetailViewController*vc=[[DDTaskDetailViewController alloc]init];
    [vc setValue:Dic forKey:@"datadic"];
    vc.ButtonClick=^void(NSString *str){
        [self getNetWorkData];
        [self getUnAccNetWorkData];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)jumptodispose{
    DDTaskOrderVC*vc=[[DDTaskOrderVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.Successful=^void(NSString *str){
        NSLog(@"---%@-----%@",str,typeStr);
//        [self getNetWorkData];
//        [self getUnAccNetWorkData];
//        [self getDoingNetWorkData];
//        [self getFlishNetWorkData];
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)segmentView:(DDHeadView *)segmentView didSelectIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    switch (index) {
        case 0:
            typeStr=@"4";
            [self GetAllMessageWithType];
            fir=NO;
            [_DataArray removeAllObjects];
            [_DataArray addObjectsFromArray:AllArray];
            [_tableView reloadData];
            break;
        case 1:
            typeStr=@"1";
            [self GetUnacceptMessageWithType];
            sec=NO;
            [_DataArray removeAllObjects];
            [_DataArray addObjectsFromArray:UnaccArray];
            [_tableView reloadData];
            break;
        case 2:
            typeStr=@"2";
            [self GetDoingMessageWithType];
            three=NO;
            [_DataArray removeAllObjects];
            [_DataArray addObjectsFromArray:DoingArray];
            [_tableView reloadData];
            break;
        case 3:
            typeStr=@"3";
            [self GetFlishMessageWithType];
            four=NO;
            [_DataArray removeAllObjects];
            [_DataArray addObjectsFromArray:FlishArray];
            [_tableView reloadData];
            break;
            
        default:
            break;
    }
}
-(void)GetAllMessageWithType{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"11111111");
        [self getNetWorkData];
        
    });
}
-(void)GetUnacceptMessageWithType{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"222222");
        [self getUnAccNetWorkData];
    });
    
}
-(void)GetDoingMessageWithType{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"3333333");
        [self getDoingNetWorkData];
    });
    
}
-(void)GetFlishMessageWithType{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"444444");
        [self getFlishNetWorkData];
    });
    
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
        switch ([typeStr intValue]) {
            case 1:
                [self getUnAccNetWorkData];
                break;
            case 2:
                [self getDoingNetWorkData];
                break;
            case 3:
                [self getFlishNetWorkData];
                break;
            case 4:
                [self getNetWorkData];
                break;
            default:
                break;
        }
        
    }];
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            // 进入刷新状态后会自动调用这个block
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                // 结束刷新
//                [_tableView.mj_footer endRefreshing];
//                NSLog(@"上4444444444");
//            });
//            NSLog(@"上33333333333333");
//        }];
    
}
- (void)getNetWorkData{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:AllStr withParameters:nil withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                AllArray=dic[@"data"];
                fir=YES;
                if (fir&&[typeStr isEqualToString:@"4"]) {
                    [_DataArray removeAllObjects];
                    [_DataArray addObjectsFromArray:AllArray];
                    [self.tableView reloadData];
                }
                
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
- (void)getUnAccNetWorkData{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:unAccStr withParameters:nil withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                UnaccArray=dic[@"data"];
                sec=YES;
                if (sec&&[typeStr isEqualToString:@"1"]) {
                    [_DataArray removeAllObjects];
                    [_DataArray addObjectsFromArray:UnaccArray];
                    [_tableView reloadData];
                }
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
- (void)getDoingNetWorkData{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:AccStr withParameters:nil withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                DoingArray=dic[@"data"];
                three=YES;
                if (three&[typeStr isEqualToString:@"2"]) {
                    [_DataArray removeAllObjects];
                    [_DataArray addObjectsFromArray:DoingArray];
                    [_tableView reloadData];
                }
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
- (void)getFlishNetWorkData{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:FlishStr withParameters:nil withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                FlishArray=dic[@"data"];
                four=YES;
                if (four&&[typeStr isEqualToString:@"3"]) {
                    [_DataArray removeAllObjects];
                    [_DataArray addObjectsFromArray:FlishArray];
                    [_tableView reloadData];
                }
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
#pragma mark  － app代理
-(AppDelegate*)appDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.appDelegate.push_flish_count=0;
    self.appDelegate.push_accept_count=0;
    NSString *str1=[NSString stringWithFormat:@"%d",self.appDelegate.push_message_in];
    NSString *str2=[NSString stringWithFormat:@"%d",self.appDelegate.push_message_danger];
    NSString *str3=[NSString stringWithFormat:@"%d",self.appDelegate.push_message_out];
    NSString *str4=[NSString stringWithFormat:@"%d",self.appDelegate.push_notice_count];
    NSString *str5=[NSString stringWithFormat:@"%d",self.appDelegate.push_flish_count];
    NSString *str6=[NSString stringWithFormat:@"%d",self.appDelegate.push_accept_count];
    NSArray *testArray = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,str6, nil];
    NSNumber *sum = [testArray valueForKeyPath:@"@sum.floatValue"];
    [DDTools SendUnreadMessageCount:sum];
}
@end
