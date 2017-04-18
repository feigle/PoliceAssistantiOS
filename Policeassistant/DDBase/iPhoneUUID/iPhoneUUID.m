//
//  iPhoneUUID.m
//  刘和东
//
//  Created by 刘和东 on 2014/7/20.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import "iPhoneUUID.h"
#import "SSKeychain.h"

@implementation iPhoneUUID

/**
 *  这里的宏参数不要改
 */
static NSString * const iPhoneUUIDServiceName = @"com.doordu.Policeassistant.UDID";
static NSString * const iPhoneUUIDAccount = @"com.doordu.Policeassistant.iPhoneUUIDAccount";
static NSString * const iPhoneUUIDCurrentUserName = @"com.doordu.Policeassistant.iPhoneUUIDCurrentUserName";

+ (NSString *)getUUIDString
{
    NSString *s = [self getSaveSerialNo:iPhoneUUIDAccount];
    if (s) return s;
    s = [self saveSerialNo:iPhoneUUIDAccount];
    return s;
}

+ (NSString *) getSerialNo:(NSString *)username {
    NSString *s = [self getSaveSerialNo:username];
    if (s) return s;
    s = [self saveSerialNo:username];
    return s;
}

#pragma mark - 存储手机唯一识别符
+ (NSString *) saveSerialNo:(NSString *)username {
    // 产生一个序列号
    NSString *uuid = [[NSUUID UUID] UUIDString];
    // Keychain
    [self saveSeriaPassNo:uuid withUserName:username];
    return uuid;
}

+ (BOOL)saveSeriaPassNo:(NSString *)passNo withUserName:(NSString *)username
{
    return [SSKeychain setPassword:passNo forService:iPhoneUUIDServiceName account:username];
}

+ (NSString *) getSaveSerialNo:(NSString *)username {
    NSString *s = [SSKeychain passwordForService:iPhoneUUIDServiceName account:username];
    return s;
}

+ (BOOL)deleteSerialNO:(NSString *)username
{
    NSString * s = [self getSerialNo:username];
    if (s) {
        BOOL b = [SSKeychain deletePasswordForService:iPhoneUUIDServiceName account:username];
        return b;
    }
    return YES;
}

+ (BOOL)saveUserName:(NSString *)name
{
    return [self saveSeriaPassNo:name withUserName:iPhoneUUIDCurrentUserName];
}
+ (BOOL)deleteUserName
{
    return [self deleteSerialNO:iPhoneUUIDCurrentUserName];
}

+ (NSString *)getUserName
{
    NSString * s = [self getSaveSerialNo:iPhoneUUIDCurrentUserName];
    return s;
}

+ (NSArray *) getAllSerial {
    return [SSKeychain allAccounts];
}

@end
