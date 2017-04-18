//
//  DDLandlordSelfHelpAuthorizationChooseRoomVC.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordSelfHelpAuthorizationChooseRoomVC.h"
#import "DDLandlordSelfHelpAuthorizationChooseRoomCell.h"
#import "DDLandlordSettingTableViewHeaderView.h"
#import "DDBaseSearchController.h"
#import "DDBaseSearchResultViewController.h"

@interface DDLandlordSelfHelpAuthorizationChooseRoomVC ()<UISearchBarDelegate>

/**搜索结果数据源*/
@property (nonatomic,strong) NSMutableArray * searchResultDataArray;
/**搜索结果展示页*/
@property (nonatomic,strong) DDBaseSearchResultViewController * resultViewController;
/**搜索框*/
@property (nonatomic,strong) DDBaseSearchController *  searchController;
/**搜索框背景view*/
@property (nonatomic,strong) UIView * searchBarBgView;


@end

@implementation DDLandlordSelfHelpAuthorizationChooseRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择房号";
    [self configUI];
    [self headerRefreshData];
    
}

#pragma mark - 数据请求  与数据处理  在这里
/**下拉刷新数据*/
- (void)headerRefreshData
{
    [super headerRefreshData];
    [self requestBuildingRoomsData];
}
/**上拉加载更多数据*/
- (void)footRefreshData
{
    [super footRefreshData];
    [self requestBuildingRoomsData];
}
/**请求 房屋信息*/
- (void)requestBuildingRoomsData
{
    DDLandlordUserModel * landlordModel = landlordUserModel;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"building_id"] = [landlordModel.selectedModel.building_id toString];
    dict[@"start_page"] = @(self.page);
    dict[@"page_no"] = @(self.pagesize);
    dict[@"token"] = landlordModel.token;
    dict[@"is_self_room"] = [landlordModel.selectedModel.is_self_room toString];
    if (self.fistRequestData) {
        [SVProgressHUD showWithStatus:@"获取房号中..."];
    }
    WeakSelf
    [self getWithUrlString:DDLandlordEstatesRoom_numbersUrlStr parms:dict success:^(NSData *requestData, NSDictionary *requestDict, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        StrongSelf
        NSArray * dictsArray = requestDict[@"list"];
        if (!dictsArray.count) {
            if (strongSelf.page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            [strongSelf.tableView reloadData];
            return ;
        }
        NSError * error = nil;
        NSArray * listModelArray = [DDLandlordSelfHelpAuthorizationChooseRoomModel arrayOfModelsFromDictionaries:dictsArray error:&error];
        if (!error) {
            if (strongSelf.page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            [strongSelf.dataArray addObjectsFromArray:listModelArray];
            [strongSelf.tableView reloadData];
        }
    } failure:^(NSInteger statusCode, NSError *error, NSString *errorMessage) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 搜索框里面的处理
#pragma mark - 时时搜索,与搜索按钮点击
- (void)realTimeSearchResultsSearchKey:(NSString *)serachKey
{
    if ([serachKey removeBlank].length == 0) {
        return;
    }
    DDLandlordUserModel * landlordModel = landlordUserModel;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"building_id"] = [landlordModel.selectedModel.building_id toString];
    dict[@"search_name"] = serachKey;
    dict[@"is_self_room"] = [landlordModel.selectedModel.is_self_room toString];
    dict[@"start_page"] = @(0);
    dict[@"page_no"] = @(99999);
    dict[@"token"] = landlordModel.token;
    WeakSelf
    [DDHttpRequest getWithUrlString:DDLandlordEstatesRoom_numbersUrlStr parms:[DDHttpRequest handleParametersSHA1:dict] success:^(NSData *requestData, NSDictionary *requestDict, NSInteger statusCode) {
        StrongSelf
        NSArray * dictsArray = requestDict[@"list"];
        [strongSelf.searchResultDataArray removeAllObjects];
        if (!dictsArray.count) {
            [DDProgressHUD showCenterWithText:@"刚房号不存在" duration:2.0];
            [strongSelf.resultViewController reloadData];
            return ;
        }
        NSError * error = nil;
        NSArray * listModelArray = [DDLandlordSelfHelpAuthorizationChooseRoomModel arrayOfModelsFromDictionaries:dictsArray error:&error];
        if (!error) {
            [strongSelf.searchResultDataArray addObjectsFromArray:listModelArray];
        }
        [strongSelf.resultViewController reloadData];
    } failure:^(NSInteger statusCode, NSError *error, NSString *errorMessage) {
        
    }];
}

#pragma mark - 界面布局
- (void)configUI
{
    [self.view addSubview:self.searchBarBgView];
    [self.searchBarBgView addSubview:self.searchController.searchBar];
#pragma mark - 添加UI
    [self.view addSubview:self.tableView];
#pragma mark - tableView 的一些设置
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.top = self.searchBarBgView.bottom;
    self.tableView.height -= self.searchBarBgView.height;
    [self.tableView registerClass:[DDLandlordSelfHelpAuthorizationChooseRoomCell class] forCellReuseIdentifier:@"DDLandlordSelfHelpAuthorizationChooseRoomCell"];
    [self.tableView registerClass:[DDLandlordSettingTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:@"DDLandlordSettingTableViewHeaderView"];
    self.tableView.backgroundColor =ColorHex(@"#EFEFF4");
    [self searchBarConfig];
    [self addFootRefresh];
    [self addHeaderRefresh];
}
#pragma mark - UITableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DDLandlordSelfHelpAuthorizationChooseRoomCell cellHeight];
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
    DDLandlordSelfHelpAuthorizationChooseRoomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDLandlordSelfHelpAuthorizationChooseRoomCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLandlordUserModel * landlordModel = landlordUserModel;
    DDLandlordSelfHelpAuthorizationChooseRoomModel * model = self.dataArray[indexPath.row];
    model.selected = YES;
    model.dep_id = [landlordModel.selectedModel.dep_id toString];
    [self.tableView reloadData];
    if (self.retrunObjectBlock) {
        self.retrunObjectBlock(model);
    }
    [self navLeftItemClick:0];
}

#pragma mark - 搜索控制器，一些代理方法也在这类
- (DDBaseSearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[DDBaseSearchController alloc]    initWithSearchResultsController:self.resultViewController];
        self.definesPresentationContext = YES;
        WeakSelf
        /** 时时更新搜索 */
        [_searchController realTimeSearchResultsBlock:^(UISearchController *searchVC, NSString *searchText) {
            StrongSelf
            [strongSelf realTimeSearchResultsSearchKey:searchText];
        }];
        /**键盘的搜索按钮 点击事件*/
        [_searchController searchButtonClickedBlock:^(UISearchController *searchVC, UISearchBar *searchBar) {
            StrongSelf
            [strongSelf realTimeSearchResultsSearchKey:searchBar.text];
        }];
        /**UISearchBar 取消按钮被点击了*/
        [_searchController cancelButtonClickedBlock:^(UISearchController *searchVC, UISearchBar *searchBar) {
            StrongSelf
            [strongSelf.searchResultDataArray removeAllObjects];
            [strongSelf.resultViewController reloadData];
        }];
    }
    return _searchController;
}
#pragma mark - searchBarBgView 的背景view
- (UIView *)searchBarBgView
{
    if (!_searchBarBgView) {
        _searchBarBgView = [ControlManager viewWithFrame:CGRectMake(0, 0, KScreenWidth, self.searchController.searchBar.height) backgroundColor:DaohangCOLOR];
    }
    return _searchBarBgView;
}

#pragma mark - 显示结果的控制器
- (DDBaseSearchResultViewController *)resultViewController
{
    if (!_resultViewController) {
        _resultViewController = [[DDBaseSearchResultViewController alloc] init];
        /**返回搜索结果的个数*/
        WeakSelf
        [_resultViewController setDdBaseSearchNumberOfRowsInSection:^NSInteger(UITableView * tableView, NSInteger section) {
            StrongSelf
            return strongSelf.searchResultDataArray.count;
        }];
        /**返回cell*/
        [_resultViewController setDdBaseSearchCellForRowAtIndexPath:^UITableViewCell *(UITableView * tableView, NSIndexPath *indexPath) {
            StrongSelf
            DDLandlordSelfHelpAuthorizationChooseRoomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDLandlordSelfHelpAuthorizationChooseRoomCellSearchResult"];
            if (!cell) {
                cell = [[DDLandlordSelfHelpAuthorizationChooseRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DDLandlordSelfHelpAuthorizationChooseRoomCellSearchResult"];
            }
            cell.model = strongSelf.searchResultDataArray[indexPath.row];
            return cell;
        }];
        /**cell的高度*/
        [_resultViewController setHddBaseSearchHeightForRowAtIndexPath:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [DDLandlordSelfHelpAuthorizationChooseRoomCell cellHeight];
        }];
        /**搜索框的点击事件*/
        [_resultViewController setDdBaseSearchDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
            StrongSelf
            [strongSelf.searchController.searchBar resignFirstResponder];
            DDLandlordUserModel * landlordModel = landlordUserModel;
            DDLandlordSelfHelpAuthorizationChooseRoomModel * model = strongSelf.searchResultDataArray[indexPath.row];
            model.selected = YES;
            model.dep_id = [landlordModel.selectedModel.dep_id toString];
            [strongSelf.resultViewController reloadData];
            if (strongSelf.retrunObjectBlock) {
                strongSelf.retrunObjectBlock(model);
            }
            [strongSelf navLeftItemClick:0];
        }];
        /**开始拖拽的时候，这时可以做一些操作，比如：用于隐藏键盘*/
        [_resultViewController setDdBaseSearchWillBeginDragging:^{
            StrongSelf
            if (strongSelf.searchController.searchBar.isFirstResponder) {
                [strongSelf.searchController.searchBar resignFirstResponder];
            }
        }];
    }
    return _resultViewController;
}
/**搜索结果数据源*/
- (NSMutableArray *)searchResultDataArray
{
    if (!_searchResultDataArray) {
        _searchResultDataArray = [NSMutableArray array];
    }
    return _searchResultDataArray;
}

#pragma mark - UISearchBar 设置
///**搜索框*/
-(void)searchBarConfig
{
    UISearchBar * _searchBar = _searchController.searchBar;
    //    _searchBar.frame = CGRectMake6(15, 15, kScreen6Width-30, 56/2.0);
    _searchBar.backgroundColor = DaohangCOLOR;
    _searchBar.barTintColor = DaohangCOLOR;
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.placeholder = @"请输入房号";
    _searchBar.layer.masksToBounds = YES;
    _searchBar.delegate = self;
    //删除原有的background,直接设置搜索框颜色
    [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    //拿出输入框控件对其设置字体及背景颜色
    [_searchBar setImage:[UIImage imageNamed:@"DDBaseSearchVCImagesSearchImage"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [_searchBar setImage:[UIImage imageNamed:@"DDBaseSearchVCImagesDeleteImage"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [_searchBar setImage:[UIImage imageNamed:@"DDBaseSearchVCImagesDeleteImage"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    _searchBar.tintColor = [UIColor whiteColor];
     UITextField * _searchField = [_searchBar valueForKey:@"_searchField"];
    _searchField.backgroundColor = [UIColor colorWithRed:0.15 green:0.31 blue:0.67 alpha:1.00];
    [_searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _searchField.textColor = [UIColor whiteColor];
    [_searchBar sizeToFit];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
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
