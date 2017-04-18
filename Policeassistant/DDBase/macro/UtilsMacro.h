//
//  DDLoginViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/6/27.
//  Copyright © 2016年 DoorDu. All rights reserved.
//
//  放的是一些方便使用的宏定义

#ifndef kd_UtilsMacro_h
#define kd_UtilsMacro_h

#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%d",intValue]
#define NSStringFromLong(longValue) [NSString stringWithFormat:@"%ld",longValue]
#define NSStringFromFloat1(floatValue) [NSString stringWithFormat:@"%.1f",floatValue]
//---------------------------打印---------------------------
#define	DNSLog(...);	NSLog(__VA_ARGS__);
#define DNSLogMethod	NSLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd));
#define DNSLogPoint(p)	NSLog(@"%f,%f", p.x, p.y);
#define DNSLogSize(p)	NSLog(@"%f,%f", p.width, p.height);
#define DNSLogRect(p)	NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);

#define DNSLogRects(p) NSLog(@"p = %@", NSStringFromCGRect(p))

#define getStringFromTable(a,b) NSLocalizedStringFromTable(a,      LocalizableResourceName, b)
//--------设置字体-------------
#define sysFont12 [UIFont systemFontOfSize:12]
#define sysFont13 [UIFont systemFontOfSize:13]
#define sysFont14 [UIFont systemFontOfSize:14]
#define sysFont15 [UIFont systemFontOfSize:15]
#define sysFont16 [UIFont systemFontOfSize:16]
#define sysFont17 [UIFont systemFontOfSize:17]
#define sysFont18 [UIFont systemFontOfSize:18]
#define sysFont22 [UIFont systemFontOfSize:22]


//---------------------------改变frame的位置---------------------------
#define reSetFrameByAddY(frame,h) CGRectMake(frame.origin.x, frame.origin.y+h, frame.size.width, frame.size.height);

#define reSetFrameByReplayY(frame,y) CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);

#define reSetFrameByAddH(frame,h) CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+h);

#define reSetFrameByReplayH(frame,h) CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, h);

#define reSetFrameByReplayX(frame,w) CGRectMake(w, frame.origin.y, frame.size.width, frame.size.height);

#define reSetFrameByAddX(frame,w) CGRectMake(frame.origin.x+w, frame.origin.y, frame.size.width, frame.size.height);

#define reSetFrameByReplayW(frame,w) CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height);

#define reSetFrameByAddYH(frame,h) CGRectMake(frame.origin.x, frame.origin.y+h, frame.size.width, frame.size.height-h);

#define reSetFrameByReplayYH(frame,y,h) CGRectMake(frame.origin.x, y, frame.size.width, h);

#define reSetFrameByReplayWH(frame,w,h) CGRectMake(frame.origin.x, frame.origin.y, w, h);

#define reSetFrameByReplayXY(frame,x,y) CGRectMake(x, y, frame.size.width, frame.size.height);

#define alertFrame()  CGRectMake(20, KScreenHeight-140,KScreenWidth-40, 35);
//----------------------颜色类---------------------------

#define ColorHex(hex) colorWithHexString(hex)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//E72727 FC3B41 FB2C4A
#define btnRed UIColorFromRGB(0xE72727)
#define btnRedH UIColorFromRGB(0xFC3B41)

#define btnOrange UIColorFromRGB(0xFFAC29)
#define btnOrangeH UIColorFromRGB(0xFFB929)

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
//导航栏背景色
#define DaohangCOLOR [UIColor colorWithRed:68.0/255.0 green:118.0/255.0 blue:224.0/255.0 alpha:1.0]

//导航栏背景色
#define TableViewBg [UIColor colorWithRed:242.0/255.0 green:246.0/255.0 blue:249.0/255.0 alpha:1.0]


//背景色
#define bagcolor [UIColor colorWithRed:172.0/255.0 green:222.0/255.0 blue:234.0/255.0 alpha:1.0]
//自定义groupTableViewBackgroundColor
#define GRUOP_TABLE_BACKGROUND_COLOR [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244/255.0 alpha:1.0]


//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#pragma mark - color functions

#define NAVCOLOR [UIColor colorWithRed:0/255.0 green:209/255.0 blue:230/255.0 alpha:1]

#define TEXCOLOR [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1]
#define MAINTEX [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1]

#define LINECOLOR [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1]

#define LIGHTRED [UIColor colorWithRed:238.0/255.0 green:108.0/255.0 blue:120/255.0 alpha:1.0]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//----------------------颜色类--------------------------

//------------------------用到 static const----------------------------//
/**push 到 授权记录列表控制器*/
static NSString *const PushToDDLandlordRecordListViewController = @"PushToDDLandlordRecordListViewController";

#endif
