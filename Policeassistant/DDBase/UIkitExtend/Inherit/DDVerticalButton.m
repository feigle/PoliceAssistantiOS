//
//  DDVerticalButton.m
//  刘和东
//
//  Created by 秦沙沙 on 2015/12/30.
//  Copyright © 2015年 刘和东. All rights reserved.
//

#import "DDVerticalButton.h"

@implementation DDVerticalButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
    }
    return self;
}

- (void)setupData
{
    self.padding = 5*kScreen6ScaleH;
    self.imageWidth = 0;
    self.imageHeight = 0;
    self.titleIsBottom = YES;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Move the image to the top and center it horizontally
    CGRect imageFrame = self.imageView.frame;
    if (self.imageHeight && self.imageWidth) {
        imageFrame.size.width = self.imageWidth;
        imageFrame.size.height = self.imageHeight;
    }
    
    self.imageView.frame = imageFrame;
    self.imageView.centerX = self.width/2.0;
    
    self.imageView.bottom = self.height/2.0-self.padding/2.0;
    
    // Adjust the label size to fit the text, and move it below the image
    self.titleLabel.top = self.height/2.0 + self.padding/2.0;
    self.titleLabel.centerX = self.width/2.0;
    
    if (!self.titleIsBottom) {
        self.titleLabel.bottom = self.height/2.0-self.padding/2.0;
        self.imageView.top = self.height/2.0+self.padding/2.0;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
