//
//  DDChangePwdViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/1.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDChangePwdViewController.h"
#import "DDLoginVC.h"

@interface DDChangePwdViewController ()<UITextFieldDelegate>
{
    UITextField *OldPwd;
    UITextField *NewPwd;
    UITextField *NewPwdAgin;
}


@end

@implementation DDChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"修改密码";
    self.navigationController.navigationBarHidden = NO;
    OldPwd=[[UITextField alloc]init];
    NewPwd=[[UITextField alloc]init];
    NewPwdAgin=[[UITextField alloc]init];
    
    [self setupOneChildVC:OldPwd WithFrame:CGRectMake(0, 15, KScreenWidth, 50) borderStyle:UITextBorderStyleRoundedRect backgroundColor:[UIColor whiteColor] background:nil withTitle:nil textColor:MAINTEX borderWidth:0 cornerRadius:0 returnKeyType:UIReturnKeyDefault placeholder:@"请输入旧密码" font:[UIFont systemFontOfSize:18] clearButtonMode:UITextFieldViewModeWhileEditing textAlignment:NSTextAlignmentLeft keyboardType:UIKeyboardTypeDefault];
    
    [self setupOneChildVC:NewPwd WithFrame:CGRectMake(0, 65,  KScreenWidth-0, 50) borderStyle:UITextBorderStyleRoundedRect backgroundColor:[UIColor whiteColor] background:nil withTitle:nil textColor:MAINTEX borderWidth:0 cornerRadius:0 returnKeyType:UIReturnKeyDefault placeholder:@"请输入新密码" font:[UIFont systemFontOfSize:18] clearButtonMode:UITextFieldViewModeWhileEditing textAlignment:NSTextAlignmentLeft keyboardType:UIKeyboardTypeDefault];
    
    [self setupOneChildVC:NewPwdAgin WithFrame:CGRectMake(0, 115,  KScreenWidth-0, 50) borderStyle:UITextBorderStyleRoundedRect backgroundColor:[UIColor whiteColor] background:nil withTitle:nil textColor:MAINTEX borderWidth:0 cornerRadius:0 returnKeyType:UIReturnKeyDefault placeholder:@"请确认新密码" font:[UIFont systemFontOfSize:18] clearButtonMode:UITextFieldViewModeWhileEditing textAlignment:NSTextAlignmentLeft keyboardType:UIKeyboardTypeDefault];
    DDButton *button=[[DDButton alloc]initWithFrame:CGRectMake(15, 180,  KScreenWidth-30, 40) withTitle:@"确认修改" touchBlock:^(DDButton *btn){
        [self checkIsSuccess];
    }];
    [self.view addSubview:button];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 65, KScreenWidth, 1)];
    line1.backgroundColor=LINECOLOR;
    [self.view addSubview:line1];
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 115, KScreenWidth, 1)];
    line2.backgroundColor=LINECOLOR;
    [self.view addSubview:line2];
}

- (void)checkIsSuccess{
    if (OldPwd.text.length==0) {
        [DDProgressHUD showCenterWithText:@"请输入旧密码" duration:1.0];
        return;
    }else if (![OldPwd.text isEqualToString:[DDUserDefault getPwd]]){
        [DDProgressHUD showCenterWithText:@"原密码错误,请重新输入" duration:1.0];
        return;
    }else if (NewPwd.text.length==0){
        [DDProgressHUD showCenterWithText:@"请输入新密码" duration:1.0];
        return;
    }else if ([DDTools validateStrWithRange:@"{6,12}" str:NewPwd.text]==NO){
        [DDProgressHUD showCenterWithText:@"密码输入格式为6到12位的数字加字母组合" duration:1.0];
        return;
    }else if (NewPwdAgin.text.length==0){
        [DDProgressHUD showCenterWithText:@"请确认新密码" duration:1.0];
        return;
    }else if (![NewPwd.text isEqualToString:NewPwdAgin.text]){
        [DDProgressHUD showCenterWithText:@"新密码输入不一致,请核对后再次输入" duration:1.0];
        return;
    }else if ([NewPwd.text isEqualToString:OldPwd.text]){
        [DDProgressHUD showCenterWithText:@"新旧密码一致,无法更改" duration:1.0];
        return;
    }else{
        [self getNetWorkData];
    }
}
- (void)getNetWorkData{
    [SVProgressHUD showWithStatus:@"正在修改..."];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSString *url =[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/changepasswd")];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:NewPwd.text,@"password",OldPwd.text,@"oldpassword",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:url withParameters:dicts withSuccessBlock:^(id response) {
        [SVProgressHUD dismiss];
        /*! 新增get请求缓存，飞行模式下开启试试看！ */
        NSLog(@"get请求数据成功： *** %@", response);
        NSDictionary *dict = response;
        NSDictionary *response_params=[dict objectForKey:@"response_params"];
        NSString *code=[NSString stringWithFormat:@"%@",[response_params objectForKey:@"error_code"]];
        if ([Error_Code_Success isEqualToString:code]) {
          //  [DDProgressHUD showCenterWithText:@"请使用新密码重新登录" duration:3.0];
            [DDAlertView initWithTitle:@"提示" message:@"修改成功,请使用新密码重新登录!" cancleButtonTitle:nil OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonAtIndex) {
                NSLog(@"click index ====%ld",(long)buttonAtIndex);
                if (buttonAtIndex == 0) {
                    [DDUserDefault setLogin:NO];
//                    DDLoginVC *vc=[[DDLoginVC alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
                    [self sendDeviceToken:@""];
                }
            }];
        }
        else if ([Error_Code_Failed isEqualToString:code]){
            [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
        }else if ([Error_Code_RequestError isEqualToString:code]){
            [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
        }else if ([Error_Code_ChangeError isEqualToString:code]){
            [DDProgressHUD showCenterWithText:@"原始密码错误" duration:2.0];
        }

        
        

    } withFailureBlock:^(NSError *error) {

    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}
- (void)sendDeviceToken:(NSString*)device_token{
    [SVProgressHUD showWithStatus:@"正在退出..."];
    NSString *urlStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/getiosdevicetoken")];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:device_token,@"devicetoken",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:urlStr withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                [SVProgressHUD dismiss];
                DDLoginVC *vc=[[DDLoginVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }
            else if ([@"20003" isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"更改密码失败" duration:2.0];
            }else if ([Error_Code_RequestError isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }
            
        }else{
            
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){
        [SVProgressHUD dismiss];
        //  [DDProgressHUD showCenterWithText:@"网络异常" duration:2.0];
    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];
    
}

-(void)setupOneChildVC:(UITextField *)text WithFrame:(CGRect)frame borderStyle:(UITextBorderStyle)borderStyle  backgroundColor:(UIColor *)backgroundColor background:(NSString *)background withTitle:(NSString *)title  textColor:(UIColor *)textColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius returnKeyType:(UIReturnKeyType)returnKeyType placeholder:(NSString *)placeholder font:(UIFont*)font clearButtonMode:(UITextFieldViewMode)clearButtonMode textAlignment:(NSTextAlignment)textAlignment keyboardType:(UIKeyboardType)keyboardType{
    
    // text=[[UITextField alloc]init];
    //初始化textfield并设置位置及大小
    text.frame=frame;
    
    //设置边框样式，只有设置了才会显示边框样式
  //  text.borderStyle = borderStyle;
    
    //设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉
    text.backgroundColor = backgroundColor;
    
    //设置背景
    text.background = [UIImage imageNamed:background];
    
    //设置text的内容
    text.text=title;
    
    //当输入框没有内容时，水印提示 提示内容为password
    text.placeholder = placeholder;
    
    //设置输入框内容的字体样式和大小
    text.font = font;
    
    
    //设置字体颜色
    text.textColor = textColor;
    //边角线宽
    text.layer.borderWidth = borderWidth;
    
    //倒角
    text.layer.cornerRadius = cornerRadius;
    //内容对齐方式
    
    text.textAlignment = textAlignment;
    
    //return键变成什么键
    
    text.returnKeyType =returnKeyType;
    
    //设置键盘的样式
    
    text.keyboardType = keyboardType;
    
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    
    text.clearButtonMode = clearButtonMode;
    
    //边框颜色
   // text.layer.borderColor = [[UIColor colorWithRed:0 green:188/255.0 blue:236/255.0 alpha:1] CGColor];
    //每输入一个字符就变成点 用语密码输入
    text.secureTextEntry = NO;
    
    //设置代理 用于实现协议
    
    text.delegate = self;
    
    //把textfield加到视图中
    
    [self.view addSubview:text];
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

@end
