//
//  DDSystemMessageVC.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/5.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDSystemMessageVC.h"
#import "DDSystemMessCell.h"
#import "DDTaskDetailViewController.h"

@interface DDSystemMessageVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , retain) UITableView *tableView;

@end

@implementation DDSystemMessageVC

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.frame=CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64);
        _tableView.rowHeight=85;
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.tableFooterView=[[UIView alloc] init];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"系统消息";
    [self.view addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ID=@"CellId";
    DDSystemMessCell*cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[DDSystemMessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  DDTaskDetailViewController*vc=[[DDTaskDetailViewController alloc]init];
  //  [self.navigationController pushViewController:vc animated:YES];
}

@end
