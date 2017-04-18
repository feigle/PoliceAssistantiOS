//
//  DDChooseRoomVC.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/13.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDChooseRoomVC.h"
#import "DDPersonCheckVC.h"

@interface DDChooseRoomVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *urlStr;
    NSMutableArray *DataArray;
    UIView* headView;
    int selectedIndexPath;
    NSString *addresstr;
    BOOL can_choose;
}
@property (nonatomic , retain) UITableView *tableView;
@property(nonatomic,strong)DDEmptyView *empview;
@end

@implementation DDChooseRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"楼栋房号";
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@%@",API_BASE_URL(@"v1/site/room?unitid="),_type_id];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getNetWorkData];
    UIBarButtonItem *rightbtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(jumptodispose)];
    self.navigationItem.rightBarButtonItem =rightbtn ;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=48;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    [self.view addSubview:self.tableView];
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 103)];
    headView.backgroundColor=TableViewBg;
    self.tableView.tableHeaderView=headView;
    [self creatTableheadview];
    _empview=[[DDEmptyView alloc]init];
}
#pragma mark - headVIew
- (void)creatTableheadview{
    DDLabel *lab21=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(15, 13, 200, 20) mytext:@"当前位置"];
    [headView addSubview:lab21];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, 48)];
    view1.backgroundColor=[UIColor whiteColor];
    [headView addSubview:view1];
    
    DDLabel *lab22=[[DDLabel alloc]initWithAlertViewHeight:18 mycolor:MAINTEX myfram:CGRectMake(15, 0, KScreenWidth-30, 48) mytext:_roomstring];
    [view1 addSubview:lab22];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), KScreenWidth, 15)];
    line.backgroundColor=TableViewBg;
    [headView addSubview:line];
}
#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!DataArray.count) {
        [_empview showCenterWithSuperView:self.tableView icon:@"empty_fancy" state:@"暂无相关数据"];
        return 0;
    }else{
        [_empview removeFromSuperview];
        return [DataArray count];
    }
    
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSDictionary *dic1=[DataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",dic1[@"room"]];
    cell.textLabel.font=sysFont18;
    cell.textLabel.textColor=MAINTEX;
    cell.accessoryType = UITableViewCellAccessoryNone;
//    if (selectedIndexPath ==indexPath.row)
//    {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        addresstr=[NSString stringWithFormat:@"%@-%@-%@",_roomstring,dic1[@"room"],dic1[@"roomid"]];
//        NSLog(@"--------%@",addresstr);
//    }
//    else
//    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    if (can_choose) {
        if (selectedIndexPath ==indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            addresstr=[NSString stringWithFormat:@"%@-%@-%@",_roomstring,dic1[@"room"],dic1[@"roomid"]];
            NSLog(@"--------%@",addresstr);
        }

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndexPath=(int)indexPath.row;
    NSLog(@"%d",selectedIndexPath);
    can_choose=YES;
    [self.tableView reloadData];
    
}
-(void)jumptodispose{

    if (!addresstr) {
        [DDProgressHUD showCenterWithText:@"未选择房间,保存失败" duration:1.0];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addressNotification" object:addresstr];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[DDPersonCheckVC class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
    
    
}
- (void)getNetWorkData{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:urlStr withParameters:nil withSuccessBlock:^(id response){
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
