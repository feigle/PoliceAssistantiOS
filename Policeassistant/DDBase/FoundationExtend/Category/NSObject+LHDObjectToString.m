//
//  NSObject+LHDObjectToString.m
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import "NSObject+LHDObjectToString.h"

@implementation NSObject (LHDObjectToString)

- (NSString *)toString
{
    //检测对象类型
    //不是NSString类型，转换成NSString
    if ([self isKindOfClass:[NSString class]]) {
        NSString * ss = (NSString *)self;
        if ([ss isEqualToString:@"NULL"]) {
            return @"";
        }
        if ([ss isEqualToString:@"nil"]) {
            return @"";
        }
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", self];
    } else if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    } else if (self == nil ) {
        return @"";
    } else if (self == NULL ) {
        return @"";
    }else {
        return @"";
    }
}


@end
