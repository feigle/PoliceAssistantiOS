//
//  DDInfomationViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDInfomationViewController.h"
#import "DDInfomationTableViewCell.h"
#import "DDInfoDetaiViewController.h"

@interface DDInfomationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *timeLab;
    UILabel *countLab;
    NSString *urlStr;
    NSMutableArray *DataArray;
}
@property (nonatomic , retain) UITableView *tableView;
@property(nonatomic,strong)DDEmptyView *empview;


@end

@implementation DDInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"信息公告";
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/getnotice")];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getNetWorkData];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=100;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    [self.view addSubview:self.tableView];
    timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight-99, KScreenWidth, 15)];
  //  [self.view addSubview:timeLab];
    timeLab.font=sysFont13;
    timeLab.textColor=RGB(39, 39, 39);
    timeLab.text=@"1小时前更新";
    timeLab.textAlignment=NSTextAlignmentCenter;
    
    countLab=[[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight-84, KScreenWidth, 15)];
  //  [self.view addSubview:countLab];
    countLab.font=sysFont12;
    countLab.textColor=RGB(139, 139, 139);
    countLab.text=@"1封未读";
    countLab.textAlignment=NSTextAlignmentCenter;
    [self uploadAndDownload];
    _empview=[[DDEmptyView alloc]init];
    
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
    DDInfomationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[DDInfomationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSDictionary *dic=[DataArray objectAtIndex:indexPath.row];
    [cell adddic:dic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *Dic=[DataArray objectAtIndex:indexPath.row];
    DDInfoDetaiViewController*vc=[[DDInfoDetaiViewController alloc]init];
    [vc setValue:Dic forKey:@"datadic"];
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
