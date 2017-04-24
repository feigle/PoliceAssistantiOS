//
//  DDIdentifyCardSideBackModel.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDIdentifyCardSideBackModel.h"

@implementation DDIdentifyCardSideBackModel

- (BOOL)checkValue
{
    if (![[self.type toString] isEqualToString:@"1"]) {
        return NO;
    }
    if ([self.issued_by toString].length && [self.side toString].length && [self.type toString].length) {
        return YES;
    }
    return NO;
}

@end
