//
//  DDBaseSearchDisplayController.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DDBaseSearchUpdateSearchResultsForSearchVCBlock)(UISearchController * searchVC,NSString * searchText);
typedef void (^DDBaseSearchBarSearchButtonClickedSearchVCBlock)(UISearchController * searchVC,UISearchBar * searchBar);
typedef void (^DDBaseSearchBarSearchButtonCancelSearchVCBlock)(UISearchController * searchVC,UISearchBar * searchBar);

/**不考虑多个 section 的情况*/
@interface DDBaseSearchController : UISearchController

/**时时搜索的数据*/
- (void)realTimeSearchResultsBlock:(DDBaseSearchUpdateSearchResultsForSearchVCBlock)block;
/**搜索点击按钮*/
- (void)searchButtonClickedBlock:(DDBaseSearchBarSearchButtonClickedSearchVCBlock)block;
/**取消搜索点击按钮*/
- (void)cancelButtonClickedBlock:(DDBaseSearchBarSearchButtonCancelSearchVCBlock)block;

@end
