//
//  DDLandlordUserModel.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordUserModel.h"
#import "AutoCoding.h"

@implementation DDLandlordUserModel

static DDLandlordUserModel * _currUer;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t oneUser;
    dispatch_once(&oneUser, ^{
        _currUer = [super allocWithZone:zone];
    });
    return _currUer;
}
/**获取当前用户*/
+ (id) currentUser
{
    if (_currUer == nil) {
        _currUer = [[DDLandlordUserModel alloc] init];
        [[self class] restoreMyself];
    }
    return _currUer;
}
#pragma mark - 使用AutoCoding自动进行归档
//获取当前的归档后保存的路径
static inline NSString * myselfSaveFile() {
    return [NSHomeDirectory() stringByAppendingString:@"/Documents/DDLandlordUserModel"];
}
/**保存当前用户*/
+ (void) saveMySelf
{
    DDLandlordUserModel * userModel = landlordUserModel;
    NSString * path = myselfSaveFile();
    [userModel writeToFile:path atomically:YES];
}
/**恢复当前用户*/
+ (id) restoreMyself
{
    NSString * path = myselfSaveFile();
    DDLandlordUserModel * userModel = landlordUserModel;
    DDLandlordUserModel * um = [self objectWithContentsOfFile:path];
    if (um) {
        userModel = um;
    }
    return um;
}

/**判断用户是否存在*/
+ (BOOL) isExistMyself
{
    NSString * path = myselfSaveFile();
    id obj = [self objectWithContentsOfFile:path];
    if ([obj isKindOfClass:[self class]]) {
        return YES;
    }
    return NO;
}
/**删除用户*/
+ (void)deleteMyself
{
    DDLandlordUserModel * userModel = landlordUserModel;
    [userModel deleteMyselfData];
    NSString * path = myselfSaveFile();
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark - 自动实现了拷贝NSCopying功能
- (id)copyWithZone:(NSZone *)zone
{
    DDLandlordUserModel * copy = [[[self class] allocWithZone:zone] init];
    for (NSString * key in [self codableProperties]) {
        [copy setValue:[self valueForKey:key] forKey:key];
    }
    return copy;
}
/**把对象self拷贝到target*/
- (id)copyToObject:(id)target
{
    for (NSString * key in [self codableProperties]) {
        [target setValue:[self valueForKey:key] forKey:key];
    }
    return target;
}

+ (void)refreshUserInfoData:(NSDictionary *)dict
{
    DDLandlordUserModel * userModel = landlordUserModel;
    if (dict[@"user_id"]) {
        userModel.user_id = [dict[@"user_id"] toString];
    }
    if (dict[@"agent_name"]) {
        userModel.agent_name = [dict[@"agent_name"]toString];
    }
    if (dict[@"identity_type_id"]) {
        userModel.identity_type_id = [dict[@"identity_type_id"] toString];
    }
    if (dict[@"real_name"]) {
        userModel.real_name = [dict[@"real_name"]toString];
    }
    if (dict[@"token"]) {
        userModel.token = [dict[@"token"]toString];
    }
    [DDLandlordUserModel saveMySelf];
}
- (void)deleteMyselfData
{
    DDLandlordUserModel * userModel = landlordUserModel;
    userModel.isLogin = NO;
    userModel.user_id = nil;
    userModel.agent_name = nil;
    userModel.identity_type_id = nil;
    userModel.real_name = nil;
    userModel.token = nil;
    userModel.selectedModel = nil;
    userModel.landlordHouseListDataArray = nil;
    [DDLandlordUserModel saveMySelf];
}


@end
