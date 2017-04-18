//
//  DDLandlordSelfHelpAuthorizationModel.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/16.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseModel.h"
#import "DDIdentifyCardSideFrontModel.h"
#import "DDIdentifyCardSideBackModel.h"

/**自助授权模型*/
@interface DDLandlordSelfHelpAuthorizationModel : DDBaseModel

@property (nonatomic,strong) NSString * user_id;//用户ID
@property (nonatomic,strong) NSString * room_number_id;//房间ID
@property (nonatomic,strong) NSString * dep_id;//小区ID
@property (nonatomic,strong) NSString * real_name;//真实姓名
@property (nonatomic,strong) NSString * mobile_no;//手机号
@property (nonatomic,strong) NSString * card_status_code;//1不开通授权，2申请开通授权
@property (nonatomic,strong) NSString * app_status_code;//1不开通授权，2申请开通授权
@property (nonatomic,strong) NSString * auth_type;//授权信息，授权类型：0业主，1家人，2租客，3临时客人
@property (nonatomic,strong) NSString * auth_end_time;//授权结束时间
@property (nonatomic,strong) NSString * auth_start_time;//授权开始时间
@property (nonatomic,strong) NSString * card_img1;//身份证正面照
@property (nonatomic,strong) NSString * card_img2;//身份证反面照
@property (nonatomic,strong) NSString * card_img3;//身份证手持照
@property (nonatomic,strong) NSString * card_no;//身份证号
@property (nonatomic,strong) NSString * card_name;//身份证名字
@property (nonatomic,strong) NSString * sex;//性别 ：1男，2女
@property (nonatomic,strong) NSString * nation;//民族
@property (nonatomic,strong) NSString * birthday;//生日
@property (nonatomic,strong) NSString * address;//户籍地址
@property (nonatomic,strong) NSString * government;//发证机关
@property (nonatomic,strong) NSString * validity;//有效期
@property (nonatomic,strong) NSString * nation_code;//国家码
@property (nonatomic,strong) NSString * token;//token令牌

/**身份证正面的模型*/
@property (nonatomic,strong) DDIdentifyCardSideFrontModel *identifyCardFrontModel;
/**身份证反面的模型*/
@property (nonatomic,strong) DDIdentifyCardSideBackModel *identifyCardBackModel;

- (NSDictionary *)returnDataDict;

@end
