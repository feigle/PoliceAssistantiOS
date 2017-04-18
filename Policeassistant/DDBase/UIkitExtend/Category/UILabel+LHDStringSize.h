//
//  UILabel+LHDStringSize.h
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/24.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LHDStringSize)

/**Label宽度固定，根据文字计算大小，并设置label控件的高度*/
- (void)setStringHeight;

/**Label高度固定，根据文字计算大小，并设置label控件的宽度*/
- (void)setStringWidth;

/**宽度固定，返回size*/
- (CGSize)returnSizeWithWidth:(CGFloat)width;

/**高度固定，返回size*/
- (CGSize)returnSizeWithHeight:(CGFloat)height;


/**Label宽度固定，返回size*/
- (CGSize)returnSizeFixedWidth;

/**Label高度固定，返回size*/
- (CGSize)returnSizeFixedHeight;

@end
