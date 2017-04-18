//
//  DDLabel.m
//  tabbar
//
//  Created by DoorDu on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DDLabel.h"

@implementation DDLabel
-(instancetype)initWithAlertViewHeight:(CGFloat)myfont mycolor:(UIColor *)color myfram:(CGRect)fram mytext:(NSString*)str
{
    self=[super init];
    if (self) {
        self.font=[UIFont systemFontOfSize:myfont];
        self.textColor=color;
        self.text=str;
        self.frame=fram;
    }
    return self;
}



@end
