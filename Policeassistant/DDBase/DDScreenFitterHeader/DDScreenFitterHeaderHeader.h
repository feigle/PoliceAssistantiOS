//
//  DDScreenFitterHeaderHeader.h
//  刘和东
//
//  Created by 刘和东 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#ifndef DDScreenFitterHeaderHeader_h
#define DDScreenFitterHeaderHeader_h
#import "DDScreenFitter.h"


/**
 *  屏幕大小
 */
#define kScreenBounds [[UIScreen mainScreen] bounds]
#define KScreenWidth kScreenBounds.size.width
#define KScreenHeight kScreenBounds.size.height
#define kScreenScale [[UIScreen mainScreen] scale]


/**
 *  iphone6
 */
#define kScreen6Width 375.0
#define kScreen6Height 667.0

#define kScreen6ScaleW  [ddScreenFitter autoSize6ScaleX]
#define kScreen6ScaleH  [ddScreenFitter autoSize6ScaleY]

/**
 *  iphone6Plus
 */
#define kScreen6PScreenWidth 414.0
#define kScreen6PScreenHeight 736.0

#define kScreen6PScaleW  [ddScreenFitter autoSize6PScaleX]
#define kScreen6PScaleH  [ddScreenFitter autoSize6PScaleY]


#import "UIView+DDFrame.h"


/**
 *  Frame的屏幕适配 ,根据iphone6p的尺寸来的
 *  @return 返回当前的屏幕的rect
 */
static inline CGRect CGRectMake6p(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * ddScreenFitter.autoSize6PScaleX;
    rect.origin.y = y * ddScreenFitter.autoSize6PScaleY;
    rect.size.width = width * ddScreenFitter.autoSize6PScaleX;
    rect.size.height = height * ddScreenFitter.autoSize6PScaleY;
    return rect;
}

/**
 *  Frame的屏幕适配 ,根据iphone6的尺寸来的
 *  @return 返回当前的屏幕的rect
 */
static inline CGRect CGRectMake6(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * ddScreenFitter.autoSize6ScaleX;
    rect.origin.y = y * ddScreenFitter.autoSize6ScaleY;
    rect.size.width = width * ddScreenFitter.autoSize6ScaleX;
    rect.size.height = height * ddScreenFitter.autoSize6ScaleY;
    return rect;
}

#endif
