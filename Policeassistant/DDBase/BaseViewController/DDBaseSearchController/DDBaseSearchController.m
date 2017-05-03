//
//  DDBaseSearchDisplayController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseSearchController.h"

@interface DDBaseSearchController ()<UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic,copy) DDBaseSearchUpdateSearchResultsForSearchVCBlock searchResultBlock;
@property (nonatomic,copy) DDBaseSearchBarSearchButtonClickedSearchVCBlock searchButtonClikcedBlock;
@property (nonatomic,copy) DDBaseSearchBarSearchButtonCancelSearchVCBlock searchButtonCancelBlock;

@end
@implementation DDBaseSearchController

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
{
    self = [super initWithSearchResultsController:searchResultsController];
    if (self) {
        [self configUI:searchResultsController];
    }
    return self;
}

- (void)configUI:(UIViewController *)searchResultsController
{
    // 是否添加半透明覆盖层
    self.dimsBackgroundDuringPresentation = YES;
    if (searchResultsController) {
        searchResultsController.definesPresentationContext = YES;
    }
    self.definesPresentationContext = YES;
    self.searchResultsUpdater = self;
     //是否隐藏导航栏
    self.hidesNavigationBarDuringPresentation = YES;
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"%@",searchController.searchBar.text);
    if (self.searchResultBlock) {
        self.searchResultBlock(searchController,searchController.searchBar.text);
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchButtonClikcedBlock) {
        self.searchButtonClikcedBlock(self,searchBar);
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchButtonCancelBlock) {
        self.searchButtonCancelBlock(self,searchBar);
    }
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

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

/**搜索点击按钮*/
- (void)searchButtonClickedBlock:(DDBaseSearchBarSearchButtonClickedSearchVCBlock)block
{
    self.searchButtonClikcedBlock = block;
}
/**取消搜索点击按钮*/
- (void)cancelButtonClickedBlock:(DDBaseSearchBarSearchButtonCancelSearchVCBlock)block;
{
    self.searchButtonCancelBlock = block;
}

#pragma mark - UISearchResultsUpdating
/**时时搜索的数据*/
- (void)realTimeSearchResultsBlock:(DDBaseSearchUpdateSearchResultsForSearchVCBlock)block
{
    self.searchResultBlock = block;
}

@end
