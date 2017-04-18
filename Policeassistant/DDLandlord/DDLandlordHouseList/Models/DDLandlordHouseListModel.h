//
//  DDLandlordHouseListModel.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseModel.h"

@interface DDLandlordHouseListModel : DDBaseModel

@property (nonatomic,assign) BOOL selected;//是否被选中了，默认为NO
@property (nonatomic,strong) NSString * dep_id;//小区ID
@property (nonatomic,strong) NSString * unit_id;//单元id
@property (nonatomic,strong) NSString * dep_name;//小区名称
@property (nonatomic,strong) NSString * building_id;//栋ID
@property (nonatomic,strong) NSString * building_no;//栋号
@property (nonatomic,strong) NSString * building_name;//栋名称
@property (nonatomic,strong) NSString * full_name;//小区栋全称
@property (nonatomic,strong) NSString * is_self_room;//1自建房 非1非自建房
@property (nonatomic,strong) NSString * token;//token令牌

@end
