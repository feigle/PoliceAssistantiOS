//
//  AppDelegate+MonitorLoginStatus.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/16.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "AppDelegate+MonitorLoginStatus.h"
#import "DDUserDefault.h"
#import "AliCloudUtil.h"

@implementation AppDelegate (MonitorLoginStatus)

- (void)monitorLoginStatusApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    PoliceAssistantIdentityType type = [DDUserDefault getIdentityType];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(type)];
}

- (void)loginStateChange:(NSNotification *)notification
{
    /**[1=>'管理员',2=>'民警',3=>'协警',4=>'保安',5=>'物业',6=>'房东'];*/
    /**登录身份*/
    PoliceAssistantIdentityType identityType = [notification.object integerValue];
    switch (identityType) {
        case PoliceAssistantNoLoginType://没有登录
        {
            [self initLoginRootViewController];
        }
            break;
        case PoliceAssistantIdentityAdministratorType://管理员
        {
        }
            break;
        case PoliceAssistantIdentityPoliceType://民警
        {
            [self initPoliceRootViewController];
        }
            break;
        case PoliceAssistantIdentityPoliceAssistType://协警
        {
            [self initHelperRootViewController];
        }
            break;
        case PoliceAssistantIdentityPublicSecurityType://保安
        {
        }
            break;
        case PoliceAssistantIdentityPropertyType://物业
        {
        }
            break;
        case PoliceAssistantIdentityLandlordType://房东
        {
            [DDLandlordUserModel restoreMyself];
            [self initDDLandlordCenterViewController];
        }
            break;
        default:
            break;
    }
}

@end
