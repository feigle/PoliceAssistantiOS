//
//  UILabel+LHDStringSize.m
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/24.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import "UILabel+LHDStringSize.h"
#import "NSString+LHDHandleTools.h"

@implementation UILabel (LHDStringSize)

- (void)setStringHeight
{
    CGSize size = [self.text returnSizeWithFont:self.font color:self.textColor width:self.width];
    self.height = size.height;
}

- (void)setStringWidth
{
    CGSize size = [self.text returnSizeWithFont:self.font color:self.textColor height:self.height];
    self.width = size.width;
}

/**宽度固定，返回size*/
- (CGSize)returnSizeWithWidth:(CGFloat)width
{
    CGSize size = [self.text returnSizeWithFont:self.font color:self.textColor width:width];
    return size;
}

/**高度固定，返回size*/
- (CGSize)returnSizeWithHeight:(CGFloat)height
{
    CGSize size = [self.text returnSizeWithFont:self.font color:self.textColor height:height];
    return size;
}

/**宽度固定，返回size*/
- (CGSize)returnSizeFixedWidth
{
    CGSize size = [self.text returnSizeWithFont:self.font color:self.textColor width:self.width];
    return size;
}

/**高度固定，返回size*/
- (CGSize)returnSizeFixedHeight
{
    CGSize size = [self.text returnSizeWithFont:self.font color:self.textColor height:self.height];
    return size;
}

@end
