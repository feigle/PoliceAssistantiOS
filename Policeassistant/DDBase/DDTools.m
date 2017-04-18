//
//  DDTools.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/5.
//  Copyright © 2016年 DoorDu. All rights reserved.
//  工具类

#import "DDTools.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@implementation DDTools
#pragma mark -发送devicetoken到服务器
+ (void)sendDeviceToken:(NSString*)device_token{
    NSString *urlStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/getiosdevicetoken")];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:device_token,@"devicetoken",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:urlStr withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                [SVProgressHUD dismiss];
                
            }
            else if ([Error_Code_Failed isEqualToString:msg]){
              //  [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }else if ([Error_Code_RequestError isEqualToString:msg]){
             //   [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }
            
        }else{
            
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){
        [SVProgressHUD dismiss];
      //  [DDProgressHUD showCenterWithText:@"网络异常" duration:2.0];
    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];

}

#pragma mark -把格式化的JSON格式的字符串转换成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark - 统计未读的推送消息个数给服务器
+ (void)SendUnreadMessageCount:(NSNumber *)messagecount{
    NSString *urlStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/unreadmessage")];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:messagecount,@"unreadcount",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:urlStr withParameters:dicts withSuccessBlock:^(id response){
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                NSLog(@"推送消息个数报备成功");
            }
            else if ([Error_Code_Failed isEqualToString:msg]){

            }else if ([Error_Code_RequestError isEqualToString:msg]){

            }
            
        }else{
            
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){
        [SVProgressHUD dismiss];
        //  [DDProgressHUD showCenterWithText:@"网络异常" duration:2.0];
    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];
    
}

#pragma mark - 一个字符串碰到数字就改变数字颜色
+ (NSMutableAttributedString *)ChangColorWithNumbers:(NSString *)content WithTextColor:(UIColor *)color WithTextFont:(CGFloat)size{
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i < content.length; i ++) {
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:size],NSFontAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(i, 1)];
        }
    }
    return attributeString;

}
#pragma mark - 身份证号码验证
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length = 0;
    if (!value) {
        return NO;
    }else {
        length =(int) value.length;
        
        if (length != 15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}
#pragma mark - 手机号码验证
+ (BOOL)validatePhone:(NSString *)phone {
    NSString * strNum = @"^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$";
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    return [checktest evaluateWithObject:phone];
}
#pragma mark -  1.用户名 - 2.密码 （英文、数字都可，且不包含特殊字符）
+ (BOOL)validateStrWithRange:(NSString *)range str:(NSString *)str
{
    // eg: range = {4,20}
    NSString * regex = [NSString stringWithFormat:@"^[A-Za-z0-9]%@$",range] ;
  // 下面这句是：：由数字和字母组成，并且要同时含有数字和字母，且长度要在6-12位之间
  //  NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

+ (BOOL)validateHongKongPhone:(NSString *)phone
{
    NSString * strNum = @"^(5|6|8|9)\\d{7}$";
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    return [checktest evaluateWithObject:phone];
}

/**
 *  时间算法
 *
 *  @author Aron
 *  @date 2016-01-06
 *
 *  @param year  计算年=》加1年：1；减1年：-1
 *  @param month 计算月=》加1月：1；减1月：-1
 *  @param day   计算天=》加一周：7；减一周：-7
 *  @param date  要计算的时间
 *
 *  @return 计算好的时间
 */
+(NSDate *)datejishuangYear:(int)year Month:(int)month Day:(int)day withData:(NSString *)datestring {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //NSCalendarIdentifierGregorian:iOS8之前用NSGregorianCalendar
    NSDateComponents *comps = nil;
    
    NSString *string=[datestring substringToIndex:10];
    NSDate*date =[[NSDate alloc]init];
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    [df setTimeZone:timeZone];
    date =[df dateFromString:string];
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    //NSCalendarUnitYear:iOS8之前用NSYearCalendarUnit,NSCalendarUnitMonth,NSCalendarUnitDay同理
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    return [calendar dateByAddingComponents:adcomps toDate:date options:0];
}
/**
 *  算时间差
 *
 *  @param theDate 字符格式的时间
 *
 *  @return 返回几天几小时几分
 */
+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=fabs(late-now);
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分", timeString];
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        double x;
        x=[timeString doubleValue];
        double y;
        y=cha-x*3600;
        NSString *str1=[NSString stringWithFormat:@"%f", y/60];
        str1 = [str1 substringToIndex:str1.length-7];
        timeString=[NSString stringWithFormat:@"%@小时%@分", timeString,str1];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        double x;
        x=[timeString doubleValue];
        double y;
        y=cha-x*86400;
        NSString *str1=[NSString stringWithFormat:@"%f", y/3600];
        str1 = [str1 substringToIndex:str1.length-7];
        double w;
        w=[str1 doubleValue];
        double e;
        e=y-w*3600;
        NSString *str2=[NSString stringWithFormat:@"%f", e/60];
        str2 = [str2 substringToIndex:str2.length-7];
        timeString=[NSString stringWithFormat:@"%@天%@小时%@分", timeString,str1,str2];
    }
    return timeString;
}

///**返回 nowDate  number 年后的时间*/
//+ (NSDate *)returnAfterAFewYearsDateWithNumber:(NSInteger)number nowDate:(NSDate *)nowDate
//{
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
//    NSLog(@"---当前的时间的字符串 = %@",currentDateStr);
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *comps = nil;
//    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:nowDate];
//    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//    [adcomps setYear:number];
//    [adcomps setDay:0];
//    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:nowDate options:0];
//    NSString * afterDate = [dateFormatter stringFromDate:newdate];
//    NSLog(@"12个月后的时间：%@",afterDate);
//    
//    return newdate;
//}

/**
 比较两个时间大小
 
 @param bigDate 当前的时间
 @param compareDate 比较的时间
 @return 如果 bigDate 大于 compareDate 返回YES，否则返回NO
 */
+ (BOOL)compareBigDate:(NSDate *)bigDate compareDate:(NSDate *)compareDate
{
    NSComparisonResult result = [bigDate compare:compareDate];
    if (result == NSOrderedAscending) {
        return YES;
    }
    return NO;
}
#pragma mark (获取时间戳)
+ (NSString *)gainTimestamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval val = [date timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%0.f", val];
    return timestamp;
}
#pragma mark -  判断一个字符串是否全部为空格
+ (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

/**
 纯色转图片

 @param color 颜色

 @return 图片
 */
+ (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

@end
