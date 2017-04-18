//
//  SystemNS_enumHeader.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#ifndef SystemNS_enumHeader_h
#define SystemNS_enumHeader_h


/***警察助手中，各个用户的类型*/
/**[1=>'管理员',2=>'民警',3=>'协警',4=>'保安',5=>'物业',6=>'房东'];*/
typedef NS_ENUM(NSInteger,PoliceAssistantIdentityType) {
    PoliceAssistantNoLoginType = 0,//没有登录
    PoliceAssistantIdentityAdministratorType = 1,//管理员
    PoliceAssistantIdentityPoliceType = 2,//民警
    PoliceAssistantIdentityPoliceAssistType = 3,//协警
    PoliceAssistantIdentityPublicSecurityType = 4,//保安
    PoliceAssistantIdentityPropertyType = 5,//物业
    PoliceAssistantIdentityLandlordType = 6,//房东
};

/***身份证的正反面*/
typedef NS_ENUM(NSInteger,IdentifyCardSideType) {
    IdentifyCardTypeErrorType = 0,//不是身份证
    IdentifyCardSideFrontType = 1,//身份证正面
    IdentifyCardSideBackType = 2,//身份证反面
    IdentifyCardSideHandleCardType = 3,//手持身份证
};

#endif /* SystemNS_enumHeader_h */
