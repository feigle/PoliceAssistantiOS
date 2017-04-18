//
//  DDButton.h
//  podtest
//
//  Created by DoorDu on 16/7/21.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDButton : UIButton
/**
 *  使用block改写按钮点击事件
 *
 *  @param frame      位置大小
 *  @param title      按钮标题
 *  @param touchBlock 回调事件
 *
 *  @return 方法
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title touchBlock:(void (^)(DDButton *))touchBlock;
@end
