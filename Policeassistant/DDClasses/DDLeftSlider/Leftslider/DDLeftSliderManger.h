//
//  DDLeftSliderManger.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLeftSliderVC.h"
@interface DDLeftSliderManger : NSObject
+(instancetype)sharedInstance;
@property (strong, nonatomic) DDLeftSliderVC *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@end
