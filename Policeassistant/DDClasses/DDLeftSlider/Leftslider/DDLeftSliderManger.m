//
//  DDLeftSliderManger.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDLeftSliderManger.h"

@implementation DDLeftSliderManger
static id _instance;

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
@end
