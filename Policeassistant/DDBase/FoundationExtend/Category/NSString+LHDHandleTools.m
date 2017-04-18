//
//  NSString+HandleTools.m
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import "NSString+LHDHandleTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+LHDHandleTooles.h"

@implementation NSString (LHDHandleTools)

-(NSString *)filterEmoji {
    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [self UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = (unsigned int )utf8;
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = (unsigned int )utf8;
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8
                                             encoding:NSUTF8StringEncoding];
    free( newUTF8 );
    return encrypted;
}


-(BOOL)isContainsEmoji{
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}

- (BOOL)isContainsSpace
{
    NSString * str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length != self.length) {
        return YES;
    }
    return NO;
}

- (NSString *)removeContinueLinefeed
{
    NSString *content = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray * contArray = [content componentsSeparatedByString:@"\n"];
    if (contArray.count == 0) {
        return content;
    }
    NSMutableArray * contMuArray = [NSMutableArray arrayWithArray:contArray];
    [contMuArray removeObject:@""];
    [contMuArray removeObject:@" "];
    if (contMuArray.count == 0) {
        return @"";
    }
    NSMutableArray * resultContMuArray = [NSMutableArray array];
    for (NSString * sss in contMuArray) {
        NSString * s = [sss stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (s.length > 0) {
            [resultContMuArray addObject:[sss stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
    }
    NSString * newStr = [resultContMuArray componentsJoinedByString:@"\n\n"];
    return newStr;
}

/**去除空格*/
- (NSString *)removeBlank
{
    NSString *content = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return content;
}

- (NSString *)utf8EncodingString
{
    if (!self.length) {
        return nil;
    }
    NSString * str = [self stringByRemovingPercentEncoding];
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)str, NULL, NULL,  kCFStringEncodingUTF8 ));
    return encodedString;
}

/**
 宽度固定
 */
- (CGSize)returnSizeWithFont:(UIFont *)font
                       color:(UIColor *)color
                       width:(CGFloat)width
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}
/**
 高度固定
 */
- (CGSize)returnSizeWithFont:(UIFont *)font
                       color:(UIColor *)color
                      height:(CGFloat)height
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

#pragma mark 使用MD5加密字符串
- (NSString *)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

#pragma mark 使用SHA1加密字符串
- (NSString *)SHA1
{
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

/**
 判断是不是  数字加字母组合
 
 @return 返回YES，代表 是
 */
- (BOOL)verifyNumbersAndLettersCombinationPasswordSixToTwelve
{
//    ^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$
    /**
     ^ 匹配一行的开头位置
     (?![0-9]+$) 预测该位置后面不全是数字
     (?![a-zA-Z]+$) 预测该位置后面不全是字母
     [0-9A-Za-z] {8,16} 由8-16位数字或这字母组成
     $ 匹配行结尾位置
     */
    NSString * strNum = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    return [checktest evaluateWithObject:self];
}

/**
 *   根据 format 返回 NSDate,把当前时间字符串
 *   yyyy.MM.dd
 *   yyyy-MM-dd
 *   yyyy-MM-dd HH:mm:ss
 */
- (NSDate *)returnDateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat = format;
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate * date = [formatter dateFromString:self];
    return date;
}

- (NSString *)base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}


+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
