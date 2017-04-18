//
//  NSDate+LHDDateTools.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "NSDate+LHDDateTools.h"

@implementation NSDate (LHDDateTools)

/**返回  number 天后的时间*/
- (NSDate *)returnAfterAFewDayDateWithNumber:(NSInteger)number
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:self];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setDay:number];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

/**返回  number 年后的时间*/
- (NSDate *)returnAfterAFewYearsDateWithNumber:(NSInteger)number
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:self];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:number];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}
/** 根据 dateFormat 返回时间字符串*/
- (NSString *)returnDateStringWithDateFormat:(NSString *)dateFormat
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *currentDateStr = [dateFormatter stringFromDate:self];
    return currentDateStr;
}

@end
