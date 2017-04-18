//
//  DDHorizontalButton.m
//  刘和东
//
//  Created by 秦沙沙 on 2015/1/7.
//  Copyright © 2015年 刘和东. All rights reserved.
//

#import "DDHorizontalButton.h"

@implementation DDHorizontalButton

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
    self.padding = 5*kScreen6ScaleW;
    self.imageWidth = 0;
    self.imageHeight = 0;
    self.titleIsRight = YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Move the image to the top and center it horizontally
    CGRect imageFrame = self.imageView.frame;
//    imageFrame.origin.x = (self.frame.size.width / 2) - (imageFrame.size.width / 2);
    if (self.imageHeight && self.imageWidth) {
        imageFrame.size.width = self.imageWidth;
        imageFrame.size.height = self.imageHeight;
    }
    self.imageView.frame = imageFrame;
    self.imageView.centerY = self.height/2.0;
    
    self.imageView.right = self.width/2.0-self.padding/2.0;
    // Adjust the label size to fit the text, and move it below the image
    
    self.titleLabel.centerY = self.height/2.0;
    self.titleLabel.x = self.width/2.0+self.padding/2.0;
    if (_sizeFit) {
        self.imageView.x = 0;
        self.titleLabel.x = self.imageView.right+self.padding;
    }

    if (!self.titleIsRight) {
        self.titleLabel.right = self.width/2.0-self.padding/2.0;
        self.imageView.x = self.width/2.0+self.padding/2.0;
        if (_sizeFit) {
            self.titleLabel.x = 0;
            self.imageView.x = self.titleLabel.right+self.padding;
        }
    }
}

- (void)setSizeFit:(BOOL)sizeFit
{
    _sizeFit = sizeFit;
    CGSize titleSize = [self.titleLabel.text returnSizeWithFont:font6Size(40/2.0) color:self.titleLabel.textColor height:self.titleLabel.font.lineHeight];
    CGSize imageSize = self.imageView.image.size;
    self.imageView.size = imageSize;
    if (self.imageHeight && self.imageWidth) {
        self.imageView.width = self.imageWidth;
        self.imageView.height = self.imageHeight;
        imageSize.width = self.imageWidth;
    }
    self.height = self.imageView.height;
    if (self.height < titleSize.height) {
        self.height = titleSize.height;
    }
    CGFloat width = titleSize.width+self.padding+imageSize.width;
    self.width = width;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
