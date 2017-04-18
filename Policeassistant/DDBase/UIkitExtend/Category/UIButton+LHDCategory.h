//
//  UIButton+Category.h
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/21.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHDButtonClickedBlock)(UIButton * sender);

@interface UIButton (LHDCategory)

- (void)setNormalImage:(UIImage *)image;
- (void)setSelectedImage:(UIImage *)image;
- (void)setNormalAndHighlightedImage:(UIImage *)image;

- (void)setNormalImageName:(NSString *)imageName;
- (void)setSelectedImageName:(NSString *)imageName;
- (void)setNormalAndHighlightedImageName:(NSString *)imageName;

- (void)setHighlightedImage:(UIImage *)image;
- (void)setHighlightedImageName:(NSString *)imageName;


- (void)setNormalBackgroundImage:(UIImage *)image;
- (void)setSelectedBackgroundImage:(UIImage *)image;
- (void)setNormalBackgroundImageName:(NSString *)imageName;
- (void)setSelectedBackgroundImageName:(NSString *)imageName;

- (void)setNormalTitle:(NSString *)title;
- (void)setSelectedTitle:(NSString *)title;

- (void)setNormalTitleColor:(UIColor *)Color;
- (void)setSelectedTitleColor:(UIColor *)Color;

- (void)setTitleFont:(UIFont *)font;


- (void)addClickedHandle:(LHDButtonClickedBlock)clickedBlock;

@end
