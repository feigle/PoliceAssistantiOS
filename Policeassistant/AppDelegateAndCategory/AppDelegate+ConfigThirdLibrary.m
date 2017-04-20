//
//  AppDelegate+ConfigThirdLibrary.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/4/20.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "AppDelegate+ConfigThirdLibrary.h"
#import <Bugly/Bugly.h>

@implementation AppDelegate (ConfigThirdLibrary)

- (void)configThirdLibraryApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /**初始化 Bugly key:( 3c08f0b8-0761-45f2-8bd6-8fd7aaf64e83 )*/
    [Bugly startWithAppId:@"b3b5acb2c8"];
}

@end
