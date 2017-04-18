//
//  NSObject+JSONCategories.m
//  刘和东
//
//  Created by 秦沙沙 on 2014/9/21.
//  Copyright (c) 2014年 liuhedong. All rights reserved.
//

#import "NSObject+LHDJSONCategories.h"

@implementation NSObject (LHDJSONCategories)

- (NSString *)toJsonString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError * error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if ([jsonData length] > 0 && error == nil) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            return jsonString;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

@end
