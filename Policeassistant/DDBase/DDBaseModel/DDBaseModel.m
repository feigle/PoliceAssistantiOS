//
//  DDBaseModel.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/8.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDBaseModel.h"

@implementation DDBaseModel

/* 这里的属性都是可选的
 如果Model中属性多了 也不要管  __autoreleasing
 */
+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return  YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONBlock:^NSString *(NSString *keyName) {
        if ([keyName isEqual:@"mid"]) {
            return @"id";
        }else {
            return keyName;
        }
    }];
}

@end
