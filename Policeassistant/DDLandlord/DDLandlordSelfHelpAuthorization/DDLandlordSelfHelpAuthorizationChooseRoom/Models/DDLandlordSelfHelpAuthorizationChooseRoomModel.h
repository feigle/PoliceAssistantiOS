//
//  DDLandlordSelfHelpAuthorizationChooseRoomModel.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/9.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseModel.h"

/**选择房号的model*/
@interface DDLandlordSelfHelpAuthorizationChooseRoomModel : DDBaseModel

/**是否被选中，默认是NO*/
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,copy) NSString * room_number_id;//房间ID
@property (nonatomic,copy) NSString * room_number;//房间号码
@property (nonatomic,copy) NSString * dep_id;//小区ID

@end
