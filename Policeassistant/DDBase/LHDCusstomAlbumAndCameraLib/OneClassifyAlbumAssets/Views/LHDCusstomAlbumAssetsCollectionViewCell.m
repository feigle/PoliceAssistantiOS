//
//  LHDCusstomAlbumAssetsCollectionViewCell.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDCusstomAlbumAssetsCollectionViewCell.h"
#import "SelectLayerView.h"
#import "LHDCusstomAlbumCommonHeader.h"


@interface LHDCusstomAlbumAssetsCollectionViewCell ()

@property (nonatomic, strong) SelectLayerView * selectLayerView;

@end

@implementation LHDCusstomAlbumAssetsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.contentView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.89 alpha:1.00];
    [self imageView];
    [self selectedButton];
    
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (void)setSignNumber:(NSInteger)signNumber
{
//    _signNumber = signNumber;
    
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.selectedButton.selected = isSelected;
    if (_isSelected) {
        [self addAanimation];
    }
}


- (UIButton *)selectedButton
{
    if (_selectedButton == nil) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.frame = CGRectMake(self.frame.size.width - 38/2-5, self.frame.size.height-38/2-5, 38/2, 38/2);
        _selectedButton.userInteractionEnabled = NO;
//        [_selectedButton setBackgroundImage:[UIImage imageNamed:LHDCusstomAlbumSrcName(@"guide_unchoice_bt")] forState:UIControlStateNormal];
        [_selectedButton setBackgroundImage:[UIImage imageNamed:LHDCusstomAlbumSrcName(@"guide_choice_bt")] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectedButton];
    }
    return _selectedButton;
}


//- (SelectLayerView *)selectLayerView
//{
//    if (!_selectLayerView) {
//        _selectLayerView = [[SelectLayerView alloc] initWithFrame:self.contentView.frame];
//    }
//    return _selectLayerView;
//}

- (void)addAanimation
{
    PhotoAddAnimationWithView(self.imageView);
//    /创建串行队列？
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), queue, ^{
        PhotoAddAnimationWithView(self.selectedButton);
    });
    
}

@end
