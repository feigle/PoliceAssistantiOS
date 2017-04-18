//
//  DDPersonCheckVC.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/2.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDPersonCheckVC.h"
#import "MHDatePicker.h"
#import "DDChooseUnitVC.h"
@interface DDPersonCheckVC ()
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIView* headView;
    UITextField *nameTex;
    UITextField *cardTex;
    UITextField *famliyTex;
    UITextField *birthTex;
    UILabel *peopleCountLab;
    UILabel *birthLab,*UnitRoomNo;
    UILabel *nowLab;
    UIButton *_preBtn;//当前的状态
    int payType;
    NSString *sexStr,*room_id,*new_address,*addree_room;
    UIView *view12;
}
@property (nonatomic , retain) UITableView *tableView;
@property (strong, nonatomic) MHDatePicker *selectDatePicker;
@property (nonatomic, strong) DDTextView * OldAddressTv;
@end

@implementation DDPersonCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"人员登记";
    self.view.backgroundColor=TableViewBg;
    [self Getcallrecordhistory];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TableViewBg;
    [self.view addSubview:self.tableView];
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 790)];
    headView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView=headView;
    [self creatTableheadview];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLabelText:) name:@"addressNotification" object:nil];

}
- (void)showLabelText:(NSNotification *)notification
{
    //第三,实现通知中心内部的方法,并实现传值
    NSString * text = notification.object;
    _address = text;
    NSArray *b = [_address componentsSeparatedByString:@"-"];
    NSString *a0 = [b objectAtIndex:1];
    NSString *a1 = [b objectAtIndex:1];
    NSString *a2 = [b objectAtIndex:2];
    NSString *a3 = [b objectAtIndex:3];
    room_id=[b objectAtIndex:4];
    addree_room=[NSString stringWithFormat:@"%@%@%@",a1,a2,a3];
    new_address=[NSString stringWithFormat:@"%@%@%@%@",a0,a1,a2,a3];
    UnitRoomNo.text=addree_room;
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
#pragma mark - headVIew
- (void)creatTableheadview{
    UIView *hview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 35)];
    hview.backgroundColor=TableViewBg;
    [headView addSubview:hview];
    
    DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(15, 10, KScreenWidth-30, 20) mytext:@"基本信息"];
    [hview addSubview:lab1];
    
    nameTex=[[UITextField alloc]init];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 50, 50)];
    [self setupOneTextfield:nameTex WithFrame:CGRectMake(15, CGRectGetMaxY(hview.frame)+7.5, KScreenWidth-30, 44) placeholder:@"" keyboardType:UIKeyboardTypeDefault leftView:view1 typeString:@"姓名"];
    [headView addSubview:nameTex];
    
    cardTex=[[UITextField alloc]init];
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 80, 50)];
    [self setupOneTextfield:cardTex WithFrame:CGRectMake(15, CGRectGetMaxY(nameTex.frame)+15, KScreenWidth-30, 44) placeholder:@"" keyboardType:UIKeyboardTypeNumberPad leftView:view2 typeString:@"身份证号"];
    [headView addSubview:cardTex];
    
    famliyTex=[[UITextField alloc]init];
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 50, 50)];
    [self setupOneTextfield:famliyTex WithFrame:CGRectMake(15, CGRectGetMaxY(cardTex.frame)+15, KScreenWidth-30, 44) placeholder:@"" keyboardType:UIKeyboardTypeDefault leftView:view3 typeString:@"民族"];
    [headView addSubview:famliyTex];
    
    UIView *mview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(famliyTex.frame), KScreenWidth, 60)];
    [headView addSubview:mview];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(75, 0, 60, 60)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"choose_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"choose_height"] forState:UIControlStateSelected];
    [button setTitle:@"男" forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0,-12,0,0);
    [button setTitleColor:TEXCOLOR forState:UIControlStateNormal];
    [button setTitleColor:MAINTEX forState:UIControlStateSelected];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    button.tag=1003;
    [mview addSubview:button];
    
    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(160, 0, 60, 60)];
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setImage:[UIImage imageNamed:@"choose_normal"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"choose_height"] forState:UIControlStateSelected];
    [button1 setTitle:@"女" forState:UIControlStateNormal];
    button1.imageEdgeInsets = UIEdgeInsetsMake(0,-12,0,0);
    [button1 setTitleColor:TEXCOLOR forState:UIControlStateNormal];
    [button1 setTitleColor:MAINTEX forState:UIControlStateSelected];
    button1.titleLabel.font=[UIFont systemFontOfSize:16];
    button1.tag=1002;
    [mview addSubview:button1];
    DDLabel *lab21=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(25, 20, 50, 20) mytext:@"性别"];
    [mview addSubview:lab21];
    
    UIView *birView=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(mview.frame), KScreenWidth-30, 44)];
    birView.layer.borderWidth = 0.5;
    //倒角
    birView.layer.cornerRadius = 5;
    birView.layer.borderColor = [LINECOLOR CGColor];
    [headView addSubview:birView];
    DDLabel *lab100=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(10, 0, 80, 44) mytext:@"出生日期"];
    [birView addSubview:lab100];
    DDLabel *lab101=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(85, 0, KScreenWidth-90, 44) mytext:@""];
    birthLab=lab101;
    [birView addSubview:lab101];
    UIButton *btn1=[[UIButton alloc]init];
    btn1.frame=CGRectMake(15, 0, KScreenWidth-30, 44);
    [birView addSubview:btn1];
    btn1.tag=1000;
    [btn1 addTarget:self action:@selector(choosedate:) forControlEvents:UIControlEventTouchUpInside];
    
    _OldAddressTv = [[DDTextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(birView.frame)+15, KScreenWidth-30, 67)];
    _OldAddressTv.backgroundColor = [UIColor whiteColor];
    _OldAddressTv.delegate = self;
    _OldAddressTv.font = [UIFont systemFontOfSize:16.f];
    _OldAddressTv.textColor = MAINTEX;
    _OldAddressTv.textAlignment = NSTextAlignmentLeft;
    _OldAddressTv.editable = YES;
    _OldAddressTv.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    _OldAddressTv.layer.cornerRadius = 5.0f;
    _OldAddressTv.layer.borderColor = LINECOLOR.CGColor;
    _OldAddressTv.layer.borderWidth = 0.5;
    _OldAddressTv.placeholderColor = TEXCOLOR;
    _OldAddressTv.placeholder = @"户籍地址";
    _OldAddressTv.returnKeyType=UIReturnKeyDone;
    [headView addSubview:_OldAddressTv];
    
    
    UIView *xview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_OldAddressTv.frame)+15, KScreenWidth, 35)];
    xview.backgroundColor=TableViewBg;
    [headView addSubview:xview];
    
    DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:TEXCOLOR myfram:CGRectMake(15, 10, KScreenWidth-30, 20) mytext:@"居住信息"];
    [xview addSubview:lab2];
    
    
    UIView *view11=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(xview.frame)+15, KScreenWidth-30, 44)];
    view11.layer.borderWidth = 0.5;
    view11.layer.cornerRadius = 5;
    view11.backgroundColor=TableViewBg;
    view11.layer.borderColor = [LINECOLOR CGColor];
    [headView addSubview:view11];
    DDLabel *lab99=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(10, 0, 80, 44) mytext:@"现居住地"];
    [view11 addSubview:lab99];
    DDLabel *lab89=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(85, 0, KScreenWidth-90, 44) mytext:_comstring];
    [view11 addSubview:lab89];
    
    view12=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(view11.frame)+15, KScreenWidth-30, 44)];
    view12.layer.borderWidth = 0.5;
    view12.layer.cornerRadius = 5;
    view12.layer.borderColor = [LINECOLOR CGColor];
    view12.userInteractionEnabled=YES;
    [headView addSubview:view12];
    DDLabel *lab199=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(10, 0, 80, 44) mytext:@"楼栋房号"];
    [view12 addSubview:lab199];
    //    DDLabel *lab189=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(85, 0, KScreenWidth-90, 44) mytext:_address];
    //    UnitRoomNo=lab189;
    //    [view12 addSubview:UnitRoomNo];
    
    DDLabel *lab189=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(85, 0, KScreenWidth-90, 44) mytext:@""];
    UnitRoomNo=lab189;
    [view12 addSubview:UnitRoomNo];
    
    UITapGestureRecognizer *tapin=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushtochoosUnitandRoom)];
    [view12 addGestureRecognizer:tapin];
    
    
    UIView *birView1=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(view12.frame)+15, KScreenWidth-30, 44)];
    birView1.layer.borderWidth = 0.5;
    //倒角
    birView1.layer.cornerRadius = 5;
    birView1.layer.borderColor = [LINECOLOR CGColor];
    [headView addSubview:birView1];
    DDLabel *lab1001=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:TEXCOLOR myfram:CGRectMake(10, 0, 80, 44) mytext:@"入住时间"];
    [birView1 addSubview:lab1001];
    DDLabel *lab102=[[DDLabel alloc]initWithAlertViewHeight:16 mycolor:MAINTEX myfram:CGRectMake(85, 0, KScreenWidth-90, 44) mytext:@""];
    nowLab=lab102;
    [birView1 addSubview:lab102];
    UIButton *btn11=[[UIButton alloc]init];
    btn11.frame=CGRectMake(15, 0, KScreenWidth-30, 44);
    [birView1 addSubview:btn11];
    btn11.tag=1001;
    [btn11 addTarget:self action:@selector(choosedate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *xxview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(birView1.frame)+15, KScreenWidth, 170)];
    xxview.backgroundColor=TableViewBg;
    [headView addSubview:xxview];
    
    peopleCountLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, KScreenWidth, 20)];
    peopleCountLab.font=sysFont14;
    peopleCountLab.textColor=TEXCOLOR;
    [xxview addSubview:peopleCountLab];
    peopleCountLab.textAlignment=NSTextAlignmentCenter;
//    NSString *content =@"您一共完成了1503份人员数据的登记工作";
//    peopleCountLab.attributedText=[DDTools ChangColorWithNumbers:content WithTextColor:RGB(255, 150, 0) WithTextFont:14];
    
    DDButton *loginbtn=[[DDButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(peopleCountLab.frame)+22, KScreenWidth-30, 42) withTitle:@"提  交" touchBlock:^(DDButton *btn){
        [self sendToSerce];
    }];
    [xxview addSubview:loginbtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UnitRoomNo.text=addree_room;
}
- (void)choosedate:(UIButton*)sender{
    [self.view endEditing:YES];
    _selectDatePicker = [[MHDatePicker alloc] init];
    _selectDatePicker.isBeforeTime = YES;
    _selectDatePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *today = [[NSDate alloc] init];
    [_selectDatePicker setMaxSelectDate:today];
    birthTex.inputView=_selectDatePicker;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        if (sender.tag==1000) {
            birthLab.text = [self dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
        }else{
            nowLab.text = [self dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
        }
        
    }];
}
- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}
- (void)buttonAction:(UIButton*)sender{
    _preBtn.selected = NO;
    sender.selected = YES;
    _preBtn = sender;
    payType=(int)sender.tag-1002;
    sexStr=[NSString stringWithFormat:@"%d",payType];
    NSLog(@"-0-0-0-0-%d",payType);
}
- (void)sendToSerce{
    if ([nameTex.text isEqualToString:@""]||[DDTools isEmpty:nameTex.text]) {
        [DDProgressHUD showCenterWithText:@"请输入姓名！" duration:1.0];
        return;
    }else if (nameTex.text.length>15){
        [DDProgressHUD showCenterWithText:@"名字超过15个字！" duration:1.0];
        return;
    }else if ([cardTex.text isEqualToString:@""]){
        [DDProgressHUD showCenterWithText:@"请输入身份证号！" duration:1.0];
        return;
    }else if ([DDTools validateIDCardNumber:cardTex.text]==NO){
        [DDProgressHUD showCenterWithText:@"身份证号格式不正确！" duration:1.0];
        return;
    }else if ([famliyTex.text isEqualToString:@""]||[DDTools isEmpty:famliyTex.text]){
        [DDProgressHUD showCenterWithText:@"请输入民族！" duration:1.0];
        return;
    }else if (!sexStr){
        [DDProgressHUD showCenterWithText:@"请选择性别！" duration:1.0];
        return;
    }else if ([birthLab.text isEqualToString:@""]){
        [DDProgressHUD showCenterWithText:@"请选择出生日期！" duration:1.0];
        return;
    }else if ([_OldAddressTv.text isEqualToString:@""]||[DDTools isEmpty:_OldAddressTv.text]){
        [DDProgressHUD showCenterWithText:@"请输入户籍地址！" duration:1.0];
        return;
    }else if (room_id==nil){
        [DDProgressHUD showCenterWithText:@"请选择楼栋房号！" duration:1.0];
        return;
    }else if ([nowLab.text isEqualToString:@""]){
        [DDProgressHUD showCenterWithText:@"请选择入住时间！" duration:1.0];
        return;
    }else{
        [self getNetWorkData];
        NSLog(@"提交到服务器");
        
    }

}
-(void)pushtochoosUnitandRoom{
    
    DDChooseUnitVC *vc=[[DDChooseUnitVC alloc]init];
    vc.comstring=_comstring;
    vc.type_id=_type_id;
    [self.navigationController pushViewController:vc animated:YES];
    
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
    lab.textColor=TEXCOLOR;
    [view addSubview:lab];
    lab.font=sysFont16;
    text.leftView=view;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.delegate = self;
    
}
- (void)setupOneTextView:(UITextView *)textview WithFrame :(CGRect)frame string:(NSString *)string{
    textview.frame=frame;
    textview.backgroundColor=[UIColor whiteColor]; //背景色
    textview.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    textview.editable = YES;        //是否允许编辑内容，默认为“YES”
    
    textview.delegate = self;       //设置代理方法的实现类
    textview.font=[UIFont fontWithName:@"Arial" size:16.0]; //设置字体名字和字体大小;
    textview.returnKeyType = UIReturnKeyDefault;//return键的类型
    textview.layer.borderWidth = 0.5;
    //倒角
    textview.layer.cornerRadius = 5;
    textview.layer.borderColor = [LINECOLOR CGColor];
    textview.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    
    textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    
    textview.textColor = MAINTEX;
    
    textview.text = [NSString stringWithFormat:@"  %@  ",string];//设置显示的文本内容
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
    [headView endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
/**
 *  提交一个人员登记
 */
- (void)getNetWorkData{
    
    [SVProgressHUD showWithStatus:@"正在提交..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    
    NSString *url =[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/peopleregister")];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:nameTex.text,@"name",sexStr,@"sex",famliyTex.text,@"nation",cardTex.text,@"idnum",birthLab.text,@"birthday",_OldAddressTv.text,@"address",nowLab.text,@"intime",room_id,@"roomid",new_address,@"nowaddress",nil];

    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:url withParameters:dicts withSuccessBlock:^(id response) {
        [SVProgressHUD dismiss];
        /*! 新增get请求缓存，飞行模式下开启试试看！ */
        NSLog(@"get请求数据成功： *** %@", response);
        NSDictionary *dict = response;
        NSDictionary *response_params=[dict objectForKey:@"response_params"];
        NSString *code=[NSString stringWithFormat:@"%@",[response_params objectForKey:@"error_code"]];
        if ([Error_Code_Success isEqualToString:code]) {
            [DDProgressHUD showCenterWithText:@"提交成功" duration:2.0];
            nameTex.text=@"";
            famliyTex.text=@"";
            cardTex.text=@"";
            birthLab.text=@"";
            _OldAddressTv.text=@"";
            nowLab.text=@"";
            _preBtn.selected=NO;
            sexStr=nil;
            [[NSNotificationCenter defaultCenter]postNotificationName:UITextViewTextDidChangeNotification object:_OldAddressTv.text];
            [self Getcallrecordhistory];
            NSLog(@"++++++%@",code);
            
        }
        else if ([Error_Code_Failed isEqualToString:code]){
            [DDProgressHUD showCenterWithText:@"账号密码错误" duration:1.0];
        }else if ([@"20009" isEqualToString:code]){
            [DDProgressHUD showCenterWithText:@"该用户已经登记过了" duration:1.0];
        }
        
        
    } withFailureBlock:^(NSError *error) {

    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];

}
/**
 *  获取登记人数
 */
- (void)Getcallrecordhistory{
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSString *url =[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/initpeopleregister")];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:url withParameters:nil withSuccessBlock:^(id response) {
        [SVProgressHUD dismiss];
        /*! 新增get请求缓存，飞行模式下开启试试看！ */
        NSLog(@"get请求数据成功： *** %@", response);
        NSDictionary *dict = response;
        NSDictionary *response_params=[dict objectForKey:@"response_params"];
        NSString *code=[NSString stringWithFormat:@"%@",[response_params objectForKey:@"error_code"]];
        if ([Error_Code_Success isEqualToString:code]) {
            NSArray *arr1=[response_params objectForKey:@"data"];
            NSDictionary *dic1=[arr1 firstObject];
            NSString *str1=[NSString stringWithFormat:@"您一共完成了%@份人员数据的登记工作",dic1[@"registercount"]];
            peopleCountLab.attributedText=[DDTools ChangColorWithNumbers:str1 WithTextColor:RGB(255, 150, 0) WithTextFont:14];
        }
        else if ([Error_Code_Failed isEqualToString:code]){
            [DDProgressHUD showCenterWithText:@"账号密码错误" duration:1.0];
        }else if ([Error_Code_RequestError isEqualToString:code]){
            [DDProgressHUD showCenterWithText:@"账号密码错误" duration:1.0];
        }
        
        
    } withFailureBlock:^(NSError *error) {
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}

@end
