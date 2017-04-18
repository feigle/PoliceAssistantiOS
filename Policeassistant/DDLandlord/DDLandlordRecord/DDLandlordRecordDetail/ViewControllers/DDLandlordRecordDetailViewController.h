//
//  DDLandlordRecordDetailViewController.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "HttpRequestViewController.h"

#import "DDLandlordRecordListModel.h"

@interface DDLandlordRecordDetailViewController : HttpRequestViewController


/**授权记录详情模型*/
@property (nonatomic,strong) DDLandlordRecordListModel * recordDetailModel;

@end
