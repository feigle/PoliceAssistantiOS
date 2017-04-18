//
//  DDBulidSearchViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/30.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDBulidSearchViewController.h"
#import "DDCellSearchVC.h"
#import "DDRoomSearchViewController.h"

@interface DDBulidSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSString *urlStr;
    NSMutableArray *DataArray;
    NSMutableArray * _subDataArray;
}
@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic , retain) UISearchBar *searchBar;
@property(nonatomic,strong)DDEmptyView *empview;
@end

@implementation DDBulidSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=_nagtiontitle;
    NSLog(@"communityId==%@",_communityid);
    DataArray=[[NSMutableArray alloc] init];
    urlStr=[NSString stringWithFormat:@"%@%@",API_BASE_URL(@"v1/site/building?communityid="),_communityid];
    DataArray=[DDNetCache cacheJsonWithURL:urlStr];
    [self getNetWorkData];
    
    UIImage *img=[self imageWithColor:DaohangCOLOR];
    [self.navigationController.navigationBar setBackgroundImage:img forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-114) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder=@"请输入楼栋数，例：1栋";
    self.searchBar.backgroundColor = RGBACOLOR(249,249,249,1);
    self.searchBar.backgroundImage = [self imageWithColor:DaohangCOLOR size:self.searchBar.bounds.size];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:TEXCOLOR forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:self.searchBar];
    [self setSearchTextFieldBackgroundColor:UIColorFromRGB(0x2452C3)];
    
    //数据源
    _subDataArray = [[NSMutableArray alloc] initWithArray:DataArray];
    
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.returnKeyType=UIReturnKeySearch;
    _empview=[[DDEmptyView alloc]init];
    
}
#pragma mark UISearchBarDelegate
//此方法实时监测搜索框中文本变化
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString * getStr = searchBar.text;
    [_subDataArray removeAllObjects];
    
    if (getStr.length == 0) {
        [_subDataArray addObjectsFromArray:DataArray];
        [self.tableView reloadData];
    }else {
        //从备份数据源查找符合条件的数据，并加入到数据源中
 
        for (int i=0; i<DataArray.count; i++) {
            NSDictionary *dic=[DataArray objectAtIndex:i];
            NSString *str1=dic[@"buildname"];
            NSString *str2=dic[@"buildid"];
            NSRange range=[str1 rangeOfString:getStr];
            if (range.location!=NSNotFound) {
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:str1,@"buildname",str2,@"buildid", nil];
                [_subDataArray addObject:dict];
            }
    }
        //更新UI
        [self.tableView reloadData];
        //让键盘失去第一响应者
      //  [searchBar resignFirstResponder];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   [searchBar resignFirstResponder];
}

#pragma mark 纯色转成图片
-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor{
    UIView *searchTextField = nil;
    searchTextField = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = backgroundColor;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_subDataArray.count) {
        [_empview showCenterWithSuperView:self.tableView icon:@"empty_fancy" state:@"暂无相关数据"];
        return 0;
    }else{
        [_empview removeFromSuperview];
        return [_subDataArray count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    

    NSDictionary *dic=[_subDataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=dic[@"buildname"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *Dic=[_subDataArray objectAtIndex:indexPath.row];
    DDRoomSearchViewController*vc=[[DDRoomSearchViewController alloc]init];
    vc.buildid=[NSString stringWithFormat:@"%@",Dic[@"buildid"]];
    vc.nagtiontitle=[NSString stringWithFormat:@"%@",Dic[@"buildname"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getNetWorkData{
    [_subDataArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
//    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:_communityid,@"communityid",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:urlStr withParameters:nil withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                [SVProgressHUD dismiss];
                DataArray=dic[@"data"];
                BOOL result = [DDNetCache saveJsonResponseToCacheFile:DataArray andURL:urlStr];
                if(result) NSLog(@"(同步)写入/更新缓存数据 成功");
                for (unsigned i = 0; i < [DataArray count]; i++){
                    
                    if ([_subDataArray containsObject:[DataArray objectAtIndex:i]] == NO){
                        
                        [_subDataArray addObject:[DataArray objectAtIndex:i]];
                    }
                }
              //  [_subDataArray addObjectsFromArray:DataArray];
                [self.tableView reloadData];
            }
            else if ([Error_Code_Failed isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }else if ([Error_Code_RequestError isEqualToString:msg]){
                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }
            
        }else{
            
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){

    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_searchBar resignFirstResponder];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
