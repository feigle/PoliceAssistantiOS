//
//  DDLandlordRecordListViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordRecordListViewController.h"
#import "DDLandlordRecordListTableViewCell.h"
#import "DDBaseSearchController.h"
#import "DDBaseSearchResultViewController.h"
#import "DDLandlordRecordDetailViewController.h"
#import "DDLandlordRecordListModel.h"
#import "DDLandlordRecordDetailViewController.h"
#import "DDLandlordRecordEmptyListView.h"
#import "DDLandlordSelfHelpAuthorizationViewController.h"

@interface DDLandlordRecordListViewController ()

/**搜索结果数据源*/
@property (nonatomic,strong) NSMutableArray * searchResultDataArray;
/**搜索结果展示页*/
@property (nonatomic,strong) DDBaseSearchResultViewController * resultViewController;
/**搜索框*/
@property (nonatomic,strong) DDBaseSearchController *  searchController;
/**搜索框背景view*/
@property (nonatomic,strong) UIView * searchBarBgView;

/**授权记录 为空的 时候*/
@property (nonatomic,strong) DDLandlordRecordEmptyListView * recordEmptyView;

/**记录搜索的关键字*/
@property (nonatomic,strong) NSString * searchTextKey;

@end

@implementation DDLandlordRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"授权记录";
    [self configUI];
    [self headerRefreshData];
}

#pragma mark - 数据请求、数据刷新
/**下拉刷新*/
- (void)headerRefreshData
{
    [super headerRefreshData];
    [self requestRecordListData];
}
/**下拉加载更多*/
- (void)footRefreshData
{
    [super footRefreshData];
    [self requestRecordListData];
}

/**授权记录请求数据*/
- (void)requestRecordListData
{
    DDLandlordUserModel * landlordModel = landlordUserModel;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"user_id"] = [landlordModel.user_id toString];
    dict[@"token"] = landlordModel.token;
    dict[@"dep_id"] = [landlordModel.selectedModel.dep_id toString];
    dict[@"is_self_room"] = [landlordModel.selectedModel.is_self_room toString];
    dict[@"building_id"] = [landlordModel.selectedModel.building_id toString];
    dict[@"start_page"] = @(self.page);
    dict[@"page_no"] = @(self.pagesize);
    if (self.fistRequestData) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    WeakSelf
    [self getWithUrlString:DDLandlordAuthorizationsRecordsUrlStr parms:dict success:^(NSData *requestData, NSDictionary *requestDict, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        StrongSelf
        NSArray * dictsArray = requestDict[@"list"];
        if (!dictsArray.count) {
            if (strongSelf.page == 1) {
                [strongSelf.dataArray removeAllObjects];
                [strongSelf.tableView reloadData];
            }
            [strongSelf showRecordEmptyView];
            return ;
        }
        NSError * error = nil;
        NSArray * listModelArray = [DDLandlordRecordListModel arrayOfModelsFromDictionaries:dictsArray error:&error];
        if (!error) {
            if (strongSelf.page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            [strongSelf.dataArray addObjectsFromArray:listModelArray];
            [strongSelf.tableView reloadData];
        }
        [strongSelf showRecordEmptyView];
    } failure:^(NSInteger statusCode, NSError *error, NSString *errorMessage) {
        [SVProgressHUD dismiss];
        StrongSelf
        if (statusCode == 11009) {
            if (strongSelf.page == 1) {
                [strongSelf.dataArray removeAllObjects];
                [strongSelf.tableView reloadData];
            }
            [strongSelf showRecordEmptyView];
        }
    }];
}

#pragma mark - 搜索框里面的处理
#pragma mark - 时时搜索,与搜索按钮点击
- (void)realTimeSearchResults
{
    if ([self.searchTextKey removeBlank].length == 0) {
        return;
    }
    DDLandlordUserModel * landlordModel = landlordUserModel;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"user_id"] = [landlordModel.user_id toString];
    dict[@"token"] = landlordModel.token;
    dict[@"dep_id"] = [landlordModel.selectedModel.dep_id toString];
    dict[@"is_self_room"] = [landlordModel.selectedModel.is_self_room toString];
    dict[@"building_id"] = [landlordModel.selectedModel.building_id toString];
    dict[@"search_name"] = self.searchTextKey;
    dict[@"start_page"] = @(self.resultViewController.page);
    dict[@"page_no"] = @(self.resultViewController.pagesize);
    WeakSelf
    [self.resultViewController getWithUrlString:DDLandlordAuthorizationsRecordsUrlStr parms:dict success:^(NSData *requestData, NSDictionary *requestDict, NSInteger statusCode) {
        StrongSelf
        NSArray * dictsArray = requestDict[@"list"];
        if (strongSelf.resultViewController.page == 1) {
            [strongSelf.searchResultDataArray removeAllObjects];
            if (!dictsArray.count) {
                [DDProgressHUD showCenterWithText:@"房号不存在" duration:2.0];
                [strongSelf.resultViewController reloadData];
                return ;
            }
        }
        NSError * error = nil;
        NSArray * listModelArray = [DDLandlordRecordListModel arrayOfModelsFromDictionaries:dictsArray error:&error];
        if (!error) {
            [strongSelf.searchResultDataArray addObjectsFromArray:listModelArray];
            [strongSelf.resultViewController reloadData];
        }
    } failure:^(NSInteger statusCode, NSError *error, NSString *errorMessage) {
        StrongSelf
        if (statusCode == 11009) {
            [strongSelf.searchResultDataArray removeAllObjects];
            [strongSelf.resultViewController reloadData];
        }
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
    //    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.top = self.searchBarBgView.bottom;
    self.tableView.height -= self.searchBarBgView.height;
    [self.tableView registerClass:[DDLandlordRecordListTableViewCell class] forCellReuseIdentifier:@"DDLandlordRecordListTableViewCell"];
    self.tableView.backgroundColor =ColorHex(@"#EFEFF4");
    [self searchBarConfig];
    [self addHeaderRefresh];
    [self addFootRefresh];
}
#pragma mark - UITableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DDLandlordRecordListTableViewCell cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLandlordRecordListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDLandlordRecordListTableViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLandlordRecordDetailViewController * vc = [[DDLandlordRecordDetailViewController alloc] init];
    vc.recordDetailModel = self.dataArray[indexPath.row];
    WeakSelf
    [vc returnRefreshCallBlock:^(BOOL isNeed) {
        StrongSelf
        [strongSelf.tableView reloadData];
    }];
    [self pushVC:vc];
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
//            StrongSelf
//            strongSelf.resultViewController.page = 1;
//            strongSelf.searchTextKey = searchText;
//            [strongSelf realTimeSearchResults];
        }];
        /**键盘的搜索按钮 点击事件*/
        [_searchController searchButtonClickedBlock:^(UISearchController *searchVC, UISearchBar *searchBar) {
            StrongSelf
            strongSelf.resultViewController.page = 1;
            strongSelf.searchTextKey = searchBar.text;
            [strongSelf realTimeSearchResults];
        }];
        /**UISearchBar 取消按钮被点击了*/
        [_searchController cancelButtonClickedBlock:^(UISearchController *searchVC, UISearchBar *searchBar) {
            StrongSelf
            strongSelf.searchTextKey = @"";
            strongSelf.resultViewController.page = 1;
            [strongSelf.searchController.searchBar resignFirstResponder];
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
            DDLandlordRecordListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDLandlordSelfHelpAuthorizationChooseRoomCellSearchResult"];
            if (!cell) {
                cell = [[DDLandlordRecordListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DDLandlordSelfHelpAuthorizationChooseRoomCellSearchResult"];
            }
            cell.model = strongSelf.searchResultDataArray[indexPath.row];
            return cell;
        }];
        /**cell的高度*/
        [_resultViewController setHddBaseSearchHeightForRowAtIndexPath:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [DDLandlordRecordListTableViewCell cellHeight];
        }];
        /**搜索框的点击事件*/
        [_resultViewController setDdBaseSearchDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
            StrongSelf
            [strongSelf.searchController.searchBar resignFirstResponder];
            DDLandlordRecordDetailViewController * vc = [[DDLandlordRecordDetailViewController alloc] init];
            vc.recordDetailModel = strongSelf.searchResultDataArray[indexPath.row];
            [vc returnRefreshCallBlock:^(BOOL isNeed) {
                [strongSelf.resultViewController reloadData];
            }];
            [strongSelf pushVC:vc];
        }];
        /**开始拖拽的时候，这时可以做一些操作，比如：用于隐藏键盘*/
        [_resultViewController setDdBaseSearchWillBeginDragging:^{
            StrongSelf
            if (strongSelf.searchController.searchBar.isFirstResponder) {
                [strongSelf.searchController.searchBar resignFirstResponder];
            }
        }];
        [_resultViewController addHeaderRefresh];
        [_resultViewController addFootRefresh];
        /**搜索的下拉刷新*/
        [_resultViewController setDdBaseSearchHeaderRefreshData:^{
            StrongSelf
            [strongSelf realTimeSearchResults];
        }];
        /**搜索的下拉加载更多*/
        [_resultViewController setDdBaseSearchFootRefreshData:^{
            StrongSelf
            [strongSelf realTimeSearchResults];
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
#pragma mark - 显示 空的 无授权记录 页面
- (void)showRecordEmptyView
{
    if (_recordEmptyView) {
        [_recordEmptyView removeFromSuperview];
        _recordEmptyView = nil;
    }
    if (self.dataArray.count > 0) {
        return;
    }
    _recordEmptyView = [[DDLandlordRecordEmptyListView alloc] init];
    WeakSelf
    [_recordEmptyView returnRefreshCallBlock:^(BOOL isNeed) {
        StrongSelf
        DDLandlordSelfHelpAuthorizationViewController * vc = [[DDLandlordSelfHelpAuthorizationViewController alloc] init];
        [strongSelf pushVC:vc];
    }];
    [self.view addSubview:_recordEmptyView];
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
