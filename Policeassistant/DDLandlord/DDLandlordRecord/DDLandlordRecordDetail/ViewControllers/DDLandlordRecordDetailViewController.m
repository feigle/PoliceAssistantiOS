//
//  DDLandlordRecordDetailViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordRecordDetailViewController.h"
#import "DDHorizontalButton.h"
#import "LHDPopView.h"
#import "DDLandlordRecordChoseAuthorizationPopView.h"
#import "CusstomDatePickerView.h"

@interface DDLandlordRecordDetailViewController ()

/**下一步点击按钮*/
@property (nonatomic,strong) UIButton * saveButton;
/**显示中间的内容背景，用UIScrollView，可以上下滑动*/
@property (nonatomic,strong) UIScrollView * contentBgScrollView;
/**申请房号*/
@property (nonatomic,strong) UILabel * applyForRoomNumberLabel;
/**被授权人*/
@property (nonatomic,strong) UILabel * byAuthorizationPersonLabel;
/**手机号*/
@property (nonatomic,strong) UILabel * applyForPhoneLabel;
/**申请身份*/
@property (nonatomic,strong) UILabel * applyForIdentityLabel;
/**申请时间*/
@property (nonatomic,strong) UILabel * applyForTimeLabel;
/**授权开始时间*/
@property (nonatomic,strong) UILabel * authorizationStartTimeLabel;
/**授权结束时间*/
@property (nonatomic,strong) UILabel * authorizationEndTimeLabel;
/**app授权是否开通*/
@property (nonatomic,strong) DDHorizontalButton * appAuthorizationButton;
/**门禁卡授权是否开通*/
@property (nonatomic,strong) DDHorizontalButton * cardAuthorizationButton;
/**门禁卡授权编号*/
@property (nonatomic,strong) UILabel * cardAuthorizationNumberLabel;
/**门禁卡授权编号背景view*/
@property (nonatomic,strong) UIView * cardAuthorizationNumberBgView;
/**授权结束时间 点击修改的按钮*/
@property (nonatomic,strong) DDHorizontalButton * authorizationEndTimeButton;

/**授权开始时间*/
@property (nonatomic,strong) NSDate * startAuthorizationTimeDate;
/**授权结束时间*/
@property (nonatomic,strong) NSDate * endAuthorizationTimeDate;
/**记录一下授权结束时间*/
@property (nonatomic,strong) NSDate * recordEndAuthorizationTimeDate;


@end

@implementation DDLandlordRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"授权详情";
    [self configUI];
}

#pragma mark - 记录详情数据 set方法
- (void)setRecordDetailModel:(DDLandlordRecordListModel *)recordDetailModel
{
    _recordDetailModel = recordDetailModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshUIData];
    });
}
/**保存 修改的  授权详情 */
- (void)requestSaveChangeRecordDetailData
{
    DDLandlordUserModel * landlordModel = landlordUserModel;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"token"] = landlordModel.token;
    dict[@"record_id"] = [_recordDetailModel.mid toString];
    dict[@"card_status_code"] = self.cardAuthorizationButton.selected?@"2":@"1";//APP授权 1不开通授权，2申请开通授权
    dict[@"app_status_code"] =  self.appAuthorizationButton.selected?@"2":@"1";;//卡授权 1不开通授权，2申请开通授权
    dict[@"auth_deadline"] = [self.endAuthorizationTimeDate returnDateStringWithDateFormat:@"yyyy-MM-dd"];//授权期限
    [SVProgressHUD showWithStatus:@"修改中..."];
    [self putWithUrlString:DDLandlordAuthorizationsRecordsUrlStr parms:dict success:^(NSData *requestData, NSDictionary *requestDict, NSInteger statusCode) {
        [SVProgressHUD dismissWithSuccess:@"修改成功" afterDelay:1.5];
        self.recordDetailModel.card_status_code = self.cardAuthorizationButton.selected?@"2":@"1";
        self.recordDetailModel.app_status_code = self.appAuthorizationButton.selected?@"2":@"1";
        self.recordDetailModel.app_auth_status = requestDict[@"app_auth_status"];
        self.recordDetailModel.card_auth_status = requestDict[@"card_auth_status"];
        self.recordDetailModel.app_auth_deadline = [self.endAuthorizationTimeDate returnDateStringWithDateFormat:@"yyyy-MM-dd"];
        self.recordDetailModel.card_auth_deadline = [self.endAuthorizationTimeDate returnDateStringWithDateFormat:@"yyyy-MM-dd"];
        if (self.retrunRefreshBlock) {
            self.retrunRefreshBlock(YES);
        }
        [self navLeftItemClick:0];
    } failure:^(NSInteger statusCode, NSError *error, NSString *errorMessage) {
        if (statusCode == 11010) {
            [SVProgressHUD dismissWithError:errorMessage afterDelay:1.5];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark - UI 数据刷新
- (void)refreshUIData
{
    _startAuthorizationTimeDate = [[_recordDetailModel.app_start_time toString] returnDateWithFormat:@"yyyy-MM-dd"];
    //1不开通授权，2申请开通授权
    if ([[_recordDetailModel.app_status_code toString] integerValue] == 2) {
        _endAuthorizationTimeDate = [[_recordDetailModel.app_auth_deadline toString] returnDateWithFormat:@"yyyy-MM-dd"];
        [self.appAuthorizationButton setSelectedTitle:[_recordDetailModel.app_auth_status toString]];
        self.appAuthorizationButton.selected = YES;
    } else {
        self.appAuthorizationButton.selected = NO;
        [self.appAuthorizationButton setNormalTitle:[_recordDetailModel.app_auth_status toString]];
    }
    if ([[_recordDetailModel.card_status_code toString] integerValue] == 2) {
        _endAuthorizationTimeDate = [[_recordDetailModel.card_auth_deadline toString] returnDateWithFormat:@"yyyy-MM-dd"];
        [self.cardAuthorizationButton setSelectedTitle:[_recordDetailModel.card_auth_status toString]];
        self.cardAuthorizationButton.selected = YES;
    } else {
        self.cardAuthorizationButton.selected = NO;
        [self.cardAuthorizationButton setNormalTitle:[_recordDetailModel.card_auth_status toString]];
    }
    _recordEndAuthorizationTimeDate = [_endAuthorizationTimeDate copy];
    /**房号*/
    self.applyForRoomNumberLabel.text = [_recordDetailModel.apply_room_no toString];
    /**被授权人*/
    self.byAuthorizationPersonLabel.text = [_recordDetailModel.be_author toString];
    /**被授权手机号*/
    self.applyForPhoneLabel.text = [_recordDetailModel.mobile_number toString];
    /**申请身份*/
    self.applyForIdentityLabel.text = [_recordDetailModel.apply_identity toString];
    /**申请时间*/
    self.applyForTimeLabel.text = [_recordDetailModel.apply_time toString];
    /**授权开始时间*/
    self.authorizationStartTimeLabel.text = [self.startAuthorizationTimeDate returnDateStringWithDateFormat:@"yyyy.MM.dd"];
    /**授权结束时间*/
    self.authorizationEndTimeLabel.text = [self.endAuthorizationTimeDate returnDateStringWithDateFormat:@"yyyy.MM.dd"];
    /**APP授权状态*/
    [self.appAuthorizationButton sizeFit];
    self.appAuthorizationButton.right6 = kScreen6Width - 15;
    /**门禁卡授权状态*/
    [self.cardAuthorizationButton sizeFit];
    self.cardAuthorizationButton.right6 = kScreen6Width - 15;
    /**门禁卡编号*/
    if ([[_recordDetailModel.card_status_code toString] integerValue] == 2) {/**开通的时候显示出来*/
        //1不开通授权，2申请开通授权
        self.cardAuthorizationNumberBgView.hidden = NO;
        self.cardAuthorizationNumberLabel.text = [_recordDetailModel.door_auth_code toString];
    } else {/**关闭的时候需要隐藏*/
        self.cardAuthorizationNumberBgView.hidden = YES;
    }
    if ([[_recordDetailModel.app_status_code toString] integerValue] == 1&&[[_recordDetailModel.card_status_code toString] integerValue] == 1) {
        self.saveButton.backgroundColor = ColorHex(@"#C8C7CD");
        self.saveButton.userInteractionEnabled = NO;
    }

}

#pragma mark - 界面的点击事件在这里
#pragma mark - 保存点击事件
- (void)_saveButtonClicked
{
    if ([[_recordDetailModel.app_status_code toString] integerValue] == 1&&[[_recordDetailModel.card_status_code toString] integerValue] == 1) {
        
        return;
    }
    BOOL change = NO;//判断有没有改变
    if (![_endAuthorizationTimeDate isEqualToDate:_recordEndAuthorizationTimeDate]) {
        change = YES;
    }
    if ([[_recordDetailModel.app_status_code toString] integerValue]-1 != self.appAuthorizationButton.selected) {
        change = YES;
    }
    if ([[_recordDetailModel.card_status_code toString] integerValue]-1 != self.cardAuthorizationButton.selected) {
        change = YES;
    }
    if (change) {//有数据改变
        [self requestSaveChangeRecordDetailData];
    } else {//没有数据改变
        [self navLeftItemClick:0];
    }
}
#pragma mark - 改变结束时间
- (void)changeAuthorizationEndTimeClicked
{
    if ([[self.recordDetailModel.app_status_code toString] integerValue] == 1&&[[self.recordDetailModel.card_status_code toString] integerValue] == 1) {
        return;//1不开通授权，2申请开通授权
    }
    CusstomDatePickerView * pickerView = [[CusstomDatePickerView alloc] initWithDatePickerMode:UIDatePickerModeDate timeBackType:NianYueRiState maximumDate:nil minimumDate:[self.startAuthorizationTimeDate returnAfterAFewDayDateWithNumber:1] defaultDate:self.endAuthorizationTimeDate title:@"授权结束时间"];
    WeakSelf
    [pickerView getCusstomDatePickerViewWithBlock:^(CusstomDatePickerView *pickerView, NSString *dateString, NSDate *selectedDate) {
    } doneBlock:^(CusstomDatePickerView *pickerView, NSString *dateString, NSDate *selectedDate) {
        StrongSelf
        strongSelf.endAuthorizationTimeDate = selectedDate;
        strongSelf.authorizationEndTimeLabel.text = dateString;
    } cancelBlock:^{
    }];
    [pickerView show];
}

#pragma mark - 改变APP 授权状态
- (void)changeAppAuthorizationButtonClicked
{
    if ([[self.recordDetailModel.app_status_code toString] integerValue] == 1) {
        return;//1不开通授权，2申请开通授权
    }
    DDLandlordRecordChoseAuthorizationPopView * view = [[DDLandlordRecordChoseAuthorizationPopView alloc] init];
    view.isDredge = self.appAuthorizationButton.selected;
    WeakSelf
    [view returnRefreshCallBlock:^(BOOL isNeed) {
        StrongSelf
        strongSelf.appAuthorizationButton.selected = isNeed;
    }];
    [LHDPopView showContentView:view style:LHDPopViewBackgroundStyleDark fromView:_appAuthorizationButton];
}
#pragma mark - 改变门禁卡 授权状态
- (void)changeCardAuthorizationButtonClicked
{
    if ([[self.recordDetailModel.card_status_code toString] integerValue] == 1) {
        return;//1不开通授权，2申请开通授权
    }
    DDLandlordRecordChoseAuthorizationPopView * view = [[DDLandlordRecordChoseAuthorizationPopView alloc] init];
    view.isDredge = self.cardAuthorizationButton.selected;
    WeakSelf
    [view returnRefreshCallBlock:^(BOOL isNeed) {
        StrongSelf
        strongSelf.cardAuthorizationButton.selected = isNeed;
        if (!isNeed) {
            strongSelf.cardAuthorizationNumberBgView.hidden = YES;
        } else {
            strongSelf.cardAuthorizationNumberBgView.hidden = NO;
        }
    }];
    [LHDPopView showContentView:view style:LHDPopViewBackgroundStyleDark fromView:_cardAuthorizationButton];
}


#pragma mark - 界面的布局
- (void)configUI
{
    self.view.backgroundColor = ColorHex(@"#EFEFF4");
    [self.view addSubview:self.contentBgScrollView];
    [self.view addSubview:self.saveButton];
#pragma mark - 被授权人布局
    UIView * applyForRoomNumberBgView = [ControlManager viewWithFrame:CGRectMake6(0, 0, kScreen6Width, 88/2.0) backgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00]];
    applyForRoomNumberBgView.top6 = 10;
    [self.contentBgScrollView addSubview:applyForRoomNumberBgView];
    UILabel * applyForRoomNumberDesLabel = [ControlManager lableFrame:CGRectMake6(15, 0, 0, 0) title:@"申请房号" font:font6Size(36/2.0) textColor:ColorHex(@"#999999") textAligment:NSTextAlignmentLeft];
    [applyForRoomNumberDesLabel sizeToFit];
    applyForRoomNumberDesLabel.x6 = 15;
    applyForRoomNumberDesLabel.centerY = applyForRoomNumberBgView.height/2.0;
    [applyForRoomNumberBgView addSubview:applyForRoomNumberDesLabel];
    [applyForRoomNumberBgView addSubview:self.applyForRoomNumberLabel];
    self.applyForRoomNumberLabel.centerY = applyForRoomNumberDesLabel.centerY;
    self.applyForRoomNumberLabel.width6 = applyForRoomNumberBgView.width6 - applyForRoomNumberDesLabel.width6-60;
    self.applyForRoomNumberLabel.left6 = applyForRoomNumberDesLabel.right6+15;
#pragma mark - 被授权人 手机号码 、申请身份 、 申请时间 布局
    /**被授权人*/
    UIView * byAuthorizationBgView = [self commonTitle:@"被授权人" titleColor:ColorHex(@"#999999") des:@"王五威武" desColor:ColorHex(@"#999999") top:applyForRoomNumberBgView.bottom];
    _byAuthorizationPersonLabel = (UILabel *)[byAuthorizationBgView viewWithTag:1000];
    [self.contentBgScrollView addSubview:byAuthorizationBgView];
    /**手机号*/
    UIView * phoneBgView = [self commonTitle:@"手机号码" titleColor:ColorHex(@"#999999") des:@"13666666666" desColor:ColorHex(@"#999999") top:byAuthorizationBgView.bottom];
    _applyForPhoneLabel = (UILabel *)[phoneBgView viewWithTag:1000];
    [self.contentBgScrollView addSubview:phoneBgView];
    /**申请身份*/
    UIView * authorizationPersonBgView = [self commonTitle:@"申请身份" titleColor:ColorHex(@"#999999") des:@"业主" desColor:ColorHex(@"#999999") top:phoneBgView.bottom];
    _applyForIdentityLabel = (UILabel *)[authorizationPersonBgView viewWithTag:1000];
    [self.contentBgScrollView addSubview:authorizationPersonBgView];
    /**申请时间*/
    UIView * authorizationTimeBgView = [self commonTitle:@"申请时间" titleColor:ColorHex(@"#999999") des:@"2017.03.13" desColor:ColorHex(@"#999999") top:authorizationPersonBgView.bottom];
    _applyForTimeLabel = (UILabel *)[authorizationTimeBgView viewWithTag:1000];
    [self.contentBgScrollView addSubview:authorizationTimeBgView];
#pragma mark - 添加分割线
    UIView * lineOneView = [self lineViewTop:authorizationTimeBgView.bottom];
    [self.contentBgScrollView addSubview:lineOneView];
#pragma mark - 开始时间、结束时间 布局
    /**开始时间*/
    UIView * authorizationStartTimeBgView = [self commonTitle:@"授权开始时间" titleColor:ColorHex(@"#999999") des:@"2017.03.13" desColor:ColorHex(@"#999999") top:lineOneView.bottom];
    _authorizationStartTimeLabel = (UILabel *)[authorizationStartTimeBgView viewWithTag:1000];
    [self.contentBgScrollView addSubview:authorizationStartTimeBgView];
    /**结束时间*/
    UIView * authorizationEndTimeBgView = [self commonTitle:@"授权结束时间" titleColor:ColorHex(@"#999999") des:@"2017.03.13" desColor:ColorHex(@"#4A4A4A") top:authorizationStartTimeBgView.bottom];
    _authorizationEndTimeLabel = (UILabel *)[authorizationEndTimeBgView viewWithTag:1000];
    [self.contentBgScrollView addSubview:authorizationEndTimeBgView];
    [self.contentBgScrollView addSubview:self.authorizationEndTimeButton];
    self.authorizationEndTimeButton.bottom = authorizationEndTimeBgView.bottom;
#pragma mark - 添加分割线
    UIView * lineTwoView = [self lineViewTop:authorizationEndTimeBgView.bottom];
    [self.contentBgScrollView addSubview:lineTwoView];
#pragma mark - APP 授权 布局
    UIView * appAuthorizationBgView = [self authorTitle:@"APP授权" isNeedLine:YES top:lineTwoView.bottom];
    _appAuthorizationButton = (DDHorizontalButton *)[appAuthorizationBgView viewWithTag:1000];
    WeakSelf
    [_appAuthorizationButton addClickedHandle:^(UIButton *sender) {
        StrongSelf
        [strongSelf changeAppAuthorizationButtonClicked];
    }];
    [self.contentBgScrollView addSubview:appAuthorizationBgView];
#pragma mark - 添加分割线
#pragma mark - 门禁卡授权 布局
    UIView * cardAuthorizationBgView = [self authorTitle:@"门禁卡授权" isNeedLine:NO top:appAuthorizationBgView.bottom];
    _cardAuthorizationButton = (DDHorizontalButton *)[cardAuthorizationBgView viewWithTag:1000];
    [_cardAuthorizationButton addClickedHandle:^(UIButton *sender) {
        StrongSelf
        [strongSelf changeCardAuthorizationButtonClicked];
    }];
    [self.contentBgScrollView addSubview:cardAuthorizationBgView];
#pragma mark - 门禁卡授权 编号  布局
    [self.contentBgScrollView addSubview:self.cardAuthorizationNumberBgView];
    self.cardAuthorizationNumberBgView.top = cardAuthorizationBgView.bottom;
    
#pragma mark - 门禁卡授权编号 布局
}

#pragma mark - 界面用到的对象，懒加载数据在这里
/**下一步点击按钮*/
- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [ControlManager buttonTitle:@"保存" font:font6Size(36/2.0) textColor:ColorHex(@"#FFFFFF") frame:CGRectMake(0, 0, KScreenWidth, 0) target:self selector:@selector(_saveButtonClicked)];
        _saveButton.height6 = 88/2.0;
        _saveButton.backgroundColor = DaohangCOLOR;
        _saveButton.bottom = KScreenHeight-64;
    }
    return _saveButton;
}
/**显示中间的内容背景，用UIScrollView，可以上下滑动*/
- (UIScrollView *)contentBgScrollView
{
    if (!_contentBgScrollView) {
        _contentBgScrollView = [ControlManager scrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-self.saveButton.height) isBounces:NO isShowIndicator:NO];
        WeakSelf
        [_contentBgScrollView addLHDClickedHandle:^(id sender) {
            StrongSelf
            [strongSelf.view endEditing:YES];
        }];
    }
    return _contentBgScrollView;
}
/**申请房号*/
- (UILabel *)applyForRoomNumberLabel
{
    if (!_applyForRoomNumberLabel) {
        _applyForRoomNumberLabel = [ControlManager lableFrame:CGRectZero title:@"0101室" font:font6Size(36/2.0) textColor:ColorHex(@"#999999")];
        _applyForRoomNumberLabel.height = font6Size(36/2.0).lineHeight;
    }
    return _applyForRoomNumberLabel;
}
/**门禁卡授权编号背景view*/
- (UIView *)cardAuthorizationNumberBgView
{
    if (!_cardAuthorizationNumberBgView) {
        UIView * card = [self commonTitle:@"门禁卡编号" titleColor:ColorHex(@"#999999") des:@"556666" desColor:ColorHex(@"#4A4A4A") top:0];
        _cardAuthorizationNumberBgView = [ControlManager viewWithFrame:CGRectMake6(0, 0, kScreen6Width, card.height6+15) backgroundColor:[UIColor whiteColor]];
        [_cardAuthorizationNumberBgView addSubview:card];
        _cardAuthorizationNumberLabel = (UILabel *)[card viewWithTag:1000];
        UIView * lineView = [ControlManager viewWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5) backgroundColor:ColorHex(@"#DDDDDD")];
        [_cardAuthorizationNumberBgView addSubview:lineView];
    }
    return _cardAuthorizationNumberBgView;
}
/**授权结束时间 点击修改的按钮*/
- (DDHorizontalButton *)authorizationEndTimeButton
{
    if (!_authorizationEndTimeButton) {
        _authorizationEndTimeButton = [[DDHorizontalButton alloc] init];
        _authorizationEndTimeButton.padding = 5*kScreen6ScaleW;
        [_authorizationEndTimeButton setTitleFont:font6Size(36/2.0)];
        [_authorizationEndTimeButton setNormalTitleColor:ColorHex(@"4372E2")];
        [_authorizationEndTimeButton setNormalTitle:@"修改"];
        [_authorizationEndTimeButton setNormalImageName:@"DDLandlordCommonarrowright"];
        _authorizationEndTimeButton.titleIsRight = NO;
        _authorizationEndTimeButton.sizeFit = YES;
        _authorizationEndTimeButton.right6 = kScreen6Width-15;
        WeakSelf
        [_authorizationEndTimeButton addClickedHandle:^(UIButton *sender) {
            StrongSelf
            [strongSelf changeAuthorizationEndTimeClicked];
        }];
    }
    return _authorizationEndTimeButton;
}

#pragma mark - 本界面公用的封装
- (UIView *)commonTitle:(NSString *)title titleColor:(UIColor *)titleColor des:(NSString *)des desColor:(UIColor *)desColor top:(CGFloat)top
{
    UIView * bgView = [ControlManager viewWithFrame:CGRectMake6(0, 0, kScreen6Width, 15) backgroundColor:[UIColor whiteColor]];
    bgView.top = top;
    bgView.height += font6Size(36/2.0).lineHeight;
    UILabel * titleLabel = [ControlManager lableFrame:CGRectZero title:title font:font6Size(36/2.0) textColor:titleColor];
    [titleLabel sizeToFit];
    titleLabel.x6 = 15;
    titleLabel.top6 = 15;
    [bgView addSubview:titleLabel];
    if (des) {
        UILabel * desLabel = [ControlManager lableFrame:CGRectMake6(titleLabel.right6+15, 15, 0, titleLabel.height6) title:des font:font6Size(36/2.0) textColor:desColor];
        desLabel.width6 = bgView.width6- 60 - titleLabel.width6;
        desLabel.tag = 1000;
        [bgView addSubview:desLabel];
    }
    return bgView;
}

- (UIView *)authorTitle:(NSString *)title isNeedLine:(BOOL)isNeed top:(CGFloat)top
{
    UIView * bgView = [ControlManager viewWithFrame:CGRectMake6(0, 0, kScreen6Width, 120/2.0) backgroundColor:[UIColor whiteColor]];
    bgView.userInteractionEnabled = YES;
    bgView.top = top;
    UILabel * titleLabel = [ControlManager lableFrame:CGRectZero title:title font:font6Size(36/2.0) textColor:ColorHex(@"#4A4A4A")];
    [titleLabel sizeToFit];
    titleLabel.x6 = 15;
    titleLabel.centerY = bgView.height/2.0;
    [bgView addSubview:titleLabel];
    DDHorizontalButton * btn = [[DDHorizontalButton alloc] init];
    [btn setTitleFont:font6Size(36/2.0)];
    [btn setNormalTitleColor:ColorHex(@"999999")];
    [btn setNormalTitle:@"关闭"];
    [btn setSelectedTitle:@"开通"];
    [btn setNormalImageName:@"DDLandlordRecordSolidArrowDown"];
    btn.selected = YES;
    btn.titleIsRight = NO;
    btn.sizeFit = YES;
    btn.right6 = bgView.width6-15;
    btn.centerY = titleLabel.centerY;
    btn.tag = 1000;
    [bgView addSubview:btn];
    if (isNeed) {
        UIView * lineView = [ControlManager viewWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5) backgroundColor:ColorHex(@"#DDDDDD")];
        lineView.bottom = bgView.height;
        [bgView addSubview:lineView];
    }
    return bgView;
}

/**一条线*/
- (UIView *)lineViewTop:(CGFloat)top
{
    UIView * bgView = [ControlManager viewWithFrame:CGRectMake6(0, 0, kScreen6Width, 15) backgroundColor:[UIColor whiteColor]];
    bgView.top = top;
    UIView * lineView = [ControlManager viewWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5) backgroundColor:ColorHex(@"#DDDDDD")];
    lineView.bottom = bgView.height;
    [bgView addSubview:lineView];
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
