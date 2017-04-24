//
//  DDIdentifyCardSideFrontModel.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/14.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDIdentifyCardSideFrontModel.h"

@implementation DDIdentifyCardSideFrontModel

- (BOOL)checkValue
{
    if (![[self.type toString] isEqualToString:@"1"]) {
        return NO;
    }
    if ([self.id_card_number toString].length != 18) {
        return NO;
    }
    if ([self.name toString].length <= 1) {
        return NO;
    }
    if ([self.address toString].length && [self.birthday toString].length && [self.gender toString].length&& [self.id_card_number toString].length && [self.name toString].length&& [self.race toString].length) {
        return YES;
    }
    return NO;
}

@end
