//
//  DDTaskassignmentViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/29.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RollLabel : UIScrollView

-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;
-(void)startRoll;
-(void)pauseRoll;
@property(nonatomic,assign) float rollSpeed;
@property(nonatomic,assign) NSTimeInterval timeInterval;

@end
