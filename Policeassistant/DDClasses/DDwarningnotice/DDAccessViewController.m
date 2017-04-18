//
//  DDAccessViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/28.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDAccessViewController.h"
#import "DDAccessTableViewCell.h"
#import "DDPopView.h"
#import "DDMovieViewController.h"
#import "DDManagementViewController.h"
#import "DDPopMenuView.h"

@interface DDAccessViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *urlStr;
    NSMutableArray *DataArray;
    NSMutableArray *showarray;
    NSString *dayType,*picORmovie;
    UIButton *imageBtn;
    int currenttag;
}
@property (nonatomic , retain) UITableView *tableView;
@property(nonatomic,strong)DDEmptyView *empview;
@property(nonatomic,strong)DDPopView *alert;
@property (nonatomic,assign) BOOL flag;
@end

@implementation DDAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"出入记录";
    /*
    if ([_mangertype isEqualToString:@"社区管理"]) {
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"社区管理" style:UIBarButtonItemStylePlain target:self action:@selector(pushutoMoview)];
        self.navigationItem.rightBarButtonItem=item;
    }
     */

    picORmovie=@"1";
    UIView *itemview1=[[UIView alloc]initWithFrame:CGRectMake(-15, 20, 70, 44)];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:itemview1];
    UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(-15, 0, 65, 44);
    [btn setImage:[UIImage imageNamed:@"gobackBtn@3x"] forState:UIControlStateNormal];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font=sysFont16;
    [itemview1 addSubview:btn];
    [btn addTarget:self action:@selector(doBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item;
    
    
    UIView *itemview=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth-50, 20, 50, 44)];
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:itemview];
    imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame=CGRectMake(0, 0, 100, 44);
    [imageBtn setImage:[UIImage imageNamed:@"icon_down@3x"] forState:UIControlStateNormal];
    [imageBtn setTitle:@"图片" forState:UIControlStateNormal];
    imageBtn.titleLabel.font=sysFont15;
    imageBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 0);
    imageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 60);
    [itemview addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(pushutoMoview) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=barbtn;
    DataArray=[[NSMutableArray alloc] init];
    showarray=[[NSMutableArray alloc]init];
    switch ([_Peo_Bulid_Room intValue]) {
        case 1:
            NSLog(@"栋");
            urlStr=[NSString stringWithFormat:@"%@%@&idtype=%@",API_BASE_URL(@"v2/site/getPackagepassrecord?onlyid="),_onlyid,_idtype];
            break;
        case 2:
            NSLog(@"房间");
            urlStr=[NSString stringWithFormat:@"%@%@&idtype=%@",API_BASE_URL(@"v2/site/getPackagepassrecord?onlyid="),_onlyid,_idtype];
            break;
        case 3:
            NSLog(@"人");
            urlStr=[NSString stringWithFormat:@"%@%@&roomid=%@",API_BASE_URL(@"v1/site/passrecord?cardid="),_cardid,_roomid];
            break;
        default:
            break;
    }
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getNetWorkData:picORmovie];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=170;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self uploadAndDownload];
    _empview=[[DDEmptyView alloc]init];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.flag = YES;
    NSArray *dataArray = @[@"图片",@"视频"];
    // 计算菜单frame
    CGFloat x = self.view.bounds.size.width / 3 * 2;
    CGFloat y = 64;
    CGFloat width = self.view.bounds.size.width * 0.3;
    CGFloat height = dataArray.count * 40;  // 40 -> tableView's RowHeight
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建menu
     */
    [DDPopMenuView createMenuWithFrame:CGRectMake(x, y, width, height) target:self.navigationController dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        // do something
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag];
        
    } backViewTap:^{
        // 点击背景遮罩view后的block，可自定义事件
        // 这里的目的是，让rightButton点击，可再次pop出menu
        weakSelf.flag = YES;
        [imageBtn setImage:[UIImage imageNamed:@"icon_down@3x"] forState:UIControlStateNormal];
    }];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentToMoviePlayVC:) name:@"FullScreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CloseMovie:) name:@"GoBackVCNotification" object:nil];

    currenttag=1;
}
- (void)CloseMovie:(NSNotification *)notification
{
    [_alert hide:NO];
}
- (void)presentToMoviePlayVC:(NSNotification *)notification
{
    DDMovieViewController *movie = [[DDMovieViewController alloc]init];
    [self presentViewController:movie animated:YES completion:nil];
   // NSLog(@"------%f--------%f",_alert.frame.size.width,_alert.frame.size.height);

}
-(void)pushutoMoview{
    /*
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[DDManagementViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
     */
    if (self.flag) {
        [DDPopMenuView showMenuWithAnimation:self.flag];
        [imageBtn setImage:[UIImage imageNamed:@"icon_up@3x"] forState:UIControlStateNormal];
        self.flag = NO;
    }else{
        [DDPopMenuView showMenuWithAnimation:self.flag];
        [imageBtn setImage:[UIImage imageNamed:@"icon_down@3x"] forState:UIControlStateNormal];
        self.flag = YES;
    }
}
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
      switch (tag) {
        case 1:
            [imageBtn setTitle:@"图片" forState:UIControlStateNormal];
            break;
        case 2:
            [imageBtn setTitle:@"视频" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    if (currenttag==(int)tag) {
        NSLog(@"不操作");
    }else {
        [showarray removeAllObjects];
        currenttag=(int)tag;
        NSString *type=[NSString stringWithFormat:@"%d",currenttag];
        picORmovie=[NSString stringWithFormat:@"%d",currenttag];
        [self getNetWorkData:type];
        NSLog(@"网络请求 %d",currenttag);
    }

    [DDPopMenuView hidden];  // 隐藏菜单
    [imageBtn setImage:[UIImage imageNamed:@"icon_down@3x"] forState:UIControlStateNormal];
    self.flag = YES;
}
- (void)doBackAction{
    [self.navigationController popViewControllerAnimated:YES];
    [DDPopMenuView clearMenu];

}
- (void)dealloc{
    [DDPopMenuView clearMenu];   // 移除菜单
}
-(void)closetheVC{
    [self.navigationController popViewControllerAnimated:YES];
}

//块的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (!showarray.count) {
        if (currenttag==2) {
            [_empview showCenterWithSuperView:self.tableView icon:@"empty_movie" state:@"抱歉！暂无视频"];
        }else{
            [_empview showCenterWithSuperView:self.tableView icon:@"empty_fancy" state:@"暂无相关数据"];
        }
        return 0;
    }else{
        [_empview removeFromSuperview];
        return [showarray count];
    }

}
//块中的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[showarray objectAtIndex:section] count];
}
//页眉的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.f;
}

//页脚的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cell";
    DDAccessTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[DDAccessTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSArray *arr=[showarray objectAtIndex:indexPath.section];
    NSDictionary *dic=[arr objectAtIndex:indexPath.row];
    [cell adddic:dic withtype:[NSString stringWithFormat:@"%d",currenttag]];
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    [cell.btn1 addTarget:self action:@selector(POPView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn addTarget:self action:@selector(POPView:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *secendView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    secendView.backgroundColor=[UIColor whiteColor];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    imgView.image=[UIImage imageNamed:@"day_quan"];
    [secendView addSubview:imgView];
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(24, 0, 2, 10)];
    lineview.backgroundColor=DaohangCOLOR;
    [secendView addSubview:lineview];
    if (section==0) {
        lineview.hidden=YES;
    }
    UIView *lineview1=[[UIView alloc]initWithFrame:CGRectMake(24, 30, 2, 10)];
    lineview1.backgroundColor=DaohangCOLOR;
    [secendView addSubview:lineview1];
    NSArray *arr=[showarray objectAtIndex:section];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 150, 40)];
    lab.textColor=DaohangCOLOR;
    for(NSDictionary *dic0 in arr)
    {
        NSString *str2=[dic0 objectForKey:@"log_time"];
        dayType =[str2 substringToIndex:10];
        lab.text=dayType;
    }
    [secendView addSubview:lab];
    //获取日期
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *yesterday = [today dateByAddingTimeInterval:-secondsPerDay];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //当天日期
    NSString *todayDateStr = [formatter stringFromDate:today];
    
    //昨天日期
    NSString *yesterdayDateStr = [formatter stringFromDate:yesterday];
    
    if ([dayType isEqualToString:todayDateStr]) {
        
        lab.text = @"今天";
        
    }else if ([dayType isEqualToString:yesterdayDateStr]) {
        
        lab.text =@"昨天";
        
    }else {
        
        lab.text = dayType;
    }
    
    return secendView;
    
}
-(void)POPView:(UIButton *)sender{

    [DDProgressHUD showCenterWithText:@"正在加载..." duration:2.0];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled=NO;
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:sender];
    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:2.0f];
    
}
- (void)todoSomething:(id)sender
{

    [UIApplication sharedApplication].keyWindow.userInteractionEnabled=YES;
    UIView *v = [sender superview];//获取父类view
    UIView *v1 = [v superview];
    UITableViewCell *cell = (UITableViewCell *)[v1 superview];//获取cell
    NSIndexPath *indexPathAll = [self.tableView indexPathForCell:cell];//获取cell对应的section
    NSArray *arra=[showarray objectAtIndex:indexPathAll.section];
    NSDictionary *dic=[arra objectAtIndex:indexPathAll.row];
    _alert=[[DDPopView alloc]initWithTimeText:dic[@"log_time"] type:[NSString stringWithFormat:@"%d",currenttag] WithArray:DataArray];
    [[UIApplication sharedApplication].keyWindow addSubview:_alert.bGView];
    [[UIApplication sharedApplication].keyWindow addSubview:_alert];
    _alert.ButtonClick = ^void(NSString*button){
        
    };
    
}

- (void)uploadAndDownload{
    // 下拉刷新
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_tableView.mj_header endRefreshing];
        });
        [self getNetWorkData:picORmovie];
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
- (void)getNetWorkData:(NSString*)picandmiove{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:picandmiove,@"type",nil];
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
                if (DataArray.count) {
                    [self resetVisitorRecordData :DataArray];
                }else{
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

#pragma mark -
#pragma mark (重组用户数据)
- (void)resetVisitorRecordData:(NSMutableArray *)array {
    
    NSMutableArray *muArrayOne = [[NSMutableArray alloc] init];
    for(NSDictionary *dic0 in array)
    {
        //若没该日期
        if(![self array:muArrayOne containsObject:dic0])
        {
            [muArrayOne addObject:dic0];
            
        }
    }
    //数组分类
    showarray = [[NSMutableArray alloc] init];
    for(int i = 0 ;i<muArrayOne.count;i++)
    {
        NSDictionary *dic = muArrayOne[i];
        NSString *data=[self dateByDic:dic];
        //同类数组
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for(NSDictionary *dic1 in array)
        {
            NSString *data1 =[self dateByDic:dic1];
            if([data isEqualToString:data1])
            {
                [muArray addObject:dic1];
            }
        }
        [showarray addObject:muArray];
        [self.tableView reloadData];
    }
    
    NSLog(@"muArrayAfter==%@",showarray);
    
    
    
    
}
/**
 *  获取字典日期
 */
-(NSString *)dateByDic:(NSDictionary *)dic
{
    NSString *str1=[dic objectForKey:@"log_time"];
    NSString *date=[str1 substringToIndex:10];
    return date;
}
/**
 *  数组是否包含该日期字典
 */
-(BOOL)array:(NSArray *)array containsObject:(NSDictionary *)dic
{
    NSString *data=[self dateByDic:dic];
    for(NSDictionary *dic0 in array)
    {
        NSString *data0 =[self dateByDic:dic0];
        if([data0 isEqualToString:data])
        {
            return YES;
        }
    }
    return NO;
}


@end
