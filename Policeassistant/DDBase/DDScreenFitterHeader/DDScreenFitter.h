//
//  DDScreenFitter.h
//  刘和东
//
//  Created by 刘和东 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ddScreenFitter ((DDScreenFitter *)[DDScreenFitter sharedDDScreenFitter])

/**适配字体大小*/

@interface DDScreenFitter : NSObject

/**创建一个单例*/
+ (instancetype)sharedDDScreenFitter;

@property (assign, nonatomic) CGFloat autoSize6PScaleX;
@property (assign, nonatomic) CGFloat autoSize6PScaleY;
@property (assign, nonatomic) CGFloat autoSize6ScaleX;
@property (assign, nonatomic) CGFloat autoSize6ScaleY;

//得到字体的比例，以6p为基准
@property (assign, nonatomic) CGFloat font6pScale;
//得到字体的比例，以6为基准 bold
@property (assign, nonatomic) CGFloat font6Scale;

@end

/**UI界面是 iphone6 的时候，选择 font6Size*/
static inline UIFont * font6Size(CGFloat fontSize)
{
    return [UIFont systemFontOfSize:fontSize*ddScreenFitter.font6Scale];
}
/**UI界面是 iphone6 ，需要加粗的时候选择 fontBold6Size*/
static inline UIFont * fontBold6Size(CGFloat fontSize)
{
    return [UIFont boldSystemFontOfSize:fontSize*ddScreenFitter.font6Scale];
}
/**UI界面是 iphone6p 的时候，选择 font6pSize*/
static inline UIFont * font6pSize(CGFloat fontSize)
{
    return [UIFont systemFontOfSize:fontSize*ddScreenFitter.font6pScale];
}
/**UI界面是 iphone6p ，需要加粗的时候选择 fontBold6pSize*/
static inline UIFont * fontBold6pSize(CGFloat fontSize)
{
    return [UIFont boldSystemFontOfSize:fontSize*ddScreenFitter.font6pScale];
}

