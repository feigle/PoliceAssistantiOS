//
//  DDUserDefault.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/2.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDUserDefault : NSObject
/**
 *用户登录账号
 */
+ (NSString *) getUserName;
+ (void) setUserName:(NSString *)userName;
/**
 *用户登录密码
 */
+ (NSString *) getPwd;
+ (void) setPwd:(NSString *)pwd;

/**
 *是否登录 yes是登录
 */
+ (BOOL) getLogin;
+ (void) setLogin:(BOOL)isOn;

/**
 *民警还是协警 yes是民警
 */
+ (BOOL) getJob;
+ (void) setJob:(BOOL)isOn;

+ (NSString *) getPushMessage;
//设置推送消息
+ (void) setPushMessage:(NSString *)userName;

/**
 *  设备token
 *
 *  @return 个人token
 */
+ (NSString *) getDeviceToken;

+ (void) setDeviceToken:(NSString *)userName;
/**
 *  登录的token
 *
 *  @return 登录的token
 */
+ (NSString *) getLoginToken;

+ (void) setLoginToken:(NSString *)token;

/**
 *用户推送信息字典
 */
+(NSDictionary*)getPushInformation;
+(void)setPushInforMation:(NSDictionary*)userIMT;
/**
 *  登录数据
 *
 *  @return 字典
 */
+(NSDictionary*)getLoginInformation;
+(void)setLoginforMation:(NSDictionary*)userIMT;
/**
 *  最近的一次用户名
 *
 *  @return 管理登录成功还是失败，都记住
 */
+ (NSString *) getloginName;
+ (void) setloginName:(NSString *)userName;


+ (NSString*) getDelgate;
+ (void) setDelgate:(NSString*)isOn;
/**保存登录类型*/
+ (void)setIdentityType:(PoliceAssistantIdentityType)type;
/**获取登录类型*/
+ (PoliceAssistantIdentityType)getIdentityType;

@end
