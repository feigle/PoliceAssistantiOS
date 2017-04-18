//
//  DDTaskOrderVC.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/8.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDTaskOrderVC.h"
#import "DDPullView.h"
#import "DDTaskassignmentViewController.h"

@interface DDTaskOrderVC ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,DDPopOverViewDelegate>
{
    UILabel *areaLab,*typeLab,*peopleLab,*timeLab;
    UIView* headView;
    UIButton *_preBtn;//当前的状态
    int payType;
    UIView *view1,*view2,*view3,*view4;
    NSArray *typearr,*timearr;
    NSMutableArray *arearr,*peoplearr,*comid_arr,*peroson_arr,*personid_arr;
    NSString *lvstr,*community_id,*people_id,*type_id,*time_id;
    NSString *urlStr;
    NSMutableArray *DataArray;
    NSMutableDictionary *dio;
}
@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic, strong) DDTextView * textView;
@end

@implementation DDTaskOrderVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getNetWorkData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"任务委派";
    NSLog(@"change===%@",_changDic);
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/initmission")];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
   // [self getNetWorkData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    [self.view addSubview:self.tableView];
    
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 520)];
    self.tableView.tableHeaderView=headView;
    
    [self creatTableheadview];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
   // arearr=[NSMutableArray array];
    peoplearr=[NSMutableArray array];
    comid_arr=[NSMutableArray array];
    personid_arr=[NSMutableArray array];
    peroson_arr=[NSMutableArray array];
    typearr = @[@"上门走访", @"人员信息登记",@"其他",];
    timearr = @[@"今天", @"明天", @"本周"];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
    
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

#pragma mark - headVIew
- (void)creatTableheadview{
    view1=[[UIView alloc]init];
    areaLab=[[UILabel alloc]init];
    [self setupOneView:view1 WithFrame:CGRectMake(15, 15, KScreenWidth-30, 44) WithString:@"小区"];
    [headView addSubview:view1];
    view1.tag=1000;
    
    DDLabel*lab1=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(115, 0, view1.frame.size.width-145, 44) mytext:@"请选择小区"];
    lab1.textAlignment=NSTextAlignmentRight;
    areaLab=lab1;
    [view1 addSubview:areaLab];
    
    view2=[[UIView alloc]init];
    typeLab=[[UILabel alloc]init];
    [self setupOneView:view2 WithFrame:CGRectMake(15, CGRectGetMaxY(view1.frame)+15, KScreenWidth-30, 44) WithString:@"处理方式"];
    [headView addSubview:view2];
    view2.tag=1001;
    DDLabel*lab2=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(115, 0, view2.frame.size.width-145, 44) mytext:@"请选择方式"];
    lab2.textAlignment=NSTextAlignmentRight;
    typeLab=lab2;
    [view2 addSubview:typeLab];
    
    view3=[[UIView alloc]init];
    peopleLab=[[UILabel alloc]init];
    [self setupOneView:view3 WithFrame:CGRectMake(15, CGRectGetMaxY(view2.frame)+15, KScreenWidth-30, 44) WithString:@"处理人员"];
    [headView addSubview:view3];
    view3.tag=1002;
    DDLabel*lab3=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(115, 0, view3.frame.size.width-145, 44) mytext:@"请选择人员"];
    lab3.textAlignment=NSTextAlignmentRight;
    peopleLab=lab3;
    [view3 addSubview:peopleLab];
    
    view4=[[UIView alloc]init];
    timeLab=[[UILabel alloc]init];
    [self setupOneView:view4 WithFrame:CGRectMake(15, CGRectGetMaxY(view3.frame)+15, KScreenWidth-30, 44) WithString:@"完成时间"];
    [headView addSubview:view4];
    view4.tag=1003;
    DDLabel*lab4=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(115, 0, view3.frame.size.width-145, 44) mytext:@"请选择时间"];
    lab4.textAlignment=NSTextAlignmentRight;
    timeLab=lab4;
    [view4 addSubview:timeLab];
    
    UIView *mview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view4.frame), KScreenWidth, 60)];
    [headView addSubview:mview];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(105, 0, 60, 60)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"choose_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"choose_height"] forState:UIControlStateSelected];
    [button setTitle:@"一般" forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0,-12,0,0);
    [button setTitleColor:TEXCOLOR forState:UIControlStateNormal];
    [button setTitleColor:MAINTEX forState:UIControlStateSelected];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    button.tag=1001;
    [mview addSubview:button];
    
    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(215, 0, 60, 60)];
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setImage:[UIImage imageNamed:@"choose_normal"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"choose_height"] forState:UIControlStateSelected];
    [button1 setTitle:@"紧急" forState:UIControlStateNormal];
    button1.imageEdgeInsets = UIEdgeInsetsMake(0,-12,0,0);
    [button1 setTitleColor:TEXCOLOR forState:UIControlStateNormal];
    [button1 setTitleColor:MAINTEX forState:UIControlStateSelected];
    button1.titleLabel.font=[UIFont systemFontOfSize:16];
    button1.tag=1002;
    [mview addSubview:button1];
    
    DDLabel *lab21=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(25, 20, 80, 20) mytext:@"紧急程度"];
    [mview addSubview:lab21];
    
    _textView = [[DDTextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(mview.frame), KScreenWidth-30, 123)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16.f];
    _textView.textColor = MAINTEX;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.editable = YES;
    _textView.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    _textView.layer.cornerRadius = 5.0f;
    _textView.layer.borderColor = LINECOLOR.CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.placeholderColor = TEXCOLOR;
    _textView.placeholder = @"描述(50字之内)";
    _textView.returnKeyType=UIReturnKeyDone;
    [headView addSubview:_textView];
    
    DDButton *loginbtn=[[DDButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_textView.frame)+30, KScreenWidth-30, 42) withTitle:@"发送" touchBlock:^(DDButton *btn){
        [self sendToSerce];
    }];
    [headView addSubview:loginbtn];
    
    if ([_flag isEqualToString:@"1"]) {
        areaLab.text=[NSString stringWithFormat:@"%@",_changDic[@"address"]];
        areaLab.textColor=MAINTEX;
        community_id=[NSString stringWithFormat:@"%@",_changDic[@"dep_id"]];
        peopleLab.text=[NSString stringWithFormat:@"%@",_changDic[@"real_name"]];
        peopleLab.textColor=MAINTEX;
        people_id=[NSString stringWithFormat:@"%@",_changDic[@"userid"]];
        _textView.text=[NSString stringWithFormat:@"%@",_changDic[@"content"]];
        NSString *missionlv=[NSString stringWithFormat:@"%@",_changDic[@"missionlv"]];
        switch ([missionlv intValue]) {
            case 1:
                button.selected=YES;
                _preBtn=button;
                lvstr=[NSString stringWithFormat:@"1"];
                break;
            case 2:
                button1.selected=YES;
                _preBtn=button1;
                lvstr=[NSString stringWithFormat:@"2"];
                break;
            default:
                break;
        }
        NSString *missiontype=[NSString stringWithFormat:@"%@",_changDic[@"missiontype"]];
        switch ([missiontype intValue]) {
            case 1:
                typeLab.text=[NSString stringWithFormat:@"其他"];
                typeLab.textColor=MAINTEX;
                type_id=[NSString stringWithFormat:@"1"];
                break;
            case 2:
                typeLab.text=[NSString stringWithFormat:@"上门走访"];
                typeLab.textColor=MAINTEX;
                type_id=[NSString stringWithFormat:@"2"];
                break;
            case 3:
                typeLab.text=[NSString stringWithFormat:@"人员信息登记"];
                typeLab.textColor=MAINTEX;
                type_id=[NSString stringWithFormat:@"3"];
                break;
            default:
                break;
        }


    }
}
- (void)setupOneView :(UIView *)View WithFrame:(CGRect)frame WithString:(NSString *)labelstring{
    View.frame=frame;
  //  View.backgroundColor=[UIColor whiteColor];
    View.layer.borderWidth = 1;
    View.layer.cornerRadius = 5;
    View.layer.borderColor = [LINECOLOR CGColor];
    DDLabel*label=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(15, 0, 100, 44) mytext:labelstring];
    [View addSubview:label];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-30, 12, 20, 20)];
    imageview.image=[UIImage imageNamed:@"pull"];
    [View addSubview:imageview];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dosomething:)];
    [View addGestureRecognizer:tap];
}
- (void)makeupAsmallView:(UIView *)view withfram:(CGRect)fram withstr1:(NSString *)str1{
    
    view.frame=fram;
   // view.backgroundColor=[UIColor whiteColor];
    view.layer.borderWidth=1;
    view.layer.cornerRadius=5;
    view.layer.borderColor=[LINECOLOR CGColor];
    DDLabel*label1=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(fram.size.width/2, 0, fram.size.width/2-20, 44) mytext:str1];
    [view addSubview:label1];
    label1.textAlignment=NSTextAlignmentRight;
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(fram.size.width-20, 12, 20, 20)];
    imageview.image=[UIImage imageNamed:@"pull"];
    [view addSubview:imageview];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dosomething:)];
    [view addGestureRecognizer:tap];
}
- (void)buttonAction:(UIButton*)sender{
    _preBtn.selected = NO;
    sender.selected = YES;
    _preBtn = sender;
    payType=(int)sender.tag-1000;
    lvstr =[NSString stringWithFormat:@"%d",payType];
    NSLog(@"-0-0-0-0-%d",payType);
}

- (void)dosomething:(UITapGestureRecognizer *)sender  {
    
    UIView *targetview = sender.view;
    switch (targetview.tag) {
        case 1000:
            [self testClick:arearr WithView:view1 andstr:@"1000"];
            break;
        case 1001:
            [self testClick:typearr WithView:view2 andstr:@"1001"];
            break;
        case 1002:
            if ([areaLab.text isEqualToString:@"请选择小区"]) {
                [DDProgressHUD showCenterWithText:@"请先选择小区" duration:2.0];
            }else
            {
                [self testClick:peroson_arr WithView:view3 andstr:@"1002"];
            }
            break;
        case 1003:
            [self testClick:timearr WithView:view4 andstr:@"1003"];
            break;
        default:
            break;
    }
    
    
    
}
- (void)testClick:(NSArray *)arr WithView:(UIView*)tetview andstr:(NSString *)falgstr{
    
    DDPullView *view = [[DDPullView alloc]initWithBounds:CGRectMake(0, 0, (KScreenWidth-30)/2, 44*(arr.count<5?arr.count:5)) titleMenus:arr andflagstr:falgstr];
    view.containerBackgroudColor = [UIColor whiteColor];
    view.delegate = self;
    if (arr.count==0) {
        [DDProgressHUD showCenterWithText:@"没有相关数据,无法选择" duration:1.0];
    }else{
        [view showFrom:tetview alignStyle:CPAlignStyleLeft];
    }
}
- (void)chossarray:(NSString *)str{
    NSArray *arr1=[dio objectForKey:str];
    for (int i=0; i<arr1.count; i++) {
        NSDictionary *dic1=[arr1 objectAtIndex:i];
        NSString *str1=dic1[@"name"];
        NSString *str2=dic1[@"id"];
        if ([peroson_arr containsObject:str1] == NO){
            [peroson_arr addObject:str1];
        }
        if ([personid_arr containsObject:str2] == NO){
            [personid_arr addObject:str2];
        }
    }
}
- (void)popOverView:(DDPullView *)pView didClickMenuIndex:(NSInteger)index
{
    switch ([pView.flagstr intValue]) {
        case 1000:
            areaLab.text=arearr[index];
            areaLab.textColor=MAINTEX;
            community_id=[NSString stringWithFormat:@"%@",comid_arr[index]];
            [self chossarray:community_id];
            peopleLab.text=@"请选择人员";
            peopleLab.textColor=TEXCOLOR;
            people_id=nil;
            break;
        case 1001:
            typeLab.text=typearr[index];
            typeLab.textColor=MAINTEX;
            type_id=[NSString stringWithFormat:@"%ld",index+2];
            if ([type_id isEqualToString:@"4"]) {
                type_id=[NSString stringWithFormat:@"1"];
            }
            break;
        case 1002:
            peopleLab.text=peroson_arr[index];
            peopleLab.textColor=MAINTEX;
            people_id=[NSString stringWithFormat:@"%@",personid_arr[index]];
            break;
        case 1003:
            timeLab.text=timearr[index];
            timeLab.textColor=MAINTEX;
            time_id=[NSString stringWithFormat:@"%ld",index+1];
            break;
            
        default:
            break;
    }
    [pView dismiss];
}

- (void)sendToSerce{

    if (!community_id)
    {
        [DDProgressHUD showCenterWithText:@"未选择小区" duration:1.0];
        return;
    }else if (!type_id)
    {
        [DDProgressHUD showCenterWithText:@"未选择处理方式" duration:1.0];
        return;
    }else if (!people_id)
    {
        [DDProgressHUD showCenterWithText:@"未选择处理人员" duration:1.0];
        return;
    }else if (!time_id)
    {
        [DDProgressHUD showCenterWithText:@"未选择完成时间" duration:1.0];
        return;
    }else if (!lvstr)
    {
        [DDProgressHUD showCenterWithText:@"未选择紧急程度" duration:1.0];
        return;
    }else if ([_textView.text isEqualToString:@""]||[DDTools isEmpty:_textView.text])
    {
        [DDProgressHUD showCenterWithText:@"未添加任务内容" duration:1.0];
        return;
    }else if (_textView.text.length>50)
    {
        [DDProgressHUD showCenterWithText:@"内容超过50个字！" duration:1.0];
        return;
    }
    else{
        if ([_flag isEqualToString:@"1"]) {
            NSString *missid=[NSString stringWithFormat:@"%@",_changDic[@"missionid"]];
            [self EditNetWork:missid];
        }else{
            [self CommitNetWork];
        }
    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}
/**
 *  初始化任务
 */
-(void)getNetWorkData{
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
                dio=[[NSMutableDictionary alloc]init];
                arearr=[NSMutableArray array];
                for (int i=0; i<DataArray.count; i++) {
                    NSDictionary *dic1=[DataArray objectAtIndex:i];
                    NSString *str1=dic1[@"community_name"];
                    NSString *str2=dic1[@"community_id"];
                    NSArray *arr3=dic1[@"community_manager"];
                    NSString *str22=[NSString stringWithFormat:@"%@",dic1[@"community_id"]];
                    [dio setObject:arr3 forKey:str22];
                    [arearr addObject:str1];
                    [comid_arr addObject:str2];
                }
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
/**
 *  提交一个任务
 */
- (void)CommitNetWork{
    [SVProgressHUD showWithStatus:@"正在提交..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:community_id,@"community_id",type_id,@"handle_type",people_id,@"people",time_id,@"finishtime",lvstr,@"lv",_textView.text,@"info",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:API_BASE_URL(@"v1/site/createmission") withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                
                [DDProgressHUD showCenterWithText:@"委派成功" duration:2.0];
                [self.navigationController popViewControllerAnimated:YES];
                self.Successful(@"2");
            }
            else if ([Error_Code_Failed isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }else if ([Error_Code_RequestError isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }else if ([@"20008" isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"对方待受理任务已达到10个" duration:2.0];
            }
            
        }else{
            
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){

    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];

}
/**
 *  编辑一个任务
 */
- (void)EditNetWork:(NSString *)task_id{
    [SVProgressHUD showWithStatus:@"正在提交..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:community_id,@"community_id",type_id,@"handle_type",people_id,@"people",time_id,@"finishtime",lvstr,@"lv",_textView.text,@"info",task_id,@"taskid",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:API_BASE_URL(@"v1/site/editmission") withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"success"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            NSNumber *msgCode1 =[dic objectForKey:@"error_code"];
            NSString *msg1=[NSString stringWithFormat:@"%@",msgCode1];
            
            if ([@"1" isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"委派成功" duration:2.0];
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[DDTaskassignmentViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"MissonNotification" object:@"123"];
                    }
                }
            }
            else if ([@"0" isEqualToString:msg]){
                
                if ([@"20010" isEqualToString:msg1]){
                    
                    [DDProgressHUD showCenterWithText:@"该任务已被受理" duration:2.0];
                }
            }
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){

    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];
    
}

@end
