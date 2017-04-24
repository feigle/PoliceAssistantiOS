//
//  DDLandlordCenterViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordCenterViewController.h"
#import "DDLandlordSettingViewController.h"
#import "DDLandlordHouseListViewController.h"
#import "DDLandlordRecordListViewController.h"
#import "DDLandlordSelfHelpAuthorizationViewController.h"

@interface DDLandlordCenterViewController ()

/**背景bgScrollView，为了防止以后需求可以是滑动的*/
@property (nonatomic,strong) UIScrollView * bgScrollView;
/**背景图片*/
@property (nonatomic,strong) UIImageView * bgImageView;
/**设置按钮*/
@property (nonatomic,strong) UIButton * settingButton;
/**头像*/
@property (nonatomic,strong) UIImageView * headerImageView;
/**昵称、或者手机号*/
@property (nonatomic,strong) UILabel * titleLabel;
/**选择小区旁边的图片*/
@property (nonatomic,strong) UIImageView * chooseHouseLefImageView;
/**选择小区按钮*/
@property (nonatomic,strong) DDHorizontalButton * chooseHouseListButton;


@end

@implementation DDLandlordCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestLandlordHouseListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushToDDLandlordRecordListViewController:) name:PushToDDLandlordRecordListViewController object:nil];
    [self configUI];
    [self refreshLandlordCenterUIData];
}

#pragma mark - 数据的请求在这里，请求房东 房产信息
- (void)requestLandlordHouseListData
{
    DDLandlordUserModel * userModel = landlordUserModel;
    if (!userModel.selectedModel) {
        /**房东栋列表 数据*/
        DDLandlordUserModel * landlordModel = landlordUserModel;
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[@"user_id"] = [landlordModel.user_id toString];
        dict[@"user_name"] = [landlordModel.user_name toString];
        dict[@"token"] = landlordModel.token;
        [SVProgressHUD showWithStatus:@"初始化中..."];
        WeakSelf
        [self getWithUrlString:DDLandlordEstatesBuildingsUrlStr parms:dict success:^(NSData *requestData, NSDictionary *requestDict, NSInteger statusCode) {
            [SVProgressHUD dismiss];
            StrongSelf
            NSArray * dictsArray = requestDict[@"list"];
            NSError * error = nil;
            NSArray * listModelArray = [DDLandlordHouseListModel arrayOfModelsFromDictionaries:dictsArray error:&error];
            if (!error) {
                userModel.landlordHouseListDataArray = listModelArray;
                if (listModelArray.count > 0) {
                    userModel.selectedModel = listModelArray[0];
                    userModel.selectedModel.selected = YES;
                }
                [DDLandlordUserModel saveMySelf];
                [strongSelf refreshLandlordCenterUIData];
            }
        } failure:^(NSInteger statusCode, NSError *error, NSString *errorMessage) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"初始化数据失败"];
        }];
    }
}
#pragma mark - 刷新UI数据
- (void)refreshLandlordCenterUIData
{
    DDLandlordUserModel * userModel = landlordUserModel;
    if (userModel.selectedModel) {
        [self.chooseHouseListButton setNormalTitle:[userModel.selectedModel.full_name toString]];
        self.chooseHouseListButton.sizeFit = YES;
        CGFloat chooseHouseListLefImageLeft = (self.chooseHouseListButton.superview.width - self.chooseHouseLefImageView.width-self.chooseHouseListButton.width-10*kScreen6ScaleW)/2.0;
        self.chooseHouseLefImageView.left = chooseHouseListLefImageLeft;
        self.chooseHouseListButton.left = self.chooseHouseLefImageView.right6+10;
    }
    self.titleLabel.text = userModel.real_name;
}

#pragma mark - 界面的点击事件处理
/**接收通知事件*/
- (void)receivePushToDDLandlordRecordListViewController:(NSNotification *)notif
{
    BOOL isAnimated = [notif.object boolValue];
    DDLandlordRecordListViewController * vc = [[DDLandlordRecordListViewController alloc] init];
    [self pushVC:vc animated:isAnimated];

}
#pragma mark - 设置点击
- (void)settingBtnClicked
{
    DDLandlordSettingViewController * vc = [[DDLandlordSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 选择房间点击事件，选择栋楼
- (void)chooseHouseListButtonClicked
{
    DDLandlordHouseListViewController * vc = [[DDLandlordHouseListViewController alloc] init];
    WeakSelf
    [vc returnRefreshCallBlock:^(BOOL isNeed) {
        StrongSelf
        [strongSelf refreshLandlordCenterUIData];
    }];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
    }];
}
#pragma mark - 自助授权点击事件
- (void)selfHelpAuthorizationClicked
{
    DDLandlordUserModel * userModel = landlordUserModel;
    if (!userModel.selectedModel) {
        return;
    }
    DDLandlordSelfHelpAuthorizationViewController * vc = [[DDLandlordSelfHelpAuthorizationViewController alloc] init];
    [self pushVC:vc];
}
#pragma mark - 授权记录点击事件
- (void)authorizationRecordClicked
{
    DDLandlordUserModel * userModel = landlordUserModel;
    if (!userModel.selectedModel) {
        return;
    }
    DDLandlordRecordListViewController * vc = [[DDLandlordRecordListViewController alloc] init];
    [self pushVC:vc];
}



#pragma UI布局
- (void)configUI
{
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.bgImageView];
    [self.bgScrollView addSubview:self.settingButton];
    [self.bgScrollView addSubview:self.headerImageView];
    [self.bgScrollView addSubview:self.titleLabel];
/**选择小区或选择那栋楼布局*/
    UIView * chooseHouseListBgView = [self contentBgCircularViewWithFrame:CGRectMake6(15, self.titleLabel.bottom6+252/2.0, kScreen6Width-30, 148/2.0)];
    [self.bgScrollView addSubview:chooseHouseListBgView];
    [chooseHouseListBgView addSubview:self.chooseHouseLefImageView];
    [chooseHouseListBgView addSubview:self.chooseHouseListButton];
    WeakSelf
    [chooseHouseListBgView addLHDClickedHandle:^(id sender) {
        StrongSelf
        [strongSelf chooseHouseListButtonClicked];
    }];
    self.chooseHouseLefImageView.centerY = chooseHouseListBgView.height/2.0;
    self.chooseHouseListButton.centerY = self.chooseHouseLefImageView.centerY;
    CGFloat chooseHouseListLefImageLeft = (chooseHouseListBgView.width - self.chooseHouseLefImageView.width-self.chooseHouseListButton.width-10*kScreen6ScaleW)/2.0;
    self.chooseHouseLefImageView.left = chooseHouseListLefImageLeft;
    self.chooseHouseListButton.left = self.chooseHouseLefImageView.right6+10;
#pragma mark - 设置标题的最大宽度DDLandlordCommonarrowdown
    self.chooseHouseListButton.maxWidth = chooseHouseListBgView.width - self.chooseHouseLefImageView.width - 40*kScreen6ScaleW;
/**功能列表*/
    UIView * functionListBgView = [self contentBgCircularViewWithFrame:CGRectMake6(15, chooseHouseListBgView.bottom6+20/2.0, kScreen6Width-30, 120*3/2.0)];
    [self.bgScrollView addSubview:functionListBgView];
    //功能列表
    UIView * functionListView = [self contentWithImageName:nil title:@"功能列表" arrowImageName:nil isNeedBottomLine:YES font:font6Size(42/2.0)];
    [functionListBgView addSubview:functionListView];
    //自助授权
    UIView * slefHelpAuthorizationView = [self contentWithImageName:@"DDLandlordCenterSelfHelpAuthorization" title:@"自助授权" arrowImageName:@"DDLandlordCommonarrowright" isNeedBottomLine:YES font:font6Size(36/2.0)];
    slefHelpAuthorizationView.top = functionListView.bottom;
    [slefHelpAuthorizationView addLHDClickedHandle:^(id sender) {
        StrongSelf
        [strongSelf selfHelpAuthorizationClicked];
    }];
    [functionListBgView addSubview:slefHelpAuthorizationView];
    //授权记录
    UIView * recordListView = [self contentWithImageName:@"DDLandlordCenterRecordImage" title:@"授权记录" arrowImageName:@"DDLandlordCommonarrowright" isNeedBottomLine:YES font:font6Size(36/2.0)];
    recordListView.top = slefHelpAuthorizationView.bottom;
    [recordListView addLHDClickedHandle:^(id sender) {
        StrongSelf
        [strongSelf authorizationRecordClicked];
    }];
    [functionListBgView addSubview:recordListView];
    
}


#pragma mark - UI 懒加载 各个控件
/**背景bgScrollView，为了防止以后需求可以是滑动的*/
- (UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [ControlManager scrollViewWithFrame:kScreenBounds isBounces:NO isShowIndicator:NO];
    }
    return _bgScrollView;
}
/**背景图片*/
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [ControlManager imageViewWithFrame:kScreenBounds imageName:@"DDLandlordCenterBgImage"];
    }
    return _bgImageView;
}
/**设置按钮*/
- (UIButton *)settingButton
{
    if (!_settingButton) {
//        _settingImageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 0, 88/2.0, 88/2.0) imageName:@"DDLandlordCenterSettingImage"];
        _settingButton = [ControlManager buttonNormalImage:@"DDLandlordCenterSettingImage" hightLightImage:@"DDLandlordCenterSettingImage" frame:CGRectMake6(0, 0, 88/2.0, 88/2.0) target:self selector:@selector(settingBtnClicked)];
        _settingButton.right6 = kScreen6Width - 15;
        _settingButton.centerY = 24 + 30/2.0;
        _settingButton.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _settingButton;
}
/**头像*/
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 252/2.0, 144/2.0, 144/2.0) imageName:@"DDLandlordCenterHeaderImage"];
        _headerImageView.centerX = KScreenWidth/2.0;
    }
    return _headerImageView;
}
/**昵称、或者手机号*/
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [ControlManager lableFrame:CGRectMake(0, 0, KScreenWidth, font6Size(36/2.0).lineHeight) font:font6Size(36/2.0) textColor:ColorHex(@"#FFFFFF") textAligment:NSTextAlignmentCenter];
        _titleLabel.top6 = self.headerImageView.bottom6+10;
        _titleLabel.text = @"";
    }
    return _titleLabel;
}
/**选择小区旁边的图片*/
- (UIImageView *)chooseHouseLefImageView
{
    if (!_chooseHouseLefImageView) {
        _chooseHouseLefImageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 0, 68/2.0, 68/2.0) imageName:@"DDLandlordCenterChoseHoseImage"];
    }
    return _chooseHouseLefImageView;
}
/**选择小区按钮*/
- (DDHorizontalButton *)chooseHouseListButton
{
    if (!_chooseHouseListButton) {
        _chooseHouseListButton = [[DDHorizontalButton alloc] init];
        [_chooseHouseListButton setNormalTitle:@"      "];
        [_chooseHouseListButton setTitleFont:fontBold6Size(40/2.0)];
        [_chooseHouseListButton setNormalTitleColor:ColorHex(@"#4A4A4A")];
        [_chooseHouseListButton setNormalImageName:@"DDLandlordCommonarrowdown"];
        _chooseHouseListButton.padding = 20/2.0*kScreen6ScaleW;
        _chooseHouseListButton.titleIsRight = NO;
        _chooseHouseListButton.sizeFit = YES;
        _chooseHouseListButton.userInteractionEnabled = NO;
        _chooseHouseListButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _chooseHouseListButton;
}

#pragma mark - 一些基础控件的简单封装
/**圆角的白色背景*/
- (UIView *)contentBgCircularViewWithFrame:(CGRect)frame
{
    UIView * bgView = [ControlManager viewWithFrame:frame backgroundColor:[UIColor whiteColor]];
    ViewRadius(bgView, 8);
    return bgView;
}
/**图片+文字+箭头+是否需要下面的横线*/
- (UIView *)contentWithImageName:(NSString *)imageName title:(NSString *)title arrowImageName:(NSString *)arrowImageName isNeedBottomLine:(BOOL)isNeedBottomLine font:(UIFont *)font
{
    UIView * bgView = [ControlManager viewWithFrame:CGRectMake6(0, 0, kScreen6Width-30, 120/2.0) backgroundColor:[UIColor whiteColor]];
    
    CGFloat left = 15;
    if (imageName) {/**是否需要图片*/
        UIImageView * iconImageView = [ControlManager imageViewWithFrame:CGRectMake6(left, 0, 48/2.0, 48/2.0) imageName:imageName];
        [bgView addSubview:iconImageView];
        iconImageView.centerY = bgView.height/2.0;
        left = iconImageView.right6 + 10;/**改变左边的值*/
    }
    UILabel * titleLabel = [ControlManager lableFrame:CGRectZero title:title font:font textColor:ColorHex(@"#4A4A4A") textAligment:NSTextAlignmentLeft];
    [titleLabel sizeToFit];
    titleLabel.centerY = bgView.height/2.0;
    titleLabel.left6 = left;
    [bgView addSubview:titleLabel];
    if (arrowImageName) {/**是否需要箭头*/
        UIImageView * arrowImageView = [ControlManager imageViewWithImageName:arrowImageName];
        arrowImageView.right6 = bgView.width6-15;
        arrowImageView.centerY = bgView.height/2.0;
        [bgView addSubview:arrowImageView];
    }
    if (isNeedBottomLine) {/**是否需要下划线*/
        UIView * lineView = [ControlManager viewWithFrame:CGRectMake6(15, 0, bgView.width6-30, 0) backgroundColor:ColorHex(@"#DDDDDD")];
        lineView.height = 0.5;
        lineView.bottom = bgView.height;
        [bgView addSubview:lineView];
    }
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
