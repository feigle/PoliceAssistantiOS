//
//  DDLandlordHouseListViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordHouseListViewController.h"
#import "DDLandlordHouseListTableViewCell.h"
#import "DDLandlordSettingTableViewHeaderView.h"

@interface DDLandlordHouseListViewController ()

/**当前被选中的那个*/
//@property (nonatomic,strong) DDLandlordHouseListModel * selectedModel;

@end

@implementation DDLandlordHouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"切换房产";
    [self configUI];
    [self.tableView reloadData];
    [self headerRefreshData];
}

#pragma mark - 一些数据的请求与处理
/**下拉请求数据*/
- (void)headerRefreshData
{
    [super headerRefreshData];
    [self requestLandlordHouseData];
}
/**房东栋列表 数据*/
- (void)requestLandlordHouseData
{
    DDLandlordUserModel * landlordModel = landlordUserModel;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"user_id"] = [landlordModel.user_id toString];
    dict[@"user_name"] = [landlordModel.user_name toString];
    dict[@"token"] = landlordModel.token;
    if (self.fistRequestData) {
//        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    [SVProgressHUD dismiss];
    WeakSelf
    [self getWithUrlString:DDLandlordEstatesBuildingsUrlStr parms:dict success:^(NSData *requestData, NSDictionary *requestDict, NSInteger statusCode) {
//        [SVProgressHUD dismiss];
        StrongSelf
        NSArray * dictsArray = requestDict[@"list"];
        if (!dictsArray.count) {
            landlordModel.landlordHouseListDataArray = @[];
            [strongSelf.tableView reloadData];
            return ;
        }
        NSError * error = nil;
        NSArray * listModelArray = [DDLandlordHouseListModel arrayOfModelsFromDictionaries:dictsArray error:&error];
        if (landlordModel.selectedModel) {
            DDLandlordHouseListModel * sleectModel = nil;
            for (DDLandlordHouseListModel * model in listModelArray) {
                if ([[model.building_id toString] isEqualToString:landlordModel.selectedModel.building_id] && [[model.building_no toString] isEqualToString:landlordModel.selectedModel.building_no]) {
                    model.selected = YES;
                    sleectModel = model;
                    break;
                }
            }
            if (!sleectModel) {
                landlordModel.selectedModel = listModelArray[0];
                landlordModel.selectedModel.selected = YES;
            } else {
                landlordModel.selectedModel = sleectModel;
            }
        } else {
            landlordModel.selectedModel = listModelArray[0];
            landlordModel.selectedModel.selected = YES;
        }
        landlordModel.landlordHouseListDataArray = listModelArray;
        [DDLandlordUserModel saveMySelf];
        if (strongSelf.retrunRefreshBlock) {
            strongSelf.retrunRefreshBlock(YES);
        }
        [strongSelf.tableView reloadData];
    } failure:^(NSInteger statusCode, NSError *error, NSString *errorMessage) {
//        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 界面布局
- (void)configUI
{
    self.view.backgroundColor = ColorHex(@"#EFEFF4");
#pragma mark - 设置导航按钮
    [self setLeftItemImageName:@"DDLandlordHouseListCloseImage"];
    [self setRightItemImageName:@"DDLandlordHouseListRefreshDataImage"];
#pragma mark - 添加UI
    [self.view addSubview:self.tableView];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self.tableView registerClass:[DDLandlordHouseListTableViewCell class] forCellReuseIdentifier:@"DDLandlordHouseListTableViewCell"];
    [self.tableView registerClass:[DDLandlordSettingTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:@"DDLandlordSettingTableViewHeaderView"];
    self.tableView.backgroundColor =ColorHex(@"#EFEFF4");
    [self addHeaderRefresh];
}

/**右侧刷新被点击了*/
- (void)navRightItemClick:(NSInteger)index
{
    [self headerRefreshData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DDLandlordUserModel * landlordModel = landlordUserModel;
    return landlordModel.landlordHouseListDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DDLandlordHouseListTableViewCell cellHeight];
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
    DDLandlordHouseListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDLandlordHouseListTableViewCell" forIndexPath:indexPath];
    DDLandlordUserModel * landlordModel = landlordUserModel;
    cell.model = landlordModel.landlordHouseListDataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLandlordUserModel * landlordModel = landlordUserModel;
    landlordModel.selectedModel.selected = NO;
    
    DDLandlordHouseListModel * model = landlordModel.landlordHouseListDataArray[indexPath.row];
    model.selected = YES;
    landlordModel.selectedModel = model;
    [self.tableView reloadData];
    [DDLandlordUserModel saveMySelf];
    if (self.retrunRefreshBlock) {
        self.retrunRefreshBlock(YES);
    }
    [super navLeftItemClick:0];
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
