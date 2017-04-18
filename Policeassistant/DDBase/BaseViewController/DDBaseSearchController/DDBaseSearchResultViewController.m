//
//  DDBaseSearchResultViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseSearchResultViewController.h"

@interface DDBaseSearchResultViewController ()

@end

@implementation DDBaseSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DaohangCOLOR;
    self.definesPresentationContext = YES;
    [self.view addSubview:self.tableView];
    self.tableView.top = 64;
    self.tableView.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_ddBaseNumberOfSectionsInTableView) {
        return _ddBaseNumberOfSectionsInTableView(tableView);
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_ddBaseSearchNumberOfRowsInSection) {
        return _ddBaseSearchNumberOfRowsInSection(tableView,section);
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ddBaseSearchCellForRowAtIndexPath) {
        return _ddBaseSearchCellForRowAtIndexPath(tableView, indexPath);
    }
    else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellCCCCCCCCDDBaseSearchDisplayController"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellCCCCCCCCDDBaseSearchDisplayController"];
        }
        return cell;
    }
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (_ddBaseSearchCanEditRowAtIndexPath) {
        return _ddBaseSearchCanEditRowAtIndexPath(tableView, indexPath);
    }
    else{
        return NO;
    }
}
#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hddBaseSearchHeightForRowAtIndexPath) {
        return _hddBaseSearchHeightForRowAtIndexPath(tableView, indexPath);
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ddBaseSearchDidSelectRowAtIndexPath) {
        return _ddBaseSearchDidSelectRowAtIndexPath(tableView, indexPath);
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ddBaseSearchDidDeselectRowAtIndexPath) {
        _ddBaseSearchDidDeselectRowAtIndexPath(tableView, indexPath);
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_ddBaseSearchWillBeginDragging) {
        _ddBaseSearchWillBeginDragging();
    }
    NSLog(@"开始拖拽的时候");
}

/**刷新数据*/
- (void)reloadData
{
    [self.tableView reloadData];
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
