//
//  DDLandlordSelfHelpAuthorizationModel.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/16.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordSelfHelpAuthorizationModel.h"

@implementation DDLandlordSelfHelpAuthorizationModel

- (void)setIdentifyCardFrontModel:(DDIdentifyCardSideFrontModel *)identifyCardFrontModel
{
    _card_no = [identifyCardFrontModel.id_card_number toString];
    _card_name = [identifyCardFrontModel.name toString];
    _sex = [[identifyCardFrontModel.gender toString] isEqualToString:@"男"]?@"1":@"2";
    _nation = [identifyCardFrontModel.race toString];
    _birthday = [identifyCardFrontModel.birthday toString];
    _address = [identifyCardFrontModel.address toString];
}

- (void)setIdentifyCardBackModel:(DDIdentifyCardSideBackModel *)identifyCardBackModel
{
    _government = [identifyCardBackModel.issued_by toString];
    _validity = [identifyCardBackModel.valid_date toString];
}

- (NSDictionary *)returnDataDict
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"user_id"] = [_user_id toString];
    dict[@"room_number_id"] = [_room_number_id toString];
    dict[@"dep_id"] = [_dep_id toString];
    dict[@"mobile_no"] = [_mobile_no toString];
    dict[@"card_status_code"] = [_card_status_code toString];
    dict[@"app_status_code"] = [_app_status_code toString];
    dict[@"auth_type"] = [_auth_type toString];
    dict[@"auth_start_time"] = [_auth_start_time toString];
    dict[@"auth_end_time"] = [_auth_end_time toString];
    dict[@"card_img1"] = [_card_img1 toString];
    dict[@"card_img2"] = [_card_img2 toString];
    dict[@"card_img3"] = [_card_img3 toString];
    dict[@"card_no"] = [_card_no toString];
    
    dict[@"card_name"] = _card_name;
    dict[@"nation"] = _nation;
    dict[@"address"] = _address;
    dict[@"government"] = _government;
    dict[@"real_name"] = [_real_name toString];
    
//    dict[@"card_name"] = @"test";
//    dict[@"nation"] = @"test";
//    dict[@"address"] = @"test";
//    dict[@"government"] = @"test";
//    dict[@"real_name"] = @"test";

    dict[@"sex"] = [_sex toString];
    dict[@"birthday"] = [_birthday toString];
    dict[@"validity"] = [_validity toString];
    dict[@"nation_code"] = @"86";
    dict[@"token"] = [_token toString];
    return dict;
}

@end
