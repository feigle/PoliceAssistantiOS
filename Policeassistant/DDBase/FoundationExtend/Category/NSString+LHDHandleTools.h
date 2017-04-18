//
//  NSString+HandleTools.h
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LHDHandleTools)

/**过滤表情*/
-(NSString *)filterEmoji;

/**是否含有表情*/
-(BOOL)isContainsEmoji;

/**是否包含空格*/
- (BOOL)isContainsSpace;

/**去除多余的换行*/
- (NSString *)removeContinueLinefeed;
/**去除空格*/
- (NSString *)removeBlank;

/**转成utf8String*/
- (NSString *)utf8EncodingString;

/**宽度固定*/
- (CGSize)returnSizeWithFont:(UIFont *)font
                       color:(UIColor *)color
                       width:(CGFloat)width;
/**高度固定*/
- (CGSize)returnSizeWithFont:(UIFont *)font
                       color:(UIColor *)color
                      height:(CGFloat)height;

/**
 *  32位MD5加密
 *
 *  @return 32位MD5加密结果
 */
- (NSString *)MD5;

/**
 *  SHA1加密
 *
 *  @return SHA1加密结果
 */
- (NSString *)SHA1;

/**
 密码输入格式为6到12位的数字加字母组合。

 @return 返回YES，代表 是
 */
- (BOOL)verifyNumbersAndLettersCombinationPasswordSixToTwelve;

/**
 *   根据 format 返回 NSDate,把当前时间字符串
 *   yyyy.MM.dd
 *   yyyy-MM-dd
 *   yyyy-MM-dd HH:mm:ss
 */
- (NSDate *)returnDateWithFormat:(NSString *)format;

/**
 Returns an NSString for base64 encoded.
 */
- (nullable NSString *)base64EncodedString;


/**
 Returns an NSString from base64 encoded string.
 @param base64Encoding The encoded string.
 */
+ (nullable NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;

@end

NS_ASSUME_NONNULL_END
