//
//  UIImageView+LHDSize.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/15.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "UIImageView+LHDSize.h"

@implementation UIImageView (LHDSize)

- (CGSize)contentSize
{
    return [self.image sizeThatFits:self.bounds.size];
}

- (void)refreshSize
{
    CGSize  size = [self contentSize];
    self.width = size.width;
    self.height = size.height;
}


- (void)maxHeight:(CGFloat)height
{
    CGSize size = self.size;
    if (height < self.image.size.height ) {
        size.height = height;
    } else {
        size.height = self.image.size.height;
    }
    self.size = size;
    self.size = [self contentSize];
}

- (void)maxWidth:(CGFloat)width
{
    CGSize size = self.size;
    if (width < self.image.size.width ) {
        size.width = width;
    } else {
        size.width = self.image.size.width;
    }
    self.size = size;
    self.size = [self contentSize];
}



- (void)maxSize:(CGSize)size
{
    if (size.height > self.image.size.height ) {
        size.height = self.image.size.height;
    }
    if (size.width > self.image.size.width ) {
        size.width = self.image.size.width;
    }
    self.size = size;
    self.size = [self contentSize];
}


@end
