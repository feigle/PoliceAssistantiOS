//
//  AppDelegate.h
//  Policeassistant
//
//  Created by DoorDu on 16/6/27.
//  Copyright © 2016年 DoorDu. All rights reserved.
//
/**
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *pushstring;
@property (assign, nonatomic) int push_message_in;
@property (assign, nonatomic) int push_message_danger;
@property (assign, nonatomic) int push_message_out;
@property (assign, nonatomic) int push_flish_count;
@property (assign, nonatomic) int push_accept_count;
@property (assign, nonatomic) int push_notice_count;
@property (assign, nonatomic) BOOL is_unread_message;
@property (assign, nonatomic) NSString * is_refresh_message;
@property (assign, nonatomic) BOOL is_get_message;//协警获得推送
@property (strong, nonatomic) NSString* mission_number;

- (void)initHelperRootViewController;
- (void)initPoliceRootViewController;
- (void)initLoginRootViewController;
- (void)initDDLandlordCenterViewController;
@end

/**
 13569874587  123456a 房东助手测试
 
 */

