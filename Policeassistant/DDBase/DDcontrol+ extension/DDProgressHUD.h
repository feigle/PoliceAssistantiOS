//
//  DDProgressHUD.h
//  Policeassistant
//
//  Created by DoorDu on 16/7/7.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface DDProgressHUD : NSObject
/**
 *  中间显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)showCenterWithText:(NSString *)text duration:(CGFloat)duration;

@end
