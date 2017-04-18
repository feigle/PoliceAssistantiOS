//
//  iPhoneUUID.h
//  刘和东
//
//  Created by 刘和东 on 2014/7/20.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iPhoneUUID : NSObject

/**
 *  获取UUID,手机唯一标示符
 // 取得手机唯一序列号,一旦安装了, 哪怕是App删除，下次得到的序列号也是唯一的
 */
+ (NSString *) getUUIDString;

/**
 *  创建一个唯一标示符
 */
+ (NSString *) getSerialNo:(NSString *)username;

+ (NSArray *) getAllSerial;

+ (BOOL)saveUserName:(NSString *)name;
+ (NSString *)getUserName;
+ (BOOL)deleteUserName;


@end
