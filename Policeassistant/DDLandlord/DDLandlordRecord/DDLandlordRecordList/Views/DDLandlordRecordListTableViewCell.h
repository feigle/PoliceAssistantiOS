//
//  DDLandlordRecordListTableViewCell.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/9.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseTableViewCell.h"

#import "DDLandlordRecordListModel.h"

/**授权记录列表 cell*/
@interface DDLandlordRecordListTableViewCell : DDBaseTableViewCell

@property (nonatomic,strong) DDLandlordRecordListModel * model;

@end
