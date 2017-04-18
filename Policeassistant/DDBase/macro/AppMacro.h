//
//  DDLoginViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/27.
//  Copyright © 2016年 DoorDu. All rights reserved.
//
//  AppMacro.h 里放app相关的宏定义

#ifndef kd_AppMacro_h
#define kd_AppMacro_h

#define KType_system @"1"//系统自动生成
#define KType_subject @"2"//活动专题

#define KStatus_send_no @"0"//未推送
#define KStatus_read_no @"1"//已推送,未读
#define KStatus_read_yes @"2"//已读

#define LocalizableResourceName @"KDStrings"

#define kTabbarHeight 49
#define knagabarwith 74
#define imgDir @"KDImageFile"
#define imageIsEndWith(name)  [name hasSuffix:@"png"]||[name hasSuffix:@"jpg"]||[name hasSuffix:@"jpeg"];

// 判断设备是否是iPhone5
#define iPhone5 (fabs((double)[[UIScreen mainScreen ] bounds].size.height-(double)568)<DBL_EPSILON )
#define iPhone5more ((double)[[UIScreen mainScreen ] bounds].size.height-(double)568>=0 )
#define iPhone6 ((double)[[UIScreen mainScreen ] bounds].size.height-(double)667>=0 )
#define iPhone6P ((double)[[UIScreen mainScreen ] bounds].size.height-(double)736>=0 )
// 判断系统版本
#define iOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define iOS10 [[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0
//#define iOSVersion7 (fabs((double)[[UIScreen mainScreen ] bounds].size.height-(double)568)<DBL_EPSILON )
#define iOS_Version [[UIDevice currentDevice].systemVersion doubleValue]

#define Nav_HEIGHT iOSVersion7?64.0f:44.0f

#define NumMark_W_H 16


#define	KViewHeight	iOSVersion7?KScreenBoundsHeight:KScreenHeight

#define	KInfoHeight	KViewHeight- Nav_HEIGHT


#define WeakSelf typeof(self) __weak weakSelf = self;
#define StrongSelf typeof(weakSelf) __strong strongSelf = weakSelf;


//-------------------获取设备大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//-------------------获取设备大小-------------------------


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

/***圆角的设置**/
/************** View 圆角和加边框 *******************/
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]];\
[View setClipsToBounds:YES];\
//[View.layer  setShouldRasterize:YES];\
[View.layer  setRasterizationScale:[UIScreen mainScreen].scale]


/************** View 圆角 *******************/
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View setClipsToBounds:YES];\
//[View.layer  setShouldRasterize:YES];\
[View.layer  setRasterizationScale:[UIScreen mainScreen].scale]

/**拼接两个字符串*/
static inline NSString * strConcat(NSString *s1, NSString *s2) {
    return [NSString stringWithFormat:@"%@%@", s1, s2];
}

/**
 *  根据颜色的字符串得到字符串
 *
 *  @param stringToConvert 颜色对应的字符串
 *
 *  @return 返回对应的UIColor
 */
static inline UIColor * colorWithHexString(NSString * stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    //if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //SL_Log(@"%f:::%f:::%f",((float) r / 255.0f),((float) g / 255.0f),((float) b / 255.0f));
#define LHD_COLOR(RED, GREEN, BLUE, ALPHA)	[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA]
    return LHD_COLOR(((float) r / 255.0f),((float) g / 255.0f),((float) b / 255.0f), 1);
}


#endif
