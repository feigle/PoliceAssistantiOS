//
//  DDAlertView.h
//  podtest
//
//  Created by DoorDu on 16/7/22.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^ClickAtIndexBlock)(NSInteger buttonIndex);
@interface DDAlertView : NSObject<UIAlertViewDelegate>
+(UIAlertView *)initWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle OtherButtonsArray:(NSArray*)otherButtons clickAtIndex:(ClickAtIndexBlock) clickAtIndex;

@end
