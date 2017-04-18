//
//  MyAlertView.h
//  刘和东
//
//  Created by 秦沙沙 on 2013/12/24.
//  Copyright © 2013年 刘和东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef void (^MyAlertViewClickedBlock) (int buttonIndex);

typedef void (^MyAlertViewCancelClickedBlock)();


@interface MyAlertView : NSObject

/**
 *  提示框  默认Title = @“提示”
 *
 *  @param message 提示内容
 */
+ (void)alertMessage:(NSString *)message;
+ (void)alertTitle:(NSString *)title message:(NSString *)message;

/**
 *  自定义alertView
 *  @param otherButtonIndexBlock 其中的 buttonIndex 是从零开始的
 */
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitle:(NSArray *)otherButtons
                     onDismiss:(MyAlertViewClickedBlock)otherButtonIndexBlock
                      onCancel:(MyAlertViewCancelClickedBlock)cancelBtnClikced;



@end
