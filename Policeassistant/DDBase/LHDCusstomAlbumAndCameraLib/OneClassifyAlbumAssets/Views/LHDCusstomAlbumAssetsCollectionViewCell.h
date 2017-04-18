//
//  LHDCusstomAlbumAssetsCollectionViewCell.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHDCusstomAlbumAssetsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIButton * selectedButton;


//@property (nonatomic, assign) NSInteger signNumber;

@property (nonatomic, assign) BOOL isSelected;//是否选中

@end
