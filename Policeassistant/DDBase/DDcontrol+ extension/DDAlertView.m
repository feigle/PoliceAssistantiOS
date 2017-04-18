//
//  DDAlertView.m
//  podtest
//
//  Created by DoorDu on 16/7/22.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDAlertView.h"
/*
 全局静态变量，让类方法中的对象持有
 */
static ClickAtIndexBlock _ClickAtIndexBlock;
@interface  DDAlertView()<UIAlertViewDelegate>

@end

@implementation DDAlertView
+(UIAlertView *)initWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle OtherButtonsArray:(NSArray*)otherButtons clickAtIndex:(ClickAtIndexBlock) clickAtIndex;

{
    _ClickAtIndexBlock = [clickAtIndex copy];
    UIAlertView  *Al = [[UIAlertView alloc] initWithTitle:title message:messge delegate:self cancelButtonTitle:cancleButtonTitle otherButtonTitles: nil];
    for (NSString *otherTitle in otherButtons) {
        [Al addButtonWithTitle:otherTitle];
    }
    [Al show];
    return Al;
}
#pragma mark   UIAlertViewDelegate
+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _ClickAtIndexBlock(buttonIndex);
}
+(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _ClickAtIndexBlock = nil;
}
@end
