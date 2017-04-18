//
//  DDLandlordSettingViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordSettingViewController.h"
#import "DDLandlordSettingTableViewCell.h"
#import "DDLandlordSettingTableViewHeaderView.h"
#import "DDLandlordChangePasswordViewController.h"


@interface DDLandlordSettingViewController ()

@end

@implementation DDLandlordSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self configUI];
    [self getSettingData];
    
}
#pragma mark - 获取数据，把本地的数据，对象话，容易后期的扩展
- (void)getSettingData
{
    NSArray * imageArray = @[@"DDLandlordSettingupdatapasswordimage",@"DDLandlordSettingloginoutImage"];
    NSArray * titlesArray = @[@"修改密码",@"退出"];
    NSArray * titleColorsArray = @[ColorHex(@"#4A4A4A"),ColorHex(@"#FF6666")];
    
    for (NSInteger i = 0; i < titlesArray.count; i++) {
        DDLandlordSettingModel * model = [[DDLandlordSettingModel alloc] init];
        model.imageName = imageArray[i];
        model.titleName = titlesArray[i];
        model.titleColor = titleColorsArray[i];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark - 界面布局
- (void)configUI
{
    self.view.backgroundColor = ColorHex(@"#EFEFF4");
    /**使用UITableViewStyleGrouped是为了后期好扩展业务*/
    [self.view addSubview:self.tableView];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self.tableView registerClass:[DDLandlordSettingTableViewCell class] forCellReuseIdentifier:@"DDLandlordSettingTableViewCell"];
    [self.tableView registerClass:[DDLandlordSettingTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:@"DDLandlordSettingTableViewHeaderView"];
    self.tableView.backgroundColor =ColorHex(@"#EFEFF4");

}

#pragma mark - tableView 的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DDLandlordSettingTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [DDLandlordSettingTableViewHeaderView height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DDLandlordSettingTableViewHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DDLandlordSettingTableViewHeaderView"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLandlordSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDLandlordSettingTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}
#pragma mark - 点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:/**修改密码点击*/
                {
                    DDLandlordChangePasswordViewController * vc = [[DDLandlordChangePasswordViewController alloc] init];
                    [self pushVC:vc];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:/**退出登录点击*/
                {
                    [MyAlertView showAlertViewWithTitle:@"提示" message:@"确定退出登录？" cancelButtonTitle:@"取消" otherButtonTitle:@[@"确定"] onDismiss:^(int buttonIndex) {
                        [DDUserDefault setLogin:NO];
                        [DDUserDefault setIdentityType:PoliceAssistantNoLoginType];
                        [DDLandlordUserModel deleteMyself];
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(PoliceAssistantNoLoginType)];
                    } onCancel:^{
                        
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
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
