//
//  DDLoginVC.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/4.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDLoginVC.h"

#import "DDHttpRequest.h"

#import "AppDelegate.h"

@interface DDLoginVC ()<UITextFieldDelegate>
{
    UITextField *pwd;
    UITextField *user;
}
@end

@implementation DDLoginVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth*0.3, 64, KScreenWidth*0.4, KScreenWidth*0.4)];
    bgimg.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:bgimg];
    UIImage *image = [UIImage imageNamed:@"background"];
    self.view.layer.contents = (id) image.CGImage;
    
    UIView *loginView=[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(bgimg.frame)+47, KScreenWidth-30, 94)];
    loginView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:loginView];
    loginView.layer.masksToBounds = YES;
    loginView.layer.cornerRadius = 8;
    UIView *lineview1=[[UIView alloc]initWithFrame:CGRectMake(0, 47, loginView.frame.size.width, 1)];
    lineview1.backgroundColor=TableViewBg;
    [loginView addSubview:lineview1];
    WeakSelf
    DDButton *loginbtn=[[DDButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(loginView.frame)+22, KScreenWidth-30, 44) withTitle:@"登录" touchBlock:^(DDButton *btn){
        StrongSelf
        [strongSelf push];
    }];
    [loginbtn setBackgroundColor:UIColorFromRGB(0x2452C3)];
    [self.view addSubview:loginbtn];
    
    DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:18 mycolor:TEXCOLOR myfram:CGRectMake(15, 19, 40, 18) mytext:@"账号"];
    [loginView addSubview:lab1];
    
    DDLabel *lab2=[[DDLabel alloc]initWithAlertViewHeight:18 mycolor:TEXCOLOR myfram:CGRectMake(15, 57, 40, 18) mytext:@"密码"];
    [loginView addSubview:lab2];
    
    user=[self createTextFielfFrame:CGRectMake(60, 19, loginView.frame.size.width-60, 18) font:[UIFont systemFontOfSize:18] placeholder:@"请输入账号即手机号码"];
    user.delegate=self;
    user.keyboardType=UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([DDUserDefault getloginName]) {
        user.text=[DDUserDefault getloginName];
    }
    
    pwd=[self createTextFielfFrame:CGRectMake(60, 57, loginView.frame.size.width-60, 18) font:[UIFont systemFontOfSize:18]  placeholder:@"请输入密码" ];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    pwd.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    pwd.secureTextEntry=YES;
    pwd.delegate=self;
    
    [loginView addSubview:user];
    [loginView addSubview:pwd];
    
}
-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=MAINTEX;
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}
#pragma mark  － ---------textField 代理---------
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])  {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}
-(void)push{
    if ([user.text isEqualToString:@""])
    {
        [DDProgressHUD showCenterWithText:@"请输入账号" duration:2.0];
        return;
    }else if ([pwd.text isEqualToString:@""])
    {
        [DDProgressHUD showCenterWithText:@"请输入密码" duration:2.0];
        return;
    }else{
        [self.view endEditing:YES];
        [DDUserDefault setloginName:user.text];
        [self getNetWorkData];
    }

}

-(void)getNetWorkData
{
    [SVProgressHUD showWithStatus:@"正在登录..."];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"user_name"] = [user.text removeContinueLinefeed];;
    dict[@"password"] = pwd.text;
    [DDHttpRequest postWithUrlString:DDUsersLoginUrlStr parms:[DDHttpRequest handleParametersSHA1:dict] success:^(NSData *requestData, NSDictionary *requestDict,NSInteger statusCode) {
        [SVProgressHUD dismiss];
        /***/
        [DDUserDefault setLogin:YES];
        [DDUserDefault setUserName:user.text];
        [DDUserDefault setPwd:pwd.text];
        [DDUserDefault setLoginforMation:requestDict];
        [DDUserDefault setLoginToken:requestDict[@"token"]];
        /**以上这些是为了保持，民警 和 协警 的老数据逻辑*/
        NSInteger identityType= [[requestDict[@"identity_type_id"] toString] integerValue];
        /**[1=>'管理员',2=>'民警',3=>'协警',4=>'保安',5=>'物业',6=>'房东'];*/
        switch (identityType) {
            case 1://管理员
            {
            }
                break;
            case 2://民警
            {
                [DDUserDefault setJob:YES];
                [DDUserDefault setIdentityType:PoliceAssistantIdentityPoliceType];
                [DDTools sendDeviceToken:[DDUserDefault getDeviceToken]];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(PoliceAssistantIdentityPoliceType)];
            }
                break;
            case 3://协警
            {
                [DDUserDefault setJob:NO];
                [DDUserDefault setIdentityType:PoliceAssistantIdentityPoliceAssistType];
                [DDTools sendDeviceToken:[DDUserDefault getDeviceToken]];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(PoliceAssistantIdentityPoliceAssistType)];
            }
                break;
            case 4://保安
            {
            }
                break;
            case 5://物业
            {
            }
                break;
            case 6://房东
            {
                [DDUserDefault setIdentityType:PoliceAssistantIdentityLandlordType];
                [DDLandlordUserModel refreshUserInfoData:requestDict];
                DDLandlordUserModel * userModel = landlordUserModel;
                userModel.user_name = [user.text removeBlank];
                userModel.isLogin = YES;
                [DDLandlordUserModel saveMySelf];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(PoliceAssistantIdentityLandlordType)];
            }
                break;
            default:
                break;
        }
    } failure:^(NSInteger statusCode, NSError *error,NSString * errorMessage) {
        [SVProgressHUD dismiss];
        
    }];
    /**以前的登录请求逻辑，包含两个角色 民警和协警*/
//    [SVProgressHUD showWithStatus:@"正在登录..."];
//    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
//    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:user.text password:pwd.text];
//    
//    [DDNetManger ba_requestWithType:DDHttpRequestTypePost withUrlString:API_BASE_URL(@"v1/site/login") withParameters:nil withSuccessBlock:^(id response){
//        [SVProgressHUD dismiss];
//        NSDictionary *dict=response;
//        if (dict) {
//            NSDictionary *dic=[dict objectForKey:@"response_params"];
//            NSNumber *msgCode =[dic objectForKey:@"error_code"];
//            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
//            if ([Error_Code_Success isEqualToString:msg]) {
//                
//                [DDUserDefault setLogin:YES];
//                [DDUserDefault setUserName:user.text];
//                [DDUserDefault setPwd:pwd.text];
//                NSArray *arr=dic[@"data"];
//                NSDictionary *dic1=[arr firstObject];
//                [DDUserDefault setLoginforMation:dic1];
//                NSString *type=[NSString stringWithFormat:@"%@",dic1[@"identity_type_id"]];
//                if ([type isEqualToString:@"2"]) {
//                    //登录民警
//                    [DDUserDefault setJob:YES];
//                    [DDUserDefault setIdentityType:PoliceAssistantIdentityPoliceType];
//                    [DDTools sendDeviceToken:[DDUserDefault getDeviceToken]];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(PoliceAssistantIdentityPoliceType)];
//                }else{
//                    //登录协警
//                    [DDUserDefault setJob:NO];
//                    [DDTools sendDeviceToken:[DDUserDefault getDeviceToken]];
//                    [DDUserDefault setIdentityType:PoliceAssistantIdentityPoliceAssistType];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(PoliceAssistantIdentityPoliceAssistType)];
//                }
//                
//            }
//            else if ([Error_Code_Failed isEqualToString:msg]){
//                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
//            }else if ([Error_Code_RequestError isEqualToString:msg]){
//                [DDProgressHUD showCenterWithText:@"网络异常" duration:1.0];
//            }
//        }else{
//        }
//        NSLog(@"post请求数据成功： *** %@", response);
//    }withFailureBlock:^(NSError *error){
//        
//    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
//        
//    }];    
}

#pragma mark  － app代理
-(AppDelegate*)appDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
@end
