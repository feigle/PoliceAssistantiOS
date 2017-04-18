//
//  LHDPopView.h
//  刘和东
//
//  Created by 刘和东 on 2015/10/27.
//  Copyright © 2015年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LHDPopViewBackgroundStyle) {
    LHDPopViewBackgroundStyleDefault = 0, // 默认风格, 透明
    LHDPopViewBackgroundStyleDark, // 黑色风格
};

@interface LHDPopView : UIView

/**展示内容的contentView（按自己的需求），弹出大小默认会根据contentView大小，宽度不得超过屏幕宽减20，高度不得超过当前点击点*/
- (instancetype)initWithContentView:(UIView *)contentView withStyle:(LHDPopViewBackgroundStyle)style;


/**fromView 箭头指向的View*/
- (void)showFromView:(UIView *)fromView;

/**fromPoint 箭头指向的Point*/
- (void)showFromPoint:(CGPoint)fromPoint;

/**隐藏*/
- (void)hide;

/**展示内容的contentView（按自己的需求），弹出大小默认会根据contentView大小，宽度不得超过屏幕宽减20，高度不得超过当前点击点，fromView 箭头指向的View*/
+ (void)showContentView:(UIView *)contentView style:(LHDPopViewBackgroundStyle)style fromView:(UIView *)fromView;

/**展示内容的contentView（按自己的需求），弹出大小默认会根据contentView大小，宽度不得超过屏幕宽减20，高度不得超过当前点击点，fromPoint 箭头指向的Point*/
+ (void)showContentView:(UIView *)contentView style:(LHDPopViewBackgroundStyle)style FromPoint:(CGPoint)fromPoint;

+ (void)dismiss;

@end

