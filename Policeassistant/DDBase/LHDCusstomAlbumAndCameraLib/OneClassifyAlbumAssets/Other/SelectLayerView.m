//
//  SelectLayerView.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "SelectLayerView.h"

@interface SelectLayerView ()

@property (nonatomic, strong) UILabel * numberLabel;

@end

@implementation SelectLayerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configSelectUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSelectUI];
    }
    return self;
}

- (void)setSignNumber:(NSInteger)signNumber
{
    _signNumber = signNumber;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", signNumber];
}

- (void)configSelectUI
{
    
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:self.frame];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.backgroundColor = [UIColor clearColor];
    }
    return _numberLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
