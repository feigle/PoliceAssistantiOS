//
//  NSObject+JSONCategories.h
//  刘和东
//
//  Created by 秦沙沙 on 2014/9/21.
//  Copyright (c) 2014年 liuhedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LHDJSONCategories)

/**
 *  将NSDictionary或NSArray转化为JSON串
 *
 *   NSDictionary或NSArray
 *
 *  @return json字符串  JSONString
 */
- (NSString *)toJsonString;


@end
