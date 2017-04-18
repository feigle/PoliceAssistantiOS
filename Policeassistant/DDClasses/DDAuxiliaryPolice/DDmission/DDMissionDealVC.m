//
//  DDMissionDealVC.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/2.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDMissionDealVC.h"
#import "DDLeftSliderManger.h"
#import "DDMissHeadView.h"
#import "DDMissDealCell.h"
#import "DDSystemMessageVC.h"
#import "DDMissPopView.h"
#import "DDFlowLayout.h"
#import "DDLayout.h"
#import "DDCollectionViewCell.h"
#import "AppDelegate.h"
//block
#define WGetWeakSelf(toName,instance) __weak __typeof(&*instance)toName = instance
static NSString *DDCollectionViewCellID = @"DDCollectionViewCellID";

@interface DDMissionDealVC ()<UITableViewDataSource,UITableViewDelegate,DDMissHeadViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSString *unAccStr,*AccStr,*FlishStr,*unAccCount,*AccCount;
    int headtype;
    UIImageView *imageView;
    DDLabel *lablempty;
    BOOL oneortwo;
    int page_count ,current_page;
    DDFlowLayout *flow;
    DDLayout *ddflow;
}
@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic, strong) DDMissHeadView *segView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray * secendSection;//处理中
@property (nonatomic,strong) NSArray * firstSection;//待受理
@property (nonatomic,strong) NSArray * threeSection;//已完成
@property (nonatomic,strong) NSMutableArray * showArray;//已完成
@property (nonatomic) int x;
@property(nonatomic,strong)DDEmptyView *empview;
@property(nonatomic,strong)UICollectionView *UnaccolltionView;
@end

@implementation DDMissionDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"任务处理";
    self.view.backgroundColor=RGB(10, 9, 25);
    UIBarButtonItem *leftbtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right_btn_change"] style:UIBarButtonItemStylePlain target:self action:@selector(jumptoLeftViewControl)];
    self.navigationItem.leftBarButtonItem =leftbtn ;
    headtype=0;
//    UIBarButtonItem *rightbtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message_right"] style:UIBarButtonItemStylePlain target:self action:@selector(jumptorightViewControl)];
//    self.navigationItem.rightBarButtonItem =rightbtn ;
    
    unAccCount=[NSString stringWithFormat:@"待受理  %lu",(unsigned long)self.firstSection.count];
    AccCount=[NSString stringWithFormat:@"处理中  %lu",(unsigned long)self.secendSection.count];
    self.segView.titles = @[unAccCount,AccCount,@"已完成"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-124) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=177.5;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = RGB(10, 8, 25);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.hidden=YES;
    
    [self uploadAndDownload];
    self.firstSection=[[NSMutableArray alloc]init];
    unAccStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/mission?type=1")];
    self.firstSection=[DDNetCache cacheJsonWithURL:unAccStr];
    [self getNetWorkData];
    
    self.secendSection=[[NSMutableArray alloc]init];
    AccStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/mission?type=2")];
    self.secendSection=[DDNetCache cacheJsonWithURL:AccStr];
    [self getDoingNetWorkData];
    
    
    self.threeSection=[[NSMutableArray alloc]init];
    FlishStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/mission?type=3")];
    self.threeSection=[DDNetCache cacheJsonWithURL:FlishStr];
    [self getFilishNetWorkData];
    
    _showArray=[[NSMutableArray alloc]init];
    
    self.segView=[[DDMissHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    self.segView.backgroundColor=RGB(33, 34, 50);
    [self.view addSubview:self.segView];
    self.segView.delegate = self;
    
    _empview=[[DDEmptyView alloc]init];
    
    //1.增加UIcollectionView
    flow =[[DDFlowLayout alloc]init];
    //1.1.布局item,设置item的大小
    flow.itemSize =CGSizeMake(KScreenWidth*2/3, KScreenHeight*3/5-20);
    //1.2.设置item的间距离
    flow.minimumInteritemSpacing =KScreenWidth/10;
    flow.minimumLineSpacing =KScreenWidth/10;
    //1.3 设置距离左边的距离
    CGFloat oneX =self.view.center.x -flow.itemSize.width *0.5;
    flow.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);
    flow.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    
    ddflow = ({
        //1.增加UIcollectionView
        DDLayout *flow1 =[[DDLayout alloc]init];
        //1.1.布局item,设置item的大小
        flow1.itemSize =CGSizeMake(KScreenWidth*2/3, KScreenHeight*3/5-20);
        //1.2.设置item的间距离
        flow1.minimumInteritemSpacing =KScreenWidth/10;
        flow1.minimumLineSpacing =KScreenWidth/10;
        //1.3 设置距离左边的距离
        CGFloat oneX =self.view.center.x -flow1.itemSize.width *0.5;
        flow1.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);
        flow1.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        flow1;
    });
    _UnaccolltionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    _UnaccolltionView.frame=CGRectMake(0, 67.5, KScreenWidth, KScreenHeight-203);
    _UnaccolltionView.backgroundColor = RGB(10, 8, 25);
    //2.设置collectionView属性
    _UnaccolltionView.dataSource =self;
    _UnaccolltionView.showsHorizontalScrollIndicator =NO;
    [_UnaccolltionView registerClass:[DDCollectionViewCell class] forCellWithReuseIdentifier:@"DDCollectionViewCellID"];
    [self.view addSubview:_UnaccolltionView];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_UnaccolltionView.frame), KScreenWidth, 20)];
    [self.view addSubview:_pageControl];
    _pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth-158)/2,(KScreenHeight-378)/2 , 158, 158)];
    imageView.image=[UIImage imageNamed:@"help_empty@3x"];
    [self.view addSubview:imageView];
    
    lablempty=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(0, CGRectGetMaxY(imageView.frame), KScreenWidth, 20) mytext:@"暂无相关数据"];
    lablempty.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lablempty];
    
    oneortwo=YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isRefresh:) name:@"isRefreshNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isgetCurrtent:) name:@"GetCurrentPageNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isget:) name:@"GetAllMessageNotification" object:nil];
    
}
- (void)isgetCurrtent:(NSNotification *)notification{
    NSString * text = notification.object;
    int currtpage;
    currtpage=[text intValue];
    _pageControl.currentPage = currtpage;
    NSLog(@",并实现传值%@",text);
    page_count=[text intValue];
    current_page=page_count;
}

- (void)isRefresh:(NSNotification *)notification{
    NSString * text = notification.object;
    
    if ([DDUserDefault getJob]) {
        return;
    }else{
        [_showArray removeAllObjects];
        if ([text isEqualToString:@"1"]&&self.appDelegate.is_get_message==NO) {
            [self getNetWorkData];
            [self getDoingNetWorkData];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [DDTools SendUnreadMessageCount:0];
        }
    }
}

- (void)isget:(NSNotification *)notification{
//    [DDAlertView initWithTitle:@"提示" message:[NSString stringWithFormat:@"新增一个任务,编号:%@",self.appDelegate.mission_number] cancleButtonTitle:nil OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonAtIndex) {
//        /*
//        NSLog(@"click index ====%ld",(long)buttonAtIndex);
//        if (buttonAtIndex == 0) {
//          //  [self getNetWorkData];
//           // [self getDoingNetWorkData];
//          //  [self.tableView.mj_header beginRefreshing];
//         //   self.appDelegate.is_get_message=NO;
//            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//         
//        }
//          */
//    }];
   
    [self getNetWorkData];
    [DDTools SendUnreadMessageCount:0];
    self.appDelegate.is_get_message=NO;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}
#pragma mark================弹框==========================
- (void)dospmething:(NSString *)sender{
    DDMissPopView *popview=[[DDMissPopView alloc]initWithAlertViewHeight];
    [self.view addSubview:popview.bGView];
    [self.view addSubview:popview];
    popview.ButtonClick=^void(UIButton*button,NSString *str){
        NSLog(@"%ld",(long)button.tag);
        if (button.tag==1001) {
            if ([str isEqualToString:@""]) {
                [DDProgressHUD showCenterWithText:@"完成报告内容格式不正确！" duration:1.0];
            }else{
                NSLog(@"%@----%@",str,sender);
                [self FinishNetWorkData:sender WithReason:str];
            }
        }
    };
    
}
#pragma mark================分段选择器==========================
-(void)segmentView:(DDMissHeadView *)segmentView didSelectIndex:(NSInteger)index{
    NSString *str=[NSString stringWithFormat:@"%ld",(long)index];
    headtype=[str intValue];
    switch (index) {
        case 0:
            oneortwo=YES;
            _tableView.hidden=YES;
            _UnaccolltionView.hidden=NO;
            [_showArray removeAllObjects];
            [_showArray addObjectsFromArray:_firstSection];
            [_UnaccolltionView reloadData];
            if (_UnaccolltionView.collectionViewLayout==flow) {
                [_UnaccolltionView setCollectionViewLayout:ddflow];
            }else{
                [_UnaccolltionView setCollectionViewLayout:flow];
            }
            break;
        case 1:
            oneortwo=NO;
            _tableView.hidden=YES;
            _UnaccolltionView.hidden=NO;
            [_showArray removeAllObjects];
            [_showArray addObjectsFromArray:_secendSection];
            [_UnaccolltionView reloadData];
            if (_UnaccolltionView.collectionViewLayout==ddflow) {
                [_UnaccolltionView setCollectionViewLayout:flow];
            }else{
                [_UnaccolltionView setCollectionViewLayout:ddflow];
            }
            break;
        case 2:
            _UnaccolltionView.hidden=YES;
            _tableView.hidden=NO;
            [_UnaccolltionView reloadData];
            if (_UnaccolltionView.collectionViewLayout==flow) {
                [_UnaccolltionView setCollectionViewLayout:ddflow];
            }else{
                [_UnaccolltionView setCollectionViewLayout:flow];
            }
            [_pageControl setAlpha:0];
            [imageView setAlpha:0];
            [lablempty setAlpha:0];
            break;
        default:
            break;
    }
}

#pragma mark-
#pragma mark================数据源==========================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!_showArray.count) {
        [imageView setAlpha:1];
        [lablempty setAlpha:1];
        [_pageControl setAlpha:0];
        return 0;
    }else{
        [imageView setAlpha:0];
        [lablempty setAlpha:0];
        [_pageControl setAlpha:1];
        _pageControl.numberOfPages=_showArray.count;
        _pageControl.currentPage=0;
        return _showArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DDCollectionViewCell *item =[collectionView dequeueReusableCellWithReuseIdentifier:
                                 DDCollectionViewCellID forIndexPath:indexPath];
    if (oneortwo) {
        NSDictionary *dic=[_showArray objectAtIndex:indexPath.row];
        [item adddic:dic];
        item.backgroundColor=[UIColor whiteColor];
        item.layer.cornerRadius=8;
        item.layer.masksToBounds = YES;
        item.acceptBtn.hidden=NO;
        item.flishBtn.hidden=YES;
        item.startLab.hidden=YES;
        [item.acceptBtn addTarget:self action:@selector(DeletaTaskid:) forControlEvents:UIControlEventTouchUpInside];
        NSString *missionid=[NSString stringWithFormat:@"%@",dic[@"missionid"]];
        item.acceptBtn.tag=[missionid intValue];
        
    }else{
        NSDictionary *dic=[_showArray objectAtIndex:indexPath.row];
        [item adddic:dic];
        item.backgroundColor=[UIColor whiteColor];
        item.layer.cornerRadius=8;
        item.layer.masksToBounds = YES;
        item.acceptBtn.hidden=YES;
        item.flishBtn.hidden=NO;
        item.startLab.hidden=NO;
        [item.flishBtn addTarget:self action:@selector(FlishTaskid:) forControlEvents:UIControlEventTouchUpInside];
        NSString *missionid=[NSString stringWithFormat:@"%@",dic[@"missionid"]];
        item.flishBtn.tag=[missionid intValue];
    }
    
    
    return item;
    
}
- (void)DeletaTaskid:(UIButton *)sender{
    NSString *taskid=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self AcceptNetWorkData:taskid];
}
- (void)FlishTaskid:(UIButton *)sender{
    NSString *taskid=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self dospmething:taskid];
}
#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_threeSection.count) {
        [_empview showCenterWithSuperView:self.tableView icon:@"help_empty" state:@"暂无相关数据"];
        return 0;
    }else{
        [_empview removeFromSuperview];
        return [_threeSection count];
    }
    
    
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cell";
    DDMissDealCell*cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[DDMissDealCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSDictionary *dic=[_threeSection objectAtIndex:indexPath.row];
    [cell adddic:dic];
    cell.backgroundColor=RGB(10, 8, 25);
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
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
- (void)jumptorightViewControl{
    [self getNetWorkData];
    [self getDoingNetWorkData];
//    DDSystemMessageVC *vc=[[DDSystemMessageVC alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
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
        
        [self getFilishNetWorkData];
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
/**
 *  获取待受理
 */
- (void)getNetWorkData{
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
                _firstSection=dic[@"data"];
                BOOL result = [DDNetCache saveJsonResponseToCacheFile:_firstSection andURL:unAccStr];
                if(result) NSLog(@"(同步)写入/更新缓存数据 成功");
                unAccCount=[NSString stringWithFormat:@"待受理  %lu",(unsigned long)self.firstSection.count];
                AccCount=[NSString stringWithFormat:@"处理中  %lu",(unsigned long)self.secendSection.count];
                self.segView.titles = @[unAccCount,AccCount,@"已完成"];
                if (headtype==0) {
                    [_showArray removeAllObjects];
                    [_showArray addObjectsFromArray:_firstSection];
                    [_UnaccolltionView reloadData];
                    if (_UnaccolltionView.collectionViewLayout==flow) {
                        [_UnaccolltionView setCollectionViewLayout:ddflow];
                    }else{
                        [_UnaccolltionView setCollectionViewLayout:flow];
                    }
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
/**
 *  获取处理中
 */
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
                _secendSection=dic[@"data"];
                BOOL result = [DDNetCache saveJsonResponseToCacheFile:_secendSection andURL:AccStr];
                if(result) NSLog(@"(同步)写入/更新缓存数据 成功");
                unAccCount=[NSString stringWithFormat:@"待受理  %lu",(unsigned long)self.firstSection.count];
                AccCount=[NSString stringWithFormat:@"处理中  %lu",(unsigned long)self.secendSection.count];
                self.segView.titles = @[unAccCount,AccCount,@"已完成"];
                if (headtype==1) {
                    [_showArray removeAllObjects];
                    [_showArray addObjectsFromArray:_secendSection];
                    [_UnaccolltionView reloadData];
                    if (_UnaccolltionView.collectionViewLayout==flow) {
                        [_UnaccolltionView setCollectionViewLayout:ddflow];
                    }else{
                        [_UnaccolltionView setCollectionViewLayout:flow];
                    }
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
/**
 *  获取完成
 */
- (void)getFilishNetWorkData{
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
                _threeSection=dic[@"data"];
                BOOL result = [DDNetCache saveJsonResponseToCacheFile:_threeSection andURL:FlishStr];
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
/**
 *  接受任务
 */
- (void)AcceptNetWorkData :(NSString *)task_id{
    [SVProgressHUD showWithStatus:@"正在受理..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:task_id,@"taskid",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:API_BASE_URL(@"v1/site/acceptmission") withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"success"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            NSNumber *msgCode1 =[dic objectForKey:@"error_code"];
            NSString *msg1=[NSString stringWithFormat:@"%@",msgCode1];
            if ([@"1" isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"受理成功" duration:1.0];
                [self getNetWorkData];
                [self getDoingNetWorkData];
            }else if ([@"0" isEqualToString:msg]){
                if ([@"20009" isEqualToString:msg1]){
                    [DDProgressHUD showCenterWithText:@"该任务已被民警删除" duration:2.0];
                }else if ([@"20007" isEqualToString:msg1]){
                    [DDProgressHUD showCenterWithText:@"任务编号不允许为空" duration:2.0];
                }else if ([@"20008" isEqualToString:msg1]){
                    [DDProgressHUD showCenterWithText:@"处理中的任务已达到10个" duration:2.0];
                }
            }
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){

    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];
    
}

/**
 *  完成任务
 */
- (void)FinishNetWorkData :(NSString *)task_id WithReason:(NSString*)reason{
    [SVProgressHUD showWithStatus:@"正在提交..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:task_id,@"taskid",reason,@"reason",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:API_BASE_URL(@"v1/site/finishmission") withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                [DDProgressHUD showCenterWithText:@"任务完成" duration:1.0];
                [self getDoingNetWorkData];
                [self getFilishNetWorkData];
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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
