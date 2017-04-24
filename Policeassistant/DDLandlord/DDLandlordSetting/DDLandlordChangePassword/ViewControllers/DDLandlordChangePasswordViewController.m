//
//  DDLandlordChangePasswordViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordChangePasswordViewController.h"

@interface DDLandlordChangePasswordViewController ()<UITextFieldDelegate>

/**输入内容的地方，背景view*/
@property (nonatomic,strong) UIView * contentBgView;

/**旧密码*/
@property (nonatomic,strong) UITextField * oldPasswordTextField;
/**新密码*/
@property (nonatomic,strong) UITextField * nnewPasswordTextField;
/**确认新密码*/
@property (nonatomic,strong) UITextField * confirmNnewPasswordTextField;
/**确认修改密码按钮*/
@property (nonatomic,strong) UIButton * confirmChangeButton;

@end

@implementation DDLandlordChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self configUI];
}
#pragma mark - 点击事件处理
#pragma mark - 确认修改点击事件
- (void)confirmChangeButtonClicked
{
    if (self.oldPasswordTextField.text.length == 0) {
        [DDProgressHUD showCenterWithText:@"请输入旧密码。" duration:1.5];
        return;
    }
    if (self.nnewPasswordTextField.text.length == 0) {
        [DDProgressHUD showCenterWithText:@"请输入新密码。" duration:1.5];
        return;
    }
    if (self.confirmNnewPasswordTextField.text.length == 0) {
        [DDProgressHUD showCenterWithText:@"请输入确认新密码。" duration:1.5];
        return;
    }
    if (![self.nnewPasswordTextField.text isEqualToString:self.confirmNnewPasswordTextField.text]) {
        [DDProgressHUD showCenterWithText:@"新密码输入不一致，请核对后再次输入。" duration:1.5];
        NSLog(@"新旧密码不一致");
        return;
    }
    if (![self.nnewPasswordTextField.text verifyNumbersAndLettersCombinationPasswordSixToTwelve]) {
        [DDProgressHUD showCenterWithText:@"密码输入格式为6到12位的数字加字母组合。" duration:1.5];
        return;
    }
    if ([self.nnewPasswordTextField.text isEqualToString:self.oldPasswordTextField.text]) {
        [DDProgressHUD showCenterWithText:@"新密码与旧密码重复，请重新输入。" duration:1.5];
        return;
    }
    [self.view endEditing:YES];
    DDLandlordUserModel * landlordModel = landlordUserModel;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"user_name"] = [landlordModel.real_name toString];
    dict[@"user_id"] = [landlordModel.user_id toString];
    dict[@"old_password"] = self.oldPasswordTextField.text;
    dict[@"new_password"] = self.nnewPasswordTextField.text;
    dict[@"confirm_password"] = self.confirmNnewPasswordTextField.text;
    dict[@"token"] = landlordModel.token;
    [SVProgressHUD showWithStatus:@"修改密码中..."];
    [self putWithUrlString:DDLandlordUsersPasswordsUrlStr parms:dict success:^(NSData *requestData, NSDictionary *requestDict, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        [DDUserDefault setLogin:NO];
        [DDUserDefault setIdentityType:PoliceAssistantNoLoginType];
        [DDLandlordUserModel deleteMyself];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(PoliceAssistantNoLoginType)];
    } failure:^(NSInteger statusCode, NSError *error, NSString *errorMessage) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 界面的布局
- (void)configUI
{
    self.view.backgroundColor = ColorHex(@"#EFEFF4");
    [self.view addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.oldPasswordTextField];
    [self.contentBgView addSubview:self.nnewPasswordTextField];
    [self.contentBgView addSubview:self.confirmNnewPasswordTextField];
    UIButton * oldPasswordBtn = [ControlManager buttonNormalImage:@"commonPasswordHideImage" selectImageName:@"commonPasswordShowImage" frame:CGRectMake6(0, 0, 20, 20) target:nil selector:nil];
    oldPasswordBtn.left = self.oldPasswordTextField.right;
    oldPasswordBtn.centerY = self.oldPasswordTextField.centerY;
    WeakSelf
    [oldPasswordBtn addClickedHandle:^(UIButton *sender) {
        StrongSelf
        sender.selected = !sender.selected;
        strongSelf.oldPasswordTextField.secureTextEntry = !sender.selected;
    }];
    [self.contentBgView addSubview:oldPasswordBtn];
    self.nnewPasswordTextField.top = self.oldPasswordTextField.bottom;
    UIButton * nnewPasswordBtn = [ControlManager buttonNormalImage:@"commonPasswordHideImage" selectImageName:@"commonPasswordShowImage" frame:CGRectMake6(0, 0, 20, 20) target:nil selector:nil];
    nnewPasswordBtn.left = self.nnewPasswordTextField.right;
    nnewPasswordBtn.centerY = self.nnewPasswordTextField.centerY;

    [nnewPasswordBtn addClickedHandle:^(UIButton *sender) {
        StrongSelf
        sender.selected = !sender.selected;
        strongSelf.nnewPasswordTextField.secureTextEntry = !sender.selected;
    }];
    [self.contentBgView addSubview:nnewPasswordBtn];
    self.confirmNnewPasswordTextField.top = self.nnewPasswordTextField.bottom;
    UIButton * confirmNnewPasswordBtn = [ControlManager buttonNormalImage:@"commonPasswordHideImage" selectImageName:@"commonPasswordShowImage" frame:CGRectMake6(0, 0, 20, 20) target:nil selector:nil];
    confirmNnewPasswordBtn.left = self.confirmNnewPasswordTextField.right;
    confirmNnewPasswordBtn.centerY = self.confirmNnewPasswordTextField.centerY;
    
    [confirmNnewPasswordBtn addClickedHandle:^(UIButton *sender) {
        StrongSelf
        sender.selected = !sender.selected;
        strongSelf.confirmNnewPasswordTextField.secureTextEntry = !sender.selected;
    }];
    [self.contentBgView addSubview:confirmNnewPasswordBtn];
    /**添加线*/
    [self.contentBgView addSubview:[self lineViewTop:self.nnewPasswordTextField.top-0.25]];
    [self.contentBgView addSubview:[self lineViewTop:self.confirmNnewPasswordTextField.top-0.25]];
#pragma mark - 添加点击按钮
    [self.view addSubview:self.confirmChangeButton];
    self.confirmChangeButton.top6 = self.contentBgView.bottom6 + 15;
    
}
#pragma mark -
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length > 0) {
        if ([string removeBlank].length == 0) {
            return NO;
        }
    }
    if (range.location>=12) {
        return NO;
    }else{
        return YES;
    }
    return YES;
}

#pragma mark - 界面用到的懒加载方法都在这里
/**旧密码*/
- (UITextField *)oldPasswordTextField
{
    if (!_oldPasswordTextField) {
        _oldPasswordTextField = [ControlManager textFieldForbidOperationWithFrame:CGRectMake6(15, 0, kScreen6Width-30-20, 94/2.0) font:font6Size(16) textColor:nil placeholder:@"请输入旧密码"];
        _oldPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _oldPasswordTextField.delegate = self;
        //密文样式
        _oldPasswordTextField.borderStyle=UITextBorderStyleNone;
        _oldPasswordTextField.secureTextEntry=YES;
    }
    return _oldPasswordTextField;
}
/**新密码*/
- (UITextField *)nnewPasswordTextField
{
    if (!_nnewPasswordTextField) {
        _nnewPasswordTextField = [ControlManager textFieldForbidOperationWithFrame:CGRectMake6(15, 0, kScreen6Width-30-20, 94/2.0) font:font6Size(16) textColor:nil placeholder:@"请输入新密码"];
        _nnewPasswordTextField.delegate = self;
        _nnewPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nnewPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        //密文样式
        _nnewPasswordTextField.secureTextEntry=YES;
        _nnewPasswordTextField.borderStyle=UITextBorderStyleNone;
    }
    return _nnewPasswordTextField;
}
/**确认新密码*/
- (UITextField *)confirmNnewPasswordTextField
{
    if (!_confirmNnewPasswordTextField) {
        _confirmNnewPasswordTextField = [ControlManager textFieldForbidOperationWithFrame:CGRectMake6(15, 0, kScreen6Width-30-20, 94/2.0) font:font6Size(16) textColor:nil placeholder:@"请确认新密码"];
        _confirmNnewPasswordTextField.delegate = self;
        _confirmNnewPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //密文样式
        _confirmNnewPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _confirmNnewPasswordTextField.secureTextEntry=YES;
        _confirmNnewPasswordTextField.borderStyle=UITextBorderStyleNone;
    }
    return _confirmNnewPasswordTextField;
}
/**输入内容的地方，背景view*/
- (UIView *)contentBgView
{
    if (!_contentBgView) {
        _contentBgView = [ControlManager viewWithFrame:CGRectMake6(0, 15, kScreen6Width, 94/2.0*3) backgroundColor:[UIColor whiteColor]];
    }
    return _contentBgView;
}
/**取线*/
- (UIView *)lineViewTop:(CGFloat)top
{
    UIView * lineView = [ControlManager viewWithFrame:CGRectMake(0, top, kScreen6Width, 0.5) backgroundColor:ColorHex(@"#DDDDDD")];
    lineView.alpha = 0.5;
    return lineView;
}
/**确认更改按钮*/
- (UIButton *)confirmChangeButton
{
    if (!_confirmChangeButton) {
        _confirmChangeButton = [ControlManager buttonTitle:@"确定修改" font:font6Size(18) textColor:[UIColor whiteColor] frame:CGRectMake6(15, 0, kScreen6Width-30, 90/2.0) target:self selector:@selector(confirmChangeButtonClicked)];
        _confirmChangeButton.backgroundColor = DaohangCOLOR;
        ViewRadius(_confirmChangeButton, 4);
    }
    return _confirmChangeButton;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
