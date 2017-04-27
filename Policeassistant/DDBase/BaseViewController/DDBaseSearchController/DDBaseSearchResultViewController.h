//
//  DDBaseSearchResultViewController.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDTableViewController.h"

@interface DDBaseSearchResultViewController : DDTableViewController<UITableViewDataSource, UITableViewDelegate>

/**返回当前的cell*/
@property (nonatomic,copy) UITableViewCell * (^ddBaseSearchCellForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/**是否可以编辑*/
@property (nonatomic,copy) BOOL (^ddBaseSearchCanEditRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/**当前cell的高度*/
@property (nonatomic,copy) CGFloat (^hddBaseSearchHeightForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/**选中的行*/
@property (nonatomic,copy) void (^ddBaseSearchDidSelectRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/**反选中的行*/
@property (nonatomic,copy) void (^ddBaseSearchDidDeselectRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/**section 对应的多少row*/
@property (nonatomic,copy) NSInteger (^ddBaseSearchNumberOfRowsInSection)(UITableView *tableView, NSInteger section);
/**有多少个 section*/
@property (nonatomic,copy) NSInteger (^ddBaseNumberOfSectionsInTableView)(UITableView *tableView);

/**开始拖拽的时候，这时可以做一些操作，比如：用于隐藏键盘*/
@property (nonatomic,copy) void (^ddBaseSearchWillBeginDragging)();
/**下拉刷新*/
@property (nonatomic,copy) void (^ddBaseSearchHeaderRefreshData)();
/**上拉加载更多*/
@property (nonatomic,copy) void (^ddBaseSearchFootRefreshData)();

/**刷新数据*/
- (void)reloadData;

@end
