//
//  DDTableViewController.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/7.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "HttpRequestViewController.h"

@interface DDTableViewController : HttpRequestViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) UITableViewStyle tableViewStyle;


@end
