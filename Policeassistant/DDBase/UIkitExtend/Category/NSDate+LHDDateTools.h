//
//  NSDate+LHDDateTools.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LHDDateTools)

/**返回  number 天后的时间*/
- (NSDate *)returnAfterAFewDayDateWithNumber:(NSInteger)number;

/**返回  number 年后的时间*/
- (NSDate *)returnAfterAFewYearsDateWithNumber:(NSInteger)number;
/** 
    *   根据 dateFormat 返回时间字符串
    *   yyyy.MM.dd
    *   yyyy-MM-dd
    *   yyyy-MM-dd HH:mm:ss
 */
- (NSString *)returnDateStringWithDateFormat:(NSString *)dateFormat;


@end
