//
//  DDVerticalButton.h
//  刘和东
//
//  Created by 秦沙沙 on 2015/12/30.
//  Copyright © 2015年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDVerticalButton : UIButton

/**图片与title的空隙*/
@property (nonatomic,assign) CGFloat padding;
/**图片的宽度*/
@property (nonatomic,assign) CGFloat imageWidth;
/**图片的高度*/
@property (nonatomic,assign) CGFloat imageHeight;
/**title 是否是在下面，默认是YES*/
@property (nonatomic,assign) BOOL titleIsBottom;

@end
