//
//  DDAlarmListVC.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/2.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDAlarmListVC.h"
#import "DDHeadView.h"
#import "DDAlarmCell.h"

@interface DDAlarmListVC ()<DDHeadViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIView* headView;
    UITextField *nameTex;//申报人姓名
    UITextField *TypeTex;//处理方式
    UITextField *PoliceTex;//处理人员
    NSString *urlStr;
    NSMutableArray *DataArray;
    BOOL isRefresh;

}
@property (nonatomic , retain) UITableView *EmptytableView;
@property (nonatomic , retain) UITableView *HiostorytableView;
@property(nonatomic,strong)DDEmptyView *empview;
@property (nonatomic, strong) DDTextView * textView;
@end

@implementation DDAlarmListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"报警申报";
    
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"/v1/site/getcallrecordhistory")];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getcallrecordhistory];
    
    DDHeadView *segView=[[DDHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    [self.view addSubview:segView];
    segView.delegate = self;
    segView.titles = @[@"申报登记",@"申报记录"];
    segView.titleFont = sysFont14;
    
    self.EmptytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-108) style:UITableViewStylePlain];
    self.EmptytableView.dataSource = self;
    self.EmptytableView.delegate = self;
    self.EmptytableView.tableFooterView = [UIView new];
    self.EmptytableView.backgroundColor = TableViewBg;
    [self.view addSubview:self.EmptytableView];
    
    self.HiostorytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-157) style:UITableViewStylePlain];
    self.HiostorytableView.dataSource = self;
    self.HiostorytableView.delegate = self;
    self.HiostorytableView.rowHeight=247.5;
    self.HiostorytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.HiostorytableView.tableFooterView = [UIView new];
    self.HiostorytableView.backgroundColor = TableViewBg;
    [self.view addSubview:self.HiostorytableView];
    self.HiostorytableView.hidden=YES;
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    headView.backgroundColor=[UIColor whiteColor];
    self.EmptytableView.tableHeaderView=headView;
    [self creatTableheadview];

    _empview=[[DDEmptyView alloc]init];
    [self uploadAndDownload];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.EmptytableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.EmptytableView.contentInset = UIEdgeInsetsZero;
}
- (void)uploadAndDownload{
    // 下拉刷新
    _HiostorytableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_HiostorytableView.mj_header endRefreshing];
            NSLog(@"22222222222");
        });
        
        [self getcallrecordhistory];
    }];
//    _HiostorytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [_HiostorytableView.mj_footer endRefreshing];
//            NSLog(@"上4444444444");
//        });
//        NSLog(@"上33333333333333");
//    }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - headVIew
- (void)creatTableheadview{
    UIView *hview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 15)];
    hview.backgroundColor=TableViewBg;
    [headView addSubview:hview];
    
    nameTex=[[UITextField alloc]init];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [self setupOneTextfield:nameTex WithFrame:CGRectMake(15, CGRectGetMaxY(hview.frame)+15, KScreenWidth-30, 50) placeholder:@"请输入姓名" keyboardType:UIKeyboardTypeDefault leftView:view1 typeString:@"申报人姓名"];
    [headView addSubview:nameTex];
    
    TypeTex=[[UITextField alloc]init];
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [self setupOneTextfield:TypeTex WithFrame:CGRectMake(15, CGRectGetMaxY(nameTex.frame)+15, KScreenWidth-30, 50) placeholder:@"请输入申报人电话" keyboardType:UIKeyboardTypeDefault leftView:view2 typeString:@"申报人电话"];
    TypeTex.keyboardType=UIKeyboardTypeNumberPad;
    [headView addSubview:TypeTex];
    
    PoliceTex=[[UITextField alloc]init];
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [self setupOneTextfield:PoliceTex WithFrame:CGRectMake(15, CGRectGetMaxY(TypeTex.frame)+15, KScreenWidth-30, 50) placeholder:@"请输入申报地址" keyboardType:UIKeyboardTypeDefault leftView:view3 typeString:@"申报人地址"];
    [headView addSubview:PoliceTex];
    
    _textView = [[DDTextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(PoliceTex.frame)+15, KScreenWidth-30, 123)];
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
    _textView.placeholder = @"申报事由(50字之内)";
    _textView.returnKeyType=UIReturnKeyDone;
    [headView addSubview:_textView];
    DDButton *loginbtn=[[DDButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_textView.frame)+30, KScreenWidth-30, 42) withTitle:@"提交申报" touchBlock:^(DDButton *btn){
        [self sendToSerce];
    }];
    [headView addSubview:loginbtn];
    
}

- (void)sendToSerce{
    NSLog(@"提交到服务器");
    if ([nameTex.text isEqualToString:@""]||[DDTools isEmpty:nameTex.text])
    {
        [DDProgressHUD showCenterWithText:@"请输入申报人姓名！" duration:1.0];
        return;
    }else if (nameTex.text.length>15||nameTex.text.length<2)
    {
        [DDProgressHUD showCenterWithText:@"申报人姓名(2-15字之间)！" duration:1.0];
        return;
    }else if ([TypeTex.text isEqualToString:@""])
    {
        [DDProgressHUD showCenterWithText:@"请输入申报人电话！" duration:1.0];
        return;
    }else if ([DDTools validatePhone:TypeTex.text]==NO)
    {
        [DDProgressHUD showCenterWithText:@"申报人电话号码格式不对！" duration:1.0];
        return;
    }
    else if ([PoliceTex.text isEqualToString:@""]||[DDTools isEmpty:PoliceTex.text])
    {
        [DDProgressHUD showCenterWithText:@"请输入申报人地址！" duration:1.0];
        return;
    }
    else if ([_textView.text isEqualToString:@""]||[DDTools isEmpty:_textView.text])
    {
        [DDProgressHUD showCenterWithText:@"请输入申报事由！" duration:1.0];
        return;
    }else if (_textView.text.length>50)
    {
        [DDProgressHUD showCenterWithText:@"申报事由内容超过50个字" duration:1.0];
        return;
    }else{
        [self getNetWorkData];
    }
}
- (void)setupOneTextfield:(UITextField *)text WithFrame:(CGRect)frame placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType leftView:(UIView *)view typeString:(NSString *)sting {
    //初始化textfield并设置位置及大小
    text.frame=frame;
    //设置边框样式，只有设置了才会显示边框样式
    text.borderStyle = UITextBorderStyleRoundedRect;
    //设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉
    text.backgroundColor = [UIColor whiteColor];
    //当输入框没有内容时，水印提示 提示内容为password
    text.placeholder = placeholder;
    //设置输入框内容的字体样式和大小
    text.font = sysFont16;
    //设置字体颜色
    text.textColor = MAINTEX;
    //边角线宽
    text.layer.borderWidth = 0.5;
    //倒角
    text.layer.cornerRadius = 5;
    //内容对齐方式
    text.textAlignment = NSTextAlignmentLeft;
    //设置键盘的样式
    text.keyboardType = keyboardType;
    //return键变成什么键
    text.returnKeyType =UIReturnKeyDone;
    //边框颜色
    text.layer.borderColor = [LINECOLOR CGColor];
    //再次编辑就清空
    text.clearButtonMode = UITextFieldViewModeAlways;
    //设置代理 用于实现协议
    view.backgroundColor=[UIColor whiteColor];
    UILabel *lab=[[UILabel alloc]initWithFrame:view.frame];
    lab.text=sting;
    lab.textColor=MAINTEX;
    [view addSubview:lab];
    lab.font=sysFont16;
    text.leftView=view;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.delegate = self;
    
}
#pragma mark  － ---------textField 代理---------
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])  {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    
    return YES;
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}


#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.HiostorytableView) {
        if (!DataArray.count) {
            [_empview showCenterWithSuperView:self.HiostorytableView icon:@"empty_fancy" state:@"暂无相关数据"];
            return 0;
        }else{
            [_empview removeFromSuperview];
            return [DataArray count];
        }
    }else{
        return 0;
    }
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.HiostorytableView) {
        static NSString *his=@"cellhistory";
        DDAlarmCell *cell=[tableView dequeueReusableCellWithIdentifier:his];
        if (cell==nil) {
            cell=[[DDAlarmCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:his];
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        cell.backgroundColor=TableViewBg;
        NSDictionary *dic=[DataArray objectAtIndex:indexPath.row];
        [cell adddic:dic];
        return cell;
        
    }else{
        static NSString *ID=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        return cell;
    }
    return nil;
    
}

-(void)segmentView:(DDHeadView *)segmentView didSelectIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    switch (index) {
        case 0:
            self.EmptytableView.hidden=NO;
            self.HiostorytableView.hidden=YES;
            break;
            
        case 1:
            self.EmptytableView.hidden=YES;
            self.HiostorytableView.hidden=NO;
            if (isRefresh) {
                [self.HiostorytableView.mj_header beginRefreshing];
                isRefresh=NO;
            }
            [self.view endEditing:YES];
            break;
        default:
            break;
    }
}
#pragma mark - 提交申报
- (void)getNetWorkData{
    [SVProgressHUD showWithStatus:@"正在申报..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    
    NSString *url =[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/callrecord")];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:nameTex.text,@"name",TypeTex.text,@"phone",PoliceTex.text,@"address",_textView.text,@"reason",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:url withParameters:dicts withSuccessBlock:^(id response) {
        [SVProgressHUD dismiss];
        /*! 新增get请求缓存，飞行模式下开启试试看！ */
        NSLog(@"get请求数据成功： *** %@", response);
        NSDictionary *dict = response;
        NSDictionary *response_params=[dict objectForKey:@"response_params"];
        NSString *code=[NSString stringWithFormat:@"%@",[response_params objectForKey:@"error_code"]];
        if ([Error_Code_Success isEqualToString:code]) {
            [DDProgressHUD showCenterWithText:@"上报成功" duration:2.0];
            isRefresh=YES;
            nameTex.text=@"";
            TypeTex.text=@"";
            PoliceTex.text=@"";
            _textView.text=@"";
            [[NSNotificationCenter defaultCenter]postNotificationName:UITextViewTextDidChangeNotification object:_textView.text];
            NSLog(@"++++++%@",code);
            
        }
        else if ([Error_Code_Failed isEqualToString:code]){
            [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
        }else if ([Error_Code_RequestError isEqualToString:code]){
            [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
        }

        
    } withFailureBlock:^(NSError *error) {

    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];

}
#pragma mark -报警申报登记历史记录
- (void)getcallrecordhistory{
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
                [self.HiostorytableView reloadData];
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
