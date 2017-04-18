//
//  DDChooseUnitVC.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/13.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDChooseUnitVC.h"
#import "DDChooseDanVC.h"

@interface DDChooseUnitVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *DataArray;
    UIView* headView;
    NSString *urlStr;
}
@property (nonatomic , retain) UITableView *tableView;
@property(nonatomic,strong)DDEmptyView *empview;

@end

@implementation DDChooseUnitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"楼栋房号";
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@%@",API_BASE_URL(@"v1/site/building?communityid="),_type_id];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getNetWorkData];
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
    
    DDLabel *lab22=[[DDLabel alloc]initWithAlertViewHeight:18 mycolor:MAINTEX myfram:CGRectMake(15, 0, 200, 48) mytext:_comstring]; 
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
    cell.textLabel.text=[NSString stringWithFormat:@"%@",dic1[@"buildname"]];
    cell.textLabel.font=sysFont18;
    cell.textLabel.textColor=MAINTEX;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDChooseDanVC *vc=[[DDChooseDanVC alloc]init];
    NSDictionary *dic1=[DataArray objectAtIndex:indexPath.row];
    vc.unittring=[NSString stringWithFormat:@"%@-%@",_comstring,dic1[@"buildname"]];
    vc.type_id=[NSString stringWithFormat:@"%@",dic1[@"buildid"]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getNetWorkData{

    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    //    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:_communityid,@"communityid",nil];
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
