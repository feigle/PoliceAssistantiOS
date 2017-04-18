//
//  DDUserDefault.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/2.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDUserDefault.h"
#define DD_USER_NAME @"UserName"
#define DD_PASSWORD @"password"
#define DD_IS_LOGIN @"is_login"
#define DD_IS_POLICE @"is_plice"

#define DD_IS_PUSH @"push_message"
#define DD_DevceToken @"devce_token"
#define DD_LoginToken @"loginToken"

#define DD_PUSH_COUNT @"all_push_messagecount"
#define DD_Login_Dict @"login_message"

#define DD_Login_User @"user"
@implementation DDUserDefault
//登录用户名
+ (NSString *) getUserName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:DD_USER_NAME];
}
//获取登录用户名
+ (void) setUserName:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:DD_USER_NAME];
    [defaults synchronize];
}

//登录用户名
+ (NSString *) getloginName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:DD_Login_User];
}
//获取登录用户名
+ (void) setloginName:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:DD_Login_User];
    [defaults synchronize];
}

//登录用户密码
+ (NSString *) getPwd
{
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    return [defauls valueForKey:DD_PASSWORD];
}
//设置登录用户密码
+ (void) setPwd:(NSString *)pwd
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:pwd forKey:DD_PASSWORD];
    [defaults synchronize];
}
//是否登录
+ (BOOL) getLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:DD_IS_LOGIN];
    
}
//获取登录状态
+ (void) setLogin:(BOOL)isOn{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isOn forKey:DD_IS_LOGIN];
    [defaults synchronize];
}
//判断职业
+ (BOOL) getJob{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:DD_IS_POLICE];
    
}
//设置职业
+ (void) setJob:(BOOL)isOn{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isOn forKey:DD_IS_POLICE];
    [defaults synchronize];
}

//获取推送消息
+ (NSString *) getPushMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:DD_IS_PUSH];
}
//设置推送消息
+ (void) setPushMessage:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:DD_IS_PUSH];
    [defaults synchronize];
}
/**
 *  设备token
 *
 *  @return 个人token
 */
+ (NSString *) getDeviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:DD_DevceToken];
}

+ (void) setDeviceToken:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:DD_DevceToken];
    [defaults synchronize];
}

/**
 *  登录的token
 *
 *  @return 登录的token
 */
+ (NSString *) getLoginToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:DD_LoginToken];
}

+ (void) setLoginToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:DD_LoginToken];
    [defaults synchronize];
}


/**
 *用户推送信息字典
 */
+(NSDictionary*)getPushInformation
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DD_PUSH_COUNT];
}
+(void)setPushInforMation:(NSDictionary*)userIMT
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:userIMT forKey:DD_PUSH_COUNT];
    [defaults synchronize];
}
/**
 *  用户登录返回的字典
 *
 *  @return 字典
 */
+(NSDictionary*)getLoginInformation
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DD_Login_Dict];
}
+(void)setLoginforMation:(NSDictionary*)userIMT
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:userIMT forKey:DD_Login_Dict];
    [defaults synchronize];
}


+ (NSString*) getDelgate{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"isUseDegate"];
}
+ (void) setDelgate:(NSString*)isDe{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:isDe forKey:@"isUseDegate"];
    [defaults synchronize];
}

/**保存登录类型*/
+ (void)setIdentityType:(PoliceAssistantIdentityType)type
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:type forKey:@"PoliceAssistantIdentityTypePoliceAssistantIdentityType"];
    [defaults synchronize];
}
/**获取登录类型*/
+ (PoliceAssistantIdentityType)getIdentityType
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    id objc = [defaults objectForKey:@"PoliceAssistantIdentityTypePoliceAssistantIdentityType"];
    if (!objc) {//如果没有，返回没有登录
        return PoliceAssistantNoLoginType;
    }
    PoliceAssistantIdentityType type = [objc integerValue];
    return type;
}


@end
