//
//  DDLandlordRecordListModel.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/9.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseModel.h"

/**授权记录列表 模型*/
@interface DDLandlordRecordListModel : DDBaseModel

@property (nonatomic,copy) NSString * mid;//授权记录ID
@property (nonatomic,copy) NSString * be_author;//被授权人名字
@property (nonatomic,copy) NSString * app_auth_status;//APP授权状态，开通、关闭
@property (nonatomic,strong) NSString * app_status_code;//1不开通授权，2申请开通授权
@property (nonatomic,copy) NSString * card_auth_status;//卡授权状态，开通、关闭
@property (nonatomic,strong) NSString * card_status_code;//1不开通授权，2申请开通授权
@property (nonatomic,copy) NSString * apply_room_no;//申请房号

@property (nonatomic,copy) NSString * apply_time;//申请时间
@property (nonatomic,copy) NSString * mobile_number;//手机号码
@property (nonatomic,copy) NSString * apply_identity;//申请身份
@property (nonatomic,copy) NSString * app_start_time;//APP授权开始时间
@property (nonatomic,copy) NSString * app_auth_deadline;//APP授权期限
@property (nonatomic,copy) NSString * card_auth_deadline;//卡授权期限
@property (nonatomic,copy) NSString * door_auth_code;//门禁授权编码

@end
