//
//  DDLandlordSelfHelpAuthorizationCompleteViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordSelfHelpAuthorizationCompleteViewController.h"

@interface DDLandlordSelfHelpAuthorizationCompleteViewController ()

@end

@implementation DDLandlordSelfHelpAuthorizationCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"授权完成";
    [self configUI];
}
#pragma mark - 点击事件
#pragma mark - 查看申请
- (void)lookApplyForButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:PushToDDLandlordRecordListViewController object:@(NO)];
}
#pragma mark - 返回点击按钮
- (void)doBackAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - UI 布局
- (void)configUI
{
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 10;
    self.view.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
    UIImageView * imageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 100/2.0, 200/2.0, 200/2.0) imageName:@"DDLandlordSelfHelpAuthorizationIdentifyCardSubmitSuccess"];
    imageView.centerX = KScreenWidth/2.0;
    [self.view addSubview:imageView];
    UILabel * submitLabel = [ControlManager lableFrame:CGRectZero title:@"提交成功" font:font6Size(36/2.0) textColor:ColorHex(@"000000")];
    [submitLabel sizeToFit];
    submitLabel.centerX = KScreenWidth/2.0;
    submitLabel.top6 = imageView.bottom6 + 15;
    [self.view addSubview:submitLabel];
    UILabel * submitDesLabel = [ControlManager lableFrame:CGRectMake6(100/2.0, submitLabel.bottom6+15, kScreen6Width-100, 0) title:@"恭喜您已完成APP授权，如果您开通了门禁卡授权，请携带门禁卡与系统发放的唯一验证码前往指定的门禁机进行卡授权操作，谢谢！" font:font6Size(28/2.0) textColor:ColorHex(@"#4A4A4A")];
    submitDesLabel.numberOfLines = 0;
    submitDesLabel.centerX = KScreenWidth/2.0;
    [submitDesLabel setStringHeight];
    [self.view addSubview:submitDesLabel];
    
    UIButton * lookApplyForButton = [ControlManager buttonTitle:@"查看申请" font:font6Size(36/2.0) textColor:ColorHex(@"#FFFFFF") frame:CGRectMake6(0, 0, 360/2.0, 0) target:self selector:@selector(lookApplyForButtonClicked)];
    lookApplyForButton.height6 = 88/2.0;
    lookApplyForButton.backgroundColor = DaohangCOLOR;
    ViewRadius(lookApplyForButton, 4);
    lookApplyForButton.top6 = submitDesLabel.bottom6 + 15;
    lookApplyForButton.centerX = KScreenWidth/2.0;
    [self.view addSubview:lookApplyForButton];
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
