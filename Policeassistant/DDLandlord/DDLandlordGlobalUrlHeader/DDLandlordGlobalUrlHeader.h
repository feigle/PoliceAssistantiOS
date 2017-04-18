//
//  DDLandlordGlobalUrlHeader.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#ifndef DDLandlordGlobalUrlHeader_h
#define DDLandlordGlobalUrlHeader_h

#import "DDLandlordUserModel.h"


#if DDReleaseStatus
#define DDLandlordBaseUrl     @"https://ssl.beta.doordu.com:8001/police/"
#else
//#define DDLandlordBaseUrl     @"https://ssl.test.doordu.com:8001/police/"
#define DDLandlordBaseUrl     @"http://10.0.1.124:8001/police/"
#endif

/*******************    注册登录    *************************/
/**登录*/
#define DDUsersLoginUrlStr strConcat(DDLandlordBaseUrl,@"v3/users/login")
/**房东修改密码*/
#define DDLandlordUsersPasswordsUrlStr strConcat(DDLandlordBaseUrl,@"v3/users/passwords")
/**房东栋列表*/
#define DDLandlordEstatesBuildingsUrlStr strConcat(DDLandlordBaseUrl,@"v3/estates/buildings")
/**房东房号列表*/
#define DDLandlordEstatesRoom_numbersUrlStr strConcat(DDLandlordBaseUrl,@"v3/estates/room_numbers")
/**房东授权记录*/
#define DDLandlordAuthorizationsRecordsUrlStr strConcat(DDLandlordBaseUrl,@"v3/authorizations/records")


#endif /* DDLandlordGlobalUrlHeader_h */
