//
//  UIView+DDFrame.h
//  刘和东
//
//  Created by 刘和东 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DDFrame)

#pragma mark - 正常情况的大小
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGSize size;
@property (nonatomic,readonly) CGPoint bottomLeft;
@property (nonatomic,readonly) CGPoint bottomRight;
@property (nonatomic,readonly) CGPoint topRight;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

#pragma mark - iphone6上面的大小
@property (nonatomic,assign) CGSize size6;
@property (nonatomic,readonly) CGPoint bottomLeft6;
@property (nonatomic,readonly) CGPoint bottomRight6;
@property (nonatomic,readonly) CGPoint topRight6;
@property (nonatomic,assign) CGFloat height6;
@property (nonatomic,assign) CGFloat width6;
@property (nonatomic,assign) CGFloat top6;
@property (nonatomic,assign) CGFloat left6;
@property (nonatomic,assign) CGFloat bottom6;
@property (nonatomic,assign) CGFloat right6;
@property (nonatomic,assign) CGFloat x6;
@property (nonatomic,assign) CGFloat y6;
@property (nonatomic,assign) CGFloat centerX6;
@property (nonatomic,assign) CGFloat centerY6;

#pragma mark - iphone6p上面的大小
@property (nonatomic,assign) CGSize size6p;
@property (nonatomic,readonly) CGPoint bottomLeft6p;
@property (nonatomic,readonly) CGPoint bottomRight6p;
@property (nonatomic,readonly) CGPoint topRight6p;
@property (nonatomic,assign) CGFloat height6p;
@property (nonatomic,assign) CGFloat width6p;
@property (nonatomic,assign) CGFloat top6p;
@property (nonatomic,assign) CGFloat left6p;
@property (nonatomic,assign) CGFloat bottom6p;
@property (nonatomic,assign) CGFloat right6p;
@property (nonatomic,assign) CGFloat x6p;
@property (nonatomic,assign) CGFloat y6p;
@property (nonatomic,assign) CGFloat centerX6p;
@property (nonatomic,assign) CGFloat centerY6p;


@end
