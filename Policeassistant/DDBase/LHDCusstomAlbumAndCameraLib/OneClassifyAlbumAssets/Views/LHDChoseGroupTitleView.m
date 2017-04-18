//
//  LHDChoseGroupTitleView.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/21.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDChoseGroupTitleView.h"

@interface LHDChoseGroupTitleView ()

@property (nonatomic, strong) UILabel * bigTitleLabel;

@end

@implementation LHDChoseGroupTitleView

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self configUI];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self configUI];
    
    return self;
}

- (void)configUI
{
//    16  44 28
    self.width = 150;
    //    16  44 28
    self.bigTitleLabel.frame = CGRectMake(0, 2, self.frame.size.width, font6Size(18).lineHeight);
    self.bigTitleLabel.text = @"相册";
    self.bigTitleLabel.textColor = [UIColor whiteColor];
    self.bigTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.bigTitleLabel.font = font6Size(18);
    [self addSubview:self.bigTitleLabel];
    
    UILabel * othLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bigTitleLabel.bottom+3, self.frame.size.width, font6Size(10).lineHeight)];
    othLabel.textAlignment = NSTextAlignmentLeft;
    othLabel.font = font6Size(10);
    othLabel.textColor = [UIColor whiteColor];
    othLabel.text = @"轻触这里更改";
    [othLabel sizeToFit];
    [self addSubview:othLabel];
    UIImage * image = [UIImage imageNamed:@"AlbumAssetsicon_more"];
    UIImageView * arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-20, self.bigTitleLabel.bottom+3, image.size.width,image.size.height)];
    arrowImageView.image = image;
    othLabel.centerX = self.width/2.0-arrowImageView.width/2.0-3;
    arrowImageView.centerY = othLabel.centerY;
    arrowImageView.left = othLabel.right+3;
    [self addSubview:arrowImageView];

}

- (void)addTarget:(id)objc action:(SEL)action
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:objc action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (UILabel *)bigTitleLabel
{
    if (!_bigTitleLabel) {
        _bigTitleLabel = [[UILabel alloc] init];
    }
    return _bigTitleLabel;
}

- (void)setChangeName:(NSString *)changeName
{
    _changeName = changeName;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
