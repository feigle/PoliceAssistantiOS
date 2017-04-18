//
//  NSObject+LHDObjectToString.h
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  此类是为了解析数据的时候有空指针，主要用于字符的调用，例如：
 *  [self.infoDict[@"name"] toString]
 */

@interface NSObject (LHDObjectToString)

- (NSString *)toString;

@end
