//
//  DDScreenFitter.m
//  刘和东
//
//  Created by 刘和东 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import "DDScreenFitter.h"

@implementation DDScreenFitter

/**创建一个单例*/
+ (instancetype)sharedDDScreenFitter
{
    static dispatch_once_t onceToken;
    static DDScreenFitter * _sharedDDScreenFitter;
    dispatch_once(&onceToken, ^{
        _sharedDDScreenFitter = [[DDScreenFitter alloc] init];
    });
    return _sharedDDScreenFitter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}

- (void)setupData
{
    _autoSize6PScaleX = [[UIScreen mainScreen ] bounds].size.width/414.0;
    _autoSize6PScaleY = [[UIScreen mainScreen ] bounds].size.height/736.0;
    _autoSize6ScaleX = [[UIScreen mainScreen ] bounds].size.width/375.0;
    _autoSize6ScaleY = [[UIScreen mainScreen ] bounds].size.height/667.0;
    _font6pScale = 1;
    _font6Scale = 1;
    if ([[UIScreen mainScreen ] bounds].size.width < 414.0 && [[UIScreen mainScreen ] bounds].size.height < 736.0 ) {//小于6p的屏幕
        _font6pScale = 2/3.0;
    } else {//大于等于6p的屏幕
        _font6Scale = 1.5;
    }
    NSLog(@"font6pScale :%lf",_font6Scale);
}

@end
