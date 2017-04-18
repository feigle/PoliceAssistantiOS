//
//  NSData+LHDHandleTooles.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/20.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSData (LHDHandleTooles)


/**
 Returns an NSString for base64 encoded.
 */
- (nullable NSString *)base64EncodedString;

/**
 Returns an NSData from base64 encoded string.
 
 @warning This method has been implemented in iOS7.
 
 @param base64EncodedString  The encoded string.
 */
+ (nullable NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;


@end

NS_ASSUME_NONNULL_END
