//
//  MyAlertView.m
//  刘和东
//
//  Created by 秦沙沙 on 2013/12/24.
//  Copyright © 2013年 刘和东. All rights reserved.
//

#import "MyAlertView.h"


static MyAlertViewClickedBlock _otherBlock;
static MyAlertViewCancelClickedBlock _cancelBlock;


@implementation MyAlertView

/**
 *  提示框  默认Title = @“提示”
 *
 *  @param message 提示内容
 */
+ (void)alertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
+ (void)alertTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

/**
 *  自定义alertView
 *  @param otherButtonIndexBlock 其中的 buttonIndex 是从零开始的
 */
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitle:(NSArray *)otherButtons
                     onDismiss:(MyAlertViewClickedBlock)otherButtonIndexBlock
                      onCancel:(MyAlertViewCancelClickedBlock)cancelBtnClikced
{
    
    if (!otherButtonIndexBlock || !cancelBtnClikced) {
        return;
    }
    
    _otherBlock = [otherButtonIndexBlock copy];
    _cancelBlock = [cancelBtnClikced copy];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:[self self]
                                           cancelButtonTitle:cancelButtonTitle
                                           otherButtonTitles:nil];
    
    for (NSString *buttonTitle in otherButtons) {
        [alert addButtonWithTitle:buttonTitle];
    }
    [alert show];
}
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        _cancelBlock();
    } else {
        _otherBlock((int)buttonIndex - 1);
    }
}


@end
