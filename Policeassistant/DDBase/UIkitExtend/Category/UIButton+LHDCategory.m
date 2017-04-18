//
//  UIButton+Category.m
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import "UIButton+LHDCategory.h"
#import <objc/runtime.h>

static char const keyButtonClick;

@implementation UIButton (LHDCategory)

- (void)setNormalImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}
- (void)setSelectedImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateSelected];
}
- (void)setNormalAndHighlightedImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
}
- (void)setNormalImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
- (void)setSelectedImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}
- (void)setNormalAndHighlightedImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

- (void)setHighlightedImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateHighlighted];
}
- (void)setHighlightedImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

- (void)setNormalBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}
- (void)setSelectedBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

- (void)setNormalBackgroundImageName:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

}
- (void)setSelectedBackgroundImageName:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}

- (void)setNormalTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setSelectedTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateSelected];
}

- (void)setNormalTitleColor:(UIColor *)Color
{
    [self setTitleColor:Color forState:UIControlStateNormal];
}
- (void)setSelectedTitleColor:(UIColor *)Color
{
    [self setTitleColor:Color forState:UIControlStateSelected];
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

- (void)addClickedHandle:(LHDButtonClickedBlock)clickedBlock
{
    [self addTarget:self action:@selector(btnClickedHandle:) forControlEvents:UIControlEventTouchUpInside];
    if (clickedBlock) {
        objc_setAssociatedObject(self, &keyButtonClick, clickedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)btnClickedHandle:(UIButton *)sender
{
    LHDButtonClickedBlock clickedHandleBlock = objc_getAssociatedObject(self, &keyButtonClick);
    if (clickedHandleBlock) {
        clickedHandleBlock(sender);
    }
}

@end
