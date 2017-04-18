//
//  AppDelegate.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/27.
//  Copyright © 2016年 DoorDu. All rights reserved.
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

#import "AppDelegate.h"
#import "DDTabBar.h"
#import "DDHelpTabBar.h"
#import "DDLeftSliderManger.h"
#import "DDLeftSliderVC.h"
#import "DDLeftViewController.h"
#import "DDLoginVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UserNotifications/UserNotifications.h>

#import "DDLandlordCenterViewController.h"

#import "AppDelegate+MonitorLoginStatus.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate>
{
    BOOL isLogin;
    NSString *show_label;
}
@property (strong, nonatomic) DDTabBar *policeTabBar;
@property (strong, nonatomic) DDHelpTabBar *helperTabBar;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    /*
     if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
     { UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
     [application registerUserNotificationSettings:notiSettings];
     } else{
     [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
     }
     */
    //iOS 10
    if (iOS10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                NSLog(@"注册通知成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                //点击不允许
                NSLog(@"注册通知失败");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%@",settings);
        }];
    }else{
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            //IOS8，创建UIUserNotificationSettings，并设置消息的显示类类型
            UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
            
            [application registerUserNotificationSettings:notiSettings];
        }
    }
    
    
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        if ([DDUserDefault getJob]) {
            show_label = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            NSString *type = [[userInfo objectForKey:@"data"] objectForKey:@"response_type"];
            [self SavePushMessage:type];
            NSLog(@"点击推送进来的");
        }else{
            self.is_get_message=YES;
            self.mission_number =[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"data"] objectForKey:@"notice_id"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"GetAllMessageNotification" object:nil];
        }
    }else{
        _is_unread_message=NO;
        if ([DDUserDefault getPushInformation]) {
            NSString *str1=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_in"]];
            NSString *str2=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_danger"]];
            NSString *str3=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_message_out"]];
            NSString *str4=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_notice_count"]];
            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:str1,@"push_message_in",str2,@"push_message_danger",str3,@"push_message_out",str4,@"push_notice_count", nil];
            [DDUserDefault setPushInforMation:dict];
            
        }else{
            NSString *str1=[NSString stringWithFormat:@"%d",_push_message_in];
            NSString *str2=[NSString stringWithFormat:@"%d",_push_message_danger];
            NSString *str3=[NSString stringWithFormat:@"%d",_push_message_out];
            NSString *str4=[NSString stringWithFormat:@"%@",[DDUserDefault getPushInformation][@"push_notice_count"]];
            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:str1,@"push_message_in",str2,@"push_message_danger",str3,@"push_message_out",str4,@"push_notice_count", nil];
            [DDUserDefault setPushInforMation:dict];
        }
        
    }
    
//    if ([DDUserDefault getLogin]) {
//        if ([DDUserDefault getJob]) {
//            [self initPoliceRootViewController];
//        }else{
//            [self initHelperRootViewController];
//        }
//    }
//    else{
//        [self initLoginRootViewController];
//    }
//    [self initDDLandlordCenterViewController];
    [self monitorLoginStatusApplication:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}
- (void)registerNotification{
    /*
     identifier：行为标识符，用于调用代理方法时识别是哪种行为。
     title：行为名称。
     UIUserNotificationActivationMode：即行为是否打开APP。
     authenticationRequired：是否需要解锁。
     destructive：这个决定按钮显示颜色，YES的话按钮会是红色。
     behavior：点击按钮文字输入，是否弹出键盘
     */
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"策略1行为1" options:UNNotificationActionOptionForeground];
    /*iOS9实现方法
     UIMutableUserNotificationAction * action1 = [[UIMutableUserNotificationAction alloc] init];
     action1.identifier = @"action1";
     action1.title=@"策略1行为1";
     action1.activationMode = UIUserNotificationActivationModeForeground;
     action1.destructive = YES;
     */
    
    UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:@"action2" title:@"策略1行为2" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"textInputButtonTitle" textInputPlaceholder:@"textInputPlaceholder"];
    /*iOS9实现方法
     UIMutableUserNotificationAction * action2 = [[UIMutableUserNotificationAction alloc] init];
     action2.identifier = @"action2";
     action2.title=@"策略1行为2";
     action2.activationMode = UIUserNotificationActivationModeBackground;
     action2.authenticationRequired = NO;
     action2.destructive = NO;
     action2.behavior = UIUserNotificationActionBehaviorTextInput;//点击按钮文字输入，是否弹出键盘
     */
    
    
    UNNotificationCategory *catrgory1=[UNNotificationCategory categoryWithIdentifier:@"" actions:@[action1,action2] intentIdentifiers:@[action2,action1] options:UNNotificationCategoryOptionCustomDismissAction];
    //        UIMutableUserNotificationCategory * category1 = [[UIMutableUserNotificationCategory alloc] init];
    //        category1.identifier = @"Category1";
    //        [category1 setActions:@[action2,action1] forContext:(UIUserNotificationActionContextDefault)];
    
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"策略2行为1" options:UNNotificationActionOptionForeground];
    //        UIMutableUserNotificationAction * action3 = [[UIMutableUserNotificationAction alloc] init];
    //        action3.identifier = @"action3";
    //        action3.title=@"策略2行为1";
    //        action3.activationMode = UIUserNotificationActivationModeForeground;
    //        action3.destructive = YES;
    
    UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:@"action4" title:@"策略2行为2" options:UNNotificationActionOptionForeground];
    //        UIMutableUserNotificationAction * action4 = [[UIMutableUserNotificationAction alloc] init];
    //        action4.identifier = @"action4";
    //        action4.title=@"策略2行为2";
    //        action4.activationMode = UIUserNotificationActivationModeBackground;
    //        action4.authenticationRequired = NO;
    //        action4.destructive = NO;
    UNNotificationCategory *catrgory2=[UNNotificationCategory categoryWithIdentifier:@"" actions:@[action3,action4] intentIdentifiers:@[action3,action4] options:UNNotificationCategoryOptionCustomDismissAction];
    
    //        UIMutableUserNotificationCategory * category2 = [[UIMutableUserNotificationCategory alloc] init];
    //        category2.identifier = @"Category2";
    //        [category2 setActions:@[action4,action3] forContext:(UIUserNotificationActionContextDefault)];
    
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:catrgory1,catrgory2, nil]];
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"completionHandler");
    }];
    /*iOS9实现方法 
     UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects: category1,category2, nil]];
     
     [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
     */
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
}
/**
 *  设置民警根控制器
 */
- (void)initPoliceRootViewController{
    _policeTabBar=[[DDTabBar alloc]init];
    DDLeftViewController *leftvc=[[DDLeftViewController alloc]init];
    DDLeftSliderVC *rootVc=[[DDLeftSliderVC alloc]initWithLeftView:leftvc andMainView:_policeTabBar];
    [rootVc setPanEnabled:NO];
    self.window.rootViewController = rootVc;
    [self.window makeKeyAndVisible];
}
/**
 *  设置协警根控制器
 */
- (void)initHelperRootViewController{
    _helperTabBar=[[DDHelpTabBar alloc]init];
    DDLeftViewController *leftvc=[[DDLeftViewController alloc]init];
    DDLeftSliderVC *rootVc=[[DDLeftSliderVC alloc]initWithLeftView:leftvc andMainView:_helperTabBar];
    [rootVc setPanEnabled:NO];
    self.window.rootViewController = rootVc;
    [self.window makeKeyAndVisible];
}
/**
 *  设置登陆根控制器
 */
- (void)initLoginRootViewController{
    DDLoginVC *vc=[[DDLoginVC alloc]init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

/**
 房东登录根控制器
 */
- (void)initDDLandlordCenterViewController
{
    DDLandlordCenterViewController * vc = [[DDLandlordCenterViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //    nav.navigationController.navigationBar.hidden = YES;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

/**
 *  获得了设备想DeviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"注册远程通知成功----%@", deviceToken);
    // NSString *device=[NSString stringWithFormat:@"%@",deviceToken];
    NSString *deviceTokenString2 = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                     
                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
                                    
                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
    [DDUserDefault setDeviceToken:deviceTokenString2];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //应用在前台收到通知
    //    NSLog(@"========%@", notification);
    NSDictionary *diction=notification.request.content.userInfo;
    if ([DDUserDefault getJob]) {
        show_label = [[diction objectForKey:@"aps"] objectForKey:@"alert"];
        NSString *type = [[diction objectForKey:@"data"] objectForKey:@"response_type"];
        [self SavePushMessage:type];
        AudioServicesPlaySystemSound(1002);//播放声音
    }else{
        self.is_get_message=YES;
        self.mission_number =[NSString stringWithFormat:@"%@",[[diction objectForKey:@"data"] objectForKey:@"notice_id"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetAllMessageNotification" object:nil];
    }
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    //点击通知进入应用
    //    NSLog(@"response:%@", response);
    NSDictionary *diction=response.notification.request.content.userInfo;
    if ([DDUserDefault getJob]) {
        show_label = [[diction objectForKey:@"aps"] objectForKey:@"alert"];
        NSString *type = [[diction objectForKey:@"data"] objectForKey:@"response_type"];
        [self SavePushMessage:type];
        //    AudioServicesPlaySystemSound(1002);//播放声音
    }else{
        self.is_get_message=YES;
        self.mission_number =[NSString stringWithFormat:@"%@",[[diction objectForKey:@"data"] objectForKey:@"notice_id"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetAllMessageNotification" object:nil];
    }
    
}

/**
 *  接收到远程推送通知时就会调用
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo = %@",userInfo);
    if ([DDUserDefault getJob]) {
        show_label = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        NSString *type = [[userInfo objectForKey:@"data"] objectForKey:@"response_type"];
        [self SavePushMessage:type];
        //    AudioServicesPlaySystemSound(1002);//播放声音
    }else{
        self.is_get_message=YES;
        self.mission_number =[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"data"] objectForKey:@"notice_id"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetAllMessageNotification" object:nil];
    }
    
}
/**
 *  注册推送关键
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)SavePushMessage:(NSString *)pushmessage{
    switch ([pushmessage intValue]) {
        case 0:
            _push_message_out+=1;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushNotification" object:pushmessage];
            break;
        case 1:
            _push_message_in+=1;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushNotification" object:pushmessage];
            break;
        case 2:
            _push_message_danger+=1;
            [_policeTabBar showPointMarkIndex:1];
            _is_unread_message=YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushNotification" object:pushmessage];
            break;
        case 9:
            _push_notice_count+=1;
            [DDUserDefault setPushMessage:show_label];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushNotification" object:pushmessage];
            break;
        case 10:
            _push_flish_count+=1;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushNotification" object:pushmessage];
            [_policeTabBar showPointMarkIndex:2];
            break;
        case 11:
            _push_accept_count+=1;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushNotification" object:pushmessage];
            [_policeTabBar showPointMarkIndex:2];
            break;
            
        default:
            break;
    }
    
    NSString *str1=[NSString stringWithFormat:@"%d",_push_message_in];
    NSString *str2=[NSString stringWithFormat:@"%d",_push_message_danger];
    NSString *str3=[NSString stringWithFormat:@"%d",_push_message_out];
    NSString *str4=[NSString stringWithFormat:@"%d",_push_notice_count];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:str1,@"push_message_in",str2,@"push_message_danger",str3,@"push_message_out",str4,@"push_notice_count", nil];
    NSLog(@"永久存储的字典==%@",dict);
    [DDUserDefault setPushInforMation:dict];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"当应用程序将要入非活动状态执行");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"当程序被推送到后台的时候调用");
    if ([DDUserDefault getLogin]) {
        if ([DDUserDefault getJob]) {
            NSDictionary *dic=[DDUserDefault getPushInformation];
            NSString *flish=[NSString stringWithFormat:@"%d",_push_flish_count];
            NSString *accept=[NSString stringWithFormat:@"%d",_push_accept_count];
            NSArray *testArray = [NSArray arrayWithObjects:dic[@"push_message_in"], dic[@"push_message_danger"],dic[@"push_message_out"],dic[@"push_notice_count"],flish,accept, nil];
            NSNumber *sum = [testArray valueForKeyPath:@"@sum.floatValue"];
            NSInteger bager=[sum integerValue];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:bager];
        }
    }
    else{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"当程序从后台将要重新回到前台时候调用");
    if ([DDUserDefault getLogin]) {
        _is_refresh_message=@"1";
        //第一步注册通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"isRefreshNotification" object:_is_refresh_message];
    }else{
        NSLog(@"账号未登录，不响应事件");
    }
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"当应用程序入活动状态执行");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作");
}
@end
