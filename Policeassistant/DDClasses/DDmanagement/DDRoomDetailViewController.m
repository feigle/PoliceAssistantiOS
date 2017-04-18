//
//  DDRoomDetailViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/30.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDRoomDetailViewController.h"
#import "DDRoomDetaiCell.h"
#import "DDPersonnelViewController.h"
#import "DDAccessViewController.h"

@interface DDRoomDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *urlStr;
    NSMutableArray *DataArray;
}
@property (nonatomic , retain) UITableView *tableView;
@property(nonatomic,strong)DDEmptyView *empview;
@end

@implementation DDRoomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=_nagtiontitle;
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@%@",API_BASE_URL(@"v1/site/people?roomid="),_roomid];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getNetWorkData];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-108) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=107.5;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    [self.view addSubview:self.tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _empview=[[DDEmptyView alloc]init];
    DDButton *button=[[DDButton alloc]initWithFrame:CGRectMake(0, KScreenHeight-108,  KScreenWidth, 44) withTitle:@"出入记录" touchBlock:^(DDButton *btn){
        [self searchAccessForBulid];
    }];
    button.layer.cornerRadius=0;
    [self.view addSubview:button];
}
- (void)searchAccessForBulid
{
    DDAccessViewController *vc=[[DDAccessViewController alloc]init];
    vc.onlyid=_roomid;
    vc.idtype=@"4";
    vc.Peo_Bulid_Room=@"2";
    [self.navigationController pushViewController:vc animated:YES];
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
    DDRoomDetaiCell*cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[DDRoomDetaiCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic=[DataArray objectAtIndex:indexPath.row];
    [cell adddic:dic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *Dic=[DataArray objectAtIndex:indexPath.row];
    DDPersonnelViewController*vc=[[DDPersonnelViewController alloc]init];
    [vc setValue:Dic forKey:@"datadic"];
    vc.roomid=_roomid;
    vc.cardid=[NSString stringWithFormat:@"%@",Dic[@"cardId"]];
    _type=[NSString stringWithFormat:@"社区管理"];
    vc.typestr=_type;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getNetWorkData{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
 //   NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"currentid",@"0",@"type",nil];
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
