//
//  DDLandlordSelfHelpAuthorizationViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordSelfHelpAuthorizationViewController.h"
#import "DDLandlordSelfHelpAuthorizationChooseRoomVC.h"
#import "DDLandlordSelfHelpAuthorizationComplementViewController.h"
#import "CusstomDatePickerView.h"
#import "DDTools.h"
#import "DDLandlordSelfHelpAuthorizationChooseRoomModel.h"
#import "DDLandlordSelfHelpAuthorizationModel.h"

@interface DDLandlordSelfHelpAuthorizationViewController ()

/**显示中间的内容背景，用UIScrollView，可以上下滑动*/
@property (nonatomic,strong) UIScrollView * contentBgScrollView;
/**下一步点击按钮*/
@property (nonatomic,strong) UIButton * nextStepButton;
/**选择房屋，显示选择的房屋*/
@property (nonatomic,strong) UILabel * houseSelectedLabel;
/**用户名*/
@property (nonatomic,strong) UITextField * userNameTextField;
/**手机号*/
@property (nonatomic,strong) UITextField * phoneTextField;
/**卡授权开关，默认开启*/
@property (nonatomic,strong) UISwitch * cardAuthorizationSwitch;
/**app授权开关，默认开启*/
@property (nonatomic,strong) UISwitch * appAuthorizationSwitch;
/**开始时间*/
@property (nonatomic,strong) UILabel * startTimeLabel;
/**结束时间*/
@property (nonatomic,strong) UILabel * endTimeLabel;

/**授权开始时间*/
@property (nonatomic,strong) NSDate * startAuthorizationTimeDate;
/**授权结束时间*/
@property (nonatomic,strong) NSDate * endAuthorizationTimeDate;
/**关于时间的 bgview*/
@property (nonatomic,strong) UIView * timeBgView;

/**授权模型*/
@property (nonatomic,strong) DDLandlordSelfHelpAuthorizationModel * authorizationModel;

@end

@implementation DDLandlordSelfHelpAuthorizationViewController

#pragma mark - 基础数据
- (void)setupData
{
//    18179144606
    self.startAuthorizationTimeDate = [NSDate date];
    self.endAuthorizationTimeDate = [self.startAuthorizationTimeDate returnAfterAFewYearsDateWithNumber:1];
    self.authorizationModel = [[DDLandlordSelfHelpAuthorizationModel alloc] init];
    DDLandlordUserModel * userModel = landlordUserModel;
    self.authorizationModel.user_id = [userModel.user_id toString];
    self.authorizationModel.token = [userModel.token toString];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    self.title = @"自助授权";
    [self configUI];
}

#pragma mark - 界面的点击事件在这里
#pragma mark - 卡授权开关
- (void)cardAuthorizationSwitchClicked
{
    [self refreshTimeHideAndNextStepButtonData];
}
#pragma mark - APP授权开关
- (void)appAuthorizationSwitchClicked
{
    [self refreshTimeHideAndNextStepButtonData];
}

- (void)refreshTimeHideAndNextStepButtonData
{
    /**两个都关闭的情况下改变*/
    if (!self.appAuthorizationSwitch.on && !self.cardAuthorizationSwitch.on) {
        self.nextStepButton.backgroundColor = ColorHex(@"#C8C7CD");
        self.nextStepButton.userInteractionEnabled = NO;
        self.timeBgView.hidden = YES;
    } else {
        self.nextStepButton.backgroundColor = DaohangCOLOR;
        self.nextStepButton.userInteractionEnabled = YES;
        self.timeBgView.hidden = NO;
    }
}

#pragma mark - 下一步点击事件
- (void)nextStepButtonClicked
{
    if ([self.authorizationModel.room_number_id toString].length == 0) {
        [DDProgressHUD showCenterWithText:@"请选择房号" duration:1.5];
        return;
    }
    if (self.userNameTextField.text.length == 0) {
        [DDProgressHUD showCenterWithText:@"请输入姓名" duration:1.5];
        return;
    }
    if (![DDTools validatePhone:self.phoneTextField.text]) {
        [DDProgressHUD showCenterWithText:@"请输入合法的手机号" duration:1.5];
        return;
    }
    [self.view endEditing:YES];
    self.authorizationModel.real_name = self.userNameTextField.text;
    self.authorizationModel.mobile_no = self.phoneTextField.text;
    /**时间*/
    self.authorizationModel.auth_end_time = [self.endAuthorizationTimeDate returnDateStringWithDateFormat:@"yyyy-MM-dd"];
    self.authorizationModel.auth_start_time = [self.startAuthorizationTimeDate returnDateStringWithDateFormat:@"yyyy-MM-dd"];
    /**授权状态*/
    //1不开通授权，2申请开通授权
    self.authorizationModel.card_status_code =  self.cardAuthorizationSwitch.on ? @"2":@"1";
    self.authorizationModel.app_status_code =  self.appAuthorizationSwitch.on ? @"2":@"1";
    
    DDLandlordSelfHelpAuthorizationComplementViewController * vc = [[DDLandlordSelfHelpAuthorizationComplementViewController alloc] init];
    vc.authorizationModel = self.authorizationModel;
    [self pushVC:vc];
}
#pragma mark - 选择房号被点击
- (void)chooseHouseNoClicked
{
    DDLandlordSelfHelpAuthorizationChooseRoomVC * vc = [[DDLandlordSelfHelpAuthorizationChooseRoomVC alloc] init];
    WeakSelf
    [vc returnObjectCallBlock:^(id objc) {
        DDLandlordSelfHelpAuthorizationChooseRoomModel * roomModel = objc;
        StrongSelf
        strongSelf.houseSelectedLabel.text = [roomModel.room_number toString];
        strongSelf.authorizationModel.room_number_id = [roomModel.room_number_id toString];
        strongSelf.authorizationModel.dep_id = [roomModel.dep_id toString];
    }];
    [self pushVC:vc];
}
#pragma mark - 开始时间被点击了
- (void)chooseStartTimeClicked
{
    CusstomDatePickerView * pickerView = [[CusstomDatePickerView alloc] initWithDatePickerMode:UIDatePickerModeDate timeBackType:NianYueRiState maximumDate:nil minimumDate:[NSDate date] defaultDate:self.startAuthorizationTimeDate title:@"开始时间"];
    WeakSelf
    [pickerView getCusstomDatePickerViewWithBlock:^(CusstomDatePickerView *pickerView, NSString *dateString, NSDate *selectedDate) {
        
    } doneBlock:^(CusstomDatePickerView *pickerView, NSString *dateString, NSDate *selectedDate) {
        StrongSelf
        strongSelf.startAuthorizationTimeDate = selectedDate;
        strongSelf.startTimeLabel.text = dateString;
        if (![DDTools compareBigDate:strongSelf.startAuthorizationTimeDate compareDate:strongSelf.endAuthorizationTimeDate]) {
            strongSelf.endAuthorizationTimeDate = [strongSelf.startAuthorizationTimeDate returnAfterAFewYearsDateWithNumber:1];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            NSString *destDateString = [dateFormatter stringFromDate:strongSelf.endAuthorizationTimeDate];
            strongSelf.endTimeLabel.text = destDateString;
        }
    } cancelBlock:^{
        
    }];
    [pickerView show];
}
#pragma mark - 结束时间被点击了
- (void)chooseEndTimeClicked
{
    CusstomDatePickerView * pickerView = [[CusstomDatePickerView alloc] initWithDatePickerMode:UIDatePickerModeDate timeBackType:NianYueRiState maximumDate:nil minimumDate:[self.startAuthorizationTimeDate returnAfterAFewDayDateWithNumber:1] defaultDate:self.endAuthorizationTimeDate title:@"结束时间"];
    WeakSelf
    [pickerView getCusstomDatePickerViewWithBlock:^(CusstomDatePickerView *pickerView, NSString *dateString, NSDate *selectedDate) {
        
    } doneBlock:^(CusstomDatePickerView *pickerView, NSString *dateString, NSDate *selectedDate) {
        StrongSelf
        strongSelf.endAuthorizationTimeDate = selectedDate;
        strongSelf.endTimeLabel.text = dateString;
    } cancelBlock:^{
        
    }];
    [pickerView show];
}

#pragma mark - 页面布局
- (void)configUI
{
    self.view.backgroundColor = ColorHex(@"#EFEFF4");
    [self.view addSubview:self.contentBgScrollView];
    [self.view addSubview:self.nextStepButton];
#pragma mark - 布局界面
#pragma mark - 房号
    /**房号*/
    UIView * houseNoBgView = [self contentWithTitle:@"房号" isNeedArrow:YES isNeedSwitch:NO isNeedTextField:NO desc:@"选择房号" descColor:ColorHex(@"#999999") placeHolder:nil];
    _houseSelectedLabel = (UILabel *)[houseNoBgView viewWithTag:1000];
    houseNoBgView.top6 = 10;
    WeakSelf
    [houseNoBgView addLHDClickedHandle:^(id sender) {
        StrongSelf
        [strongSelf chooseHouseNoClicked];
        
    }];
    [self.contentBgScrollView addSubview:houseNoBgView];
#pragma mark - 填写基本信息
    /**填写基本信息*/
    UIView * desBaseTitleView = [self desContentLabelText:@"填写基本信息"];
    desBaseTitleView.top = houseNoBgView.bottom;
    [self.contentBgScrollView addSubview:desBaseTitleView];
    /**姓名*/
    UIView * nameBgView = [self contentWithTitle:@"姓名" isNeedArrow:NO isNeedSwitch:NO isNeedTextField:YES desc:nil descColor:nil placeHolder:@"请输入姓名"];
    nameBgView.top = desBaseTitleView.bottom;
    _userNameTextField = (UITextField *)[nameBgView viewWithTag:1000];
    [self.contentBgScrollView addSubview:nameBgView];
    /**手机号*/
    UIView * phoneBgView = [self contentWithTitle:@"+86" isNeedArrow:NO isNeedSwitch:NO isNeedTextField:YES desc:nil descColor:nil placeHolder:@"请输入手机号"];
    _phoneTextField = (UITextField *)[phoneBgView viewWithTag:1000];
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneBgView.top = nameBgView.bottom-0.5;
    [self.contentBgScrollView addSubview:phoneBgView];
#pragma mark - 被授权种类
    UIView * authorizationClassTitleView = [self desContentLabelText:@"被授权种类"];
    authorizationClassTitleView.top = phoneBgView.bottom;
    [self.contentBgScrollView addSubview:authorizationClassTitleView];
    /**卡授权*/
    UIView * cardAuthorizationBgView = [self contentWithTitle:@"卡授权" isNeedArrow:NO isNeedSwitch:YES isNeedTextField:NO desc:nil descColor:nil placeHolder:nil];
    cardAuthorizationBgView.top = authorizationClassTitleView.bottom;
    _cardAuthorizationSwitch = (UISwitch *)[cardAuthorizationBgView viewWithTag:1000];
    [_cardAuthorizationSwitch addTarget:self action:@selector(cardAuthorizationSwitchClicked) forControlEvents:UIControlEventValueChanged];
    [self.contentBgScrollView addSubview:cardAuthorizationBgView];
    /**APP授权*/
    UIView * appAuthorizationBgView = [self contentWithTitle:@"app授权" isNeedArrow:NO isNeedSwitch:YES isNeedTextField:NO desc:nil descColor:nil placeHolder:nil];
    _appAuthorizationSwitch = (UISwitch *)[appAuthorizationBgView viewWithTag:1000];
    [_appAuthorizationSwitch addTarget:self action:@selector(appAuthorizationSwitchClicked) forControlEvents:UIControlEventValueChanged];
    appAuthorizationBgView.top = cardAuthorizationBgView.bottom-0.5;
    [self.contentBgScrollView addSubview:appAuthorizationBgView];
#pragma mark - 授权时间
    self.timeBgView.top = appAuthorizationBgView.bottom;
    [self.contentBgScrollView addSubview:self.timeBgView];
    UIView * authorizationTimeTitleView = [self desContentLabelText:@"被授权时间"];
    authorizationTimeTitleView.top = 0;
    [self.timeBgView addSubview:authorizationTimeTitleView];
    /**卡授权*/
    UIView * startTimeBgView = [self contentWithTitle:@"开始时间" isNeedArrow:YES isNeedSwitch:NO isNeedTextField:NO desc:[self.startAuthorizationTimeDate returnDateStringWithDateFormat:@"yyyy.MM.dd"] descColor:ColorHex(@"#4A4A4A") placeHolder:nil];
    _startTimeLabel = (UILabel *)[startTimeBgView viewWithTag:1000];
    startTimeBgView.top = authorizationTimeTitleView.bottom;
    [startTimeBgView addLHDClickedHandle:^(id sender) {
        StrongSelf
        [strongSelf chooseStartTimeClicked];
    }];
    [self.timeBgView addSubview:startTimeBgView];
    /**卡授权*/
    UIView * endTimeBgView = [self contentWithTitle:@"结束时间" isNeedArrow:YES isNeedSwitch:NO isNeedTextField:NO desc:[self.endAuthorizationTimeDate returnDateStringWithDateFormat:@"yyyy.MM.dd"] descColor:ColorHex(@"#4A4A4A") placeHolder:nil];
    _endTimeLabel = (UILabel *)[endTimeBgView viewWithTag:1000];
    endTimeBgView.top = startTimeBgView.bottom-0.5;
    [endTimeBgView addLHDClickedHandle:^(id sender) {
        StrongSelf
        [strongSelf chooseEndTimeClicked];
    }];
    [self.timeBgView addSubview:endTimeBgView];
    self.timeBgView.height = endTimeBgView.bottom;
    if (self.timeBgView.bottom > self.contentBgScrollView.height) {
        self.contentBgScrollView.contentSize = CGSizeMake(KScreenWidth, endTimeBgView.bottom+2);
    }
}

#pragma mark - 界面用到的对象，懒加载数据在这里
/**下一步点击按钮*/
- (UIButton *)nextStepButton
{
    if (!_nextStepButton) {
        _nextStepButton = [ControlManager buttonTitle:@"下一步" font:font6Size(36/2.0) textColor:ColorHex(@"#FFFFFF") frame:CGRectMake(0, 0, KScreenWidth, 0) target:self selector:@selector(nextStepButtonClicked)];
        _nextStepButton.height6 = 88/2.0;
        _nextStepButton.backgroundColor = DaohangCOLOR;
        _nextStepButton.bottom = KScreenHeight-64;
    }
    return _nextStepButton;
}
/**显示中间的内容背景，用UIScrollView，可以上下滑动*/
- (UIScrollView *)contentBgScrollView
{
    if (!_contentBgScrollView) {
        _contentBgScrollView = [ControlManager scrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-self.nextStepButton.height) isBounces:NO isShowIndicator:NO];
        WeakSelf
        [_contentBgScrollView addLHDClickedHandle:^(id sender) {
            StrongSelf
            [strongSelf.view endEditing:YES];
        }];
    }
    return _contentBgScrollView;
}
/**关于时间的bgview*/
- (UIView *)timeBgView
{
    if (!_timeBgView) {
        _timeBgView = [ControlManager viewWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        _timeBgView.userInteractionEnabled = YES;
    }
    return _timeBgView;
}
/**白色背景 加 上 下 两条线*/
- (UIView *)contentBgView
{
    UIView * bgView = [ControlManager viewWithFrame:CGRectMake(0, 0, KScreenWidth, 120/2.0*kScreen6ScaleH) backgroundColor:[UIColor whiteColor]];
    CALayer * topLineLayer = [CALayer layer];
    topLineLayer.frame = CGRectMake(0, 0, KScreenWidth, 0.5);
    topLineLayer.backgroundColor = ColorHex(@"#DDDDDD").CGColor;
    [bgView.layer addSublayer:topLineLayer];
    CALayer * bottomLineLayer = [CALayer layer];
    bottomLineLayer.frame = CGRectMake(0, bgView.height-0.5, KScreenWidth, 0.5);
    bottomLineLayer.backgroundColor = ColorHex(@"#DDDDDD").CGColor;
    [bgView.layer addSublayer:bottomLineLayer];
    return bgView;
}

/**
 创建一个带有标题、或者带有箭头、或者带有 显示副标题（时间、房间信息）或者带有switch的view

 @param title 标题
 @param isNeedArrow 是否需要右侧的箭头
 @param isNeedSwitch 是否需要switch
 @param palceholder 描述、为nil的时候不需要，一般带有箭头的时候才判断这个
 @param palceholderColor 描述的颜色
 @return 一个view
 */
- (UIView *)contentWithTitle:(NSString *)title isNeedArrow:(BOOL)isNeedArrow isNeedSwitch:(BOOL)isNeedSwitch isNeedTextField:(BOOL)isNeedTextField desc:(NSString *)desc descColor:(UIColor *)descColor placeHolder:(NSString *)placeholder
{
    UIView * bgView = [self contentBgView];
    bgView.userInteractionEnabled = YES;
    UILabel * titleLabel = [ControlManager lableFrame:CGRectZero title:title font:font6Size(36/2.0) textColor:ColorHex(@"#4A4A4A")];
    [titleLabel sizeToFit];
    titleLabel.x6 = 15;
    titleLabel.centerY = bgView.height/2.0;
    [bgView addSubview:titleLabel];
    if (isNeedArrow) {/**是否需要带有箭头*/
        UIImageView * arrowImageView = [ControlManager imageViewWithImageName:@"DDLandlordCommonarrowright"];
        arrowImageView.right6 = bgView.width6-15;
        arrowImageView.centerY = bgView.height/2.0;
        [bgView addSubview:arrowImageView];
        if (desc) {
            UILabel * placeLabel = [ControlManager lableFrame:CGRectMake(0, 0, 0, font6Size(32/2.0).lineHeight) font:font6Size(32/2.0) textColor:descColor textAligment:NSTextAlignmentRight];
            placeLabel.width6 = bgView.width6-30-5-arrowImageView.width6;
            placeLabel.right6 = arrowImageView.left6-5;
            placeLabel.text = desc;
            placeLabel.tag = 1000;
            placeLabel.centerY = bgView.height/2.0;
            [bgView addSubview:placeLabel];
        }
    }
    if (isNeedSwitch) {/**是否需要switch控件开关*/
        UISwitch * sw = [[UISwitch alloc] init];
        sw.on = YES;
        sw.centerY = bgView.height/2.0;
        sw.right6 = bgView.width6 - 15;
        sw.tag = 1000;
        [bgView addSubview:sw];
    }
    if (isNeedTextField) {/**是否需要输入框*/
        UIView * lineView = [ControlManager viewWithFrame:CGRectMake6(170/2.0, 15, 0.5, bgView.height6-30) backgroundColor:ColorHex(@"#DDDDDD")];
        lineView.width6 = 0.5;
        [bgView addSubview:lineView];
        UITextField * textField = [ControlManager textFieldWithFrame:CGRectZero font:font6Size(36/2.0) textColor:ColorHex(@"#4A4A4A") placeholder:placeholder];
        textField.width6 = bgView.width6-lineView.right6 - 30;
        textField.left6 = lineView.right6+15;
        textField.height = font6Size(36/2.0).lineHeight;
        textField.tag = 1000;
        textField.centerY = bgView.height/2.0;
        [bgView addSubview:textField];
    }
    return bgView;
}

- (UIView *)desContentLabelText:(NSString *)text
{
    UIView * bgView = [ControlManager viewWithFrame:CGRectMake6(0, 0, kScreen6Width, 88/2.0) backgroundColor:ColorHex(@"#EFEFF4")];
    UILabel * label = [ControlManager lableFrame:CGRectMake6(15, 0, kScreen6Width-30, 2.0) title:text font:font6Size(28/2.0) textColor:ColorHex(@"#999999")];
    label.textAlignment = NSTextAlignmentLeft;
    label.height = font6Size(28/2.0).lineHeight;
    label.centerY = bgView.height/2.0;
    label.tag = 1000;
    [bgView addSubview:label];
    return bgView;
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
