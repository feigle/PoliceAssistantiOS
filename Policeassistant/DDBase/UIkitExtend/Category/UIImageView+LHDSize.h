//
//  UIImageView+LHDSize.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/15.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LHDSize)

- (void)maxSize:(CGSize)size;

- (void)maxHeight:(CGFloat)height;
- (void)maxWidth:(CGFloat)width;

- (CGSize)contentSize;


- (void)refreshSize;


@end
