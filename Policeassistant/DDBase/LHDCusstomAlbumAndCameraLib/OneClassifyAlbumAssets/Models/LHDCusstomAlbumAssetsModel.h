//
//  LHDCusstomAlbumAssetsModel.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

/**
 *  单个照片模型，原图缩略图
 */
@interface LHDCusstomAlbumAssetsModel : NSObject

@property (strong,nonatomic) ALAsset *asset;
/**
 *  原图
 */
@property (strong,nonatomic) UIImage *originImage;
/**
 *  缩略图
 */
@property (strong,nonatomic) UIImage *thumbImage;
///**
// *  缩略图
// */
//- (UIImage *)thumbImage;
///**
// *  原图
// */
//- (UIImage *)originImage;


@end
