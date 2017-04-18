//
//  DDChooseComVC.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/13.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDChooseComVC.h"
#import "DDPersonCheckVC.h"

@interface DDChooseComVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *urlStr;
    NSMutableArray *DataArray;
    UIView* headView;
}
@property (nonatomic , retain) UITableView *tableView;
@property(nonatomic,strong)DDEmptyView *empview;
@end

@implementation DDChooseComVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"社区";
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/community")];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getNetWorkData];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=48;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    [self.view addSubview:self.tableView];
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headView.backgroundColor=TableViewBg;
    self.tableView.tableHeaderView=headView;
    [self creatTableheadview];
    _empview=[[DDEmptyView alloc]init];
}
#pragma mark - headVIew
- (void)creatTableheadview{
    DDLabel *lab21=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(15, 13, 200, 20) mytext:@"请选择登记小区"];
    [headView addSubview:lab21];
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
    cell.textLabel.text=[NSString stringWithFormat:@"%@",dic1[@"communityName"]];
    cell.textLabel.font=sysFont18;
    cell.textLabel.textColor=MAINTEX;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DDPersonCheckVC *vc=[[DDPersonCheckVC alloc]init];
    NSDictionary *Dic=[DataArray objectAtIndex:indexPath.row];
    vc.comstring=[NSString stringWithFormat:@"%@",Dic[@"communityName"]];
    vc.type_id=[NSString stringWithFormat:@"%@",Dic[@"communityId"]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
