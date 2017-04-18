//
//  DDTools.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/5.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDTools : NSObject
/**
 *  发生devicetoken到服务器
 */
+ (void)sendDeviceToken:(NSString*)device_token;
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 *  上报消息未读数量：
 *
 *  @param messagecount 消息个数
 */
+ (void)SendUnreadMessageCount:(NSNumber *)messagecount;
/**
 *  一个字符串碰到数字就改变数字颜色
 *
 *  @param content 字符串内容
 *  @param color   数字颜色
 *  @param size    数字字体大小
 *
 *  @return label类型
 */
+ (NSMutableAttributedString *)ChangColorWithNumbers:(NSString *)content WithTextColor:(UIColor *)color WithTextFont:(CGFloat)size;

/**
 *  身份证号码验证
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;
/**
 *  手机号码验证
 */
+ (BOOL)validatePhone:(NSString *)phone;
/**
 *  1.用户名 - 2.密码 （英文、数字都可，且不包含特殊字符
 */
+ (BOOL)validateStrWithRange:(NSString *)range str:(NSString *)str;
/**
 *  时间格式的字符串转成nsdate
 *
 *  @param year       年
 *  @param month      月
 *  @param day        日
 *  @param datestring 日期格式的字符串
 *
 *  @return 字符串转成date，然后再做加减
 */
+(NSDate *)datejishuangYear:(int)year Month:(int)month Day:(int)day withData:(NSString *)datestring;

/**
 *  计算一个时间离现在的多少天多少时多少分
 *
 *  @param theDate 时间格式的字符串
 *
 *  @return 距离时间
 */
+ (NSString *)intervalSinceNow: (NSString *) theDate;

///**返回 nowDate  number 年后的时间*/
//+ (NSDate *)returnAfterAFewYearsDateWithNumber:(NSInteger)number nowDate:(NSDate *)nowDate;
//+ (NSString *)returnDateStringWithDateFormat:(NSString *)DateFormat date:(NSDate *)date;

/**
 比较两个时间大小

 @param bigDate 当前的时间
 @param compareDate 比较的时间
 @return 如果 bigDate 大于 compareDate 返回YES，否则返回NO
 */
+ (BOOL)compareBigDate:(NSDate *)bigDate compareDate:(NSDate *)compareDate;
//获取时间戳
+ (NSString *)gainTimestamp;

+ (BOOL) isEmpty:(NSString *) str;
/**验证香港的手机号*/
+ (BOOL)validateHongKongPhone:(NSString *)phone;

#pragma mark---获取视频的第几针
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
#pragma mark---纯色转图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color;
@end
