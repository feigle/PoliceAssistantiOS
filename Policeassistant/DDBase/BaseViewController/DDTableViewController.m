//
//  DDTableViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDTableViewController.h"

@interface DDTableViewController ()

@end

@implementation DDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setTableViewStyle:(UITableViewStyle)tableViewStyle
{
    if (tableViewStyle==UITableViewStylePlain) {
        return;
    }else{
        UIView * superView = _tableView.superview;
        CGRect tableRect = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
        if (superView) {
            tableRect = _tableView.frame;
        }
        [_tableView removeFromSuperview];
        _tableView = nil;
        _tableView=[[UITableView alloc]initWithFrame:tableRect style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (superView) {
            [superView addSubview:_tableView];
        }
    }
}

- (UITableView*)tableView
{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)addHeaderRefresh
{
    [super addHeaderRefresh];
    [self.tableView addSubview:self.headerRefreshControl];
}

- (void)addFootRefresh
{
    [super addFootRefresh];
    self.tableView.mj_footer = self.footerRefreshControl;
    [self endFootRefreshNoMoreData];
}

- (void)beginHeaderRefresh
{
    [super beginHeaderRefresh];
    [self.tableView setNeedsDisplay];
}

#pragma mark- tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewController"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewController"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableView.separatorStyle == UITableViewCellSeparatorStyleNone) {
        return;
    }
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
