//
//  DDLoginViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/27.
//  Copyright © 2016年 DoorDu. All rights reserved.
//
//  放一些第三方常量

#ifndef kd_VendorMacro_h
#define kd_VendorMacro_h

#define GetVersionMsg(name) \
[NSString stringWithFormat:@"检测到%@有新的版本\n是否立即更新？",(name)]


//#define serve @"http://ssl.test.doordu.com:8001/police"
//13410010212  11111

#define API_BASE_URL(_URL_) [NSString stringWithFormat:@"%@%@",DDLandlordBaseUrl,_URL_]

//#if DDReleaseStatus
//#define API_BASE_URL(_URL_) [NSString stringWithFormat:@"%@%@",DDLandlordBaseUrl,_URL_]
//#else
////内网
//#define API_BASE_URL(_URL_) [NSString stringWithFormat:@"https://ssl.test.doordu.com:8001/police/%@",_URL_]
////#define API_BASE_URL(_URL_) [NSString stringWithFormat:@"http://10.0.0.243:8007/%@",_URL_]
//#endif



//预发布
//#define API_BASE_URL(_URL_) [NSString stringWithFormat:@"https://ssl.beta.doordu.com:8001/police/%@",_URL_]
//公网



#define TIMEDOUT_TIME 8             // 连接超时设置         6s
#define HeartbeatTimeInterval 180   // 心跳时间间隔         180s
#define HeartbeatInterval 60 

#define GetDataTag 2
#define HeartbeatTag 1
#define KDDataType_HeartBeat              @"80"


/******* socket 数据 ********/
#define Error_Code_Success               @"0"    // 响应成功
#define Error_Code_Failed                  @"1"    // 响应失败
#define Error_Code_RequestError                @"2"    //请求参数错误
#define Error_Code_ChangeError                @"20006"    //请求参数错误
#define Error_Code_Userunfind               @"302"    // 用户不存在
#define SocketUserbeFrozen         @"304"   // 用户已经被冻结
#define SocketUserDataOnline        @"315"   // 系统用户数据信息未同步
#define MESSAGE_USERS_MOBILE_ALREADY_EXTIS_ERROR   @"308"   //用户手机号码已经被注册
#define MESSAGE_USERS_AUTH_DOING_ERROR   @"316"      // 系统用户账号正在在审核中
#define MESSAGE_USERS_AUTH_ERROR_ERROR   @"317"    //系统用户账号审核失败,重新申请审核

#define KDDataType_Logout               @"000"    // 退出

#define KDDataType_Register               @"01"    // 注册
#define KDDataType_Login                  @"02"    // 登录
#define KDDataType_OrderSubmit            @"03"    // 提交订单
#define KDDataType_OrderDel               @"04"    // 删除订单
#define KDDataType_OrderCancel            @"05"    // 取消订单
#define KDDataType_OrderList              @"06"   // 我的订单列表
#define KDDataType_UserInfo               @"08"   // 更改用户信息
#define KDDataType_SMS                    @"09"   // 获取短信验证码 type1注册 type0 找回验证码
#define KDDataType_FindPwd                @"10"   // 找回密码
#define KDDataType_SMSName                    @"11"   // 获取短信验证码 new

#define KDDataType_UserCenter                   @"12"   // 获取个人中心数据


#define KDDataType_Feedback               @"25"   // 意见反馈
#define KDDataType_Addr_Region            @"26"   //根据上级id获取区域列表（26）es_region

#define KDDataType_Addr_List                @"21"   //地址列表
#define KDDataType_Addr_Submit              @"22"   //地址提交
#define KDDataType_Addr_Del                 @"23"   //地址删除
#define KDDataType_Addr_Update              @"24"   //地址修改

#define KDDataType_MsgList              @"20"   // 消息
#define KDDataType_MyLove_delete       @"32"   //我的收藏delete
#define KDDataType_MyLove              @"31"   //我的收藏

#define KDDataType_APPVERSION              @"28"   //app 版本
#define KDDataType_HTMLVERSION              @"33"   //HTML 版本
#define KDDataType_SHARE             @"34"   //分享信息
#define KDDataType_ThridLogin @"35" //openid name sex otherType(1为qq、2为新浪、3为微信)
#define KDDataType_YAOQING @"36" //36 参数：code（邀请码）、invitedMember（邀请会员手机号）
#define KDDataType_IM_CreateAccount          @"61"   //创建子帐号
#define KDDataType_IM_JoinGroup              @"60"   //加入群
#define KDDataType_IM_QueryAccount              @"63"   //查询子帐号

/******* 用户信息 ********/
#define KEY_KD_USER                    @"kdUSer"
#define KDOrderOrigin                 @"2"     //订单来源
#define KEY_USER_NAME                   @"userName"         // 帐号
#define KEY_USER_PWD                    @"passWord"
#define KEY_DeviceTokenString           @"tokenString"  //token的值
#define KEY_PHONE_REGISTER              @"phoneRegister"  //手机注册
#define KEY_APP_VERSION                  @"APPVERSION"  //版本信息
#define KEY_APP_HTML                 @"APPHTML"  //HTML版本信息

#define KEY_HOME_IMGVERSION                 @"home_imgVersion"  //首页图片版本信息
#define KEY_HOME_SITEID                 @"home_siteId"  //首页站点id
#define HOME_IMGDIR                 @"home_imgUrl"  //首页图片目录
// 退出是否成功，要清除html的缓存
#define KEY_USER_LOGUOT                    @"userlogout"

#define KEY_HTLM_URL             @"url:"  //token的值
#define KEY_HTLM_ALERT           @"alert:"
#endif
