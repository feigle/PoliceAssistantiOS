//
//  LHDCusstomAlbumAssetsModel.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDCusstomAlbumAssetsModel.h"

@implementation LHDCusstomAlbumAssetsModel

- (UIImage *)thumbImage{
    if (_thumbImage) {
        return _thumbImage;
    }
    UIImage * image = [UIImage imageWithCGImage:[self.asset  aspectRatioThumbnail]];
    _thumbImage = [image fixOrientation];
    return _thumbImage;
}

- (UIImage *)originImage{
    if (_originImage) {
        return _originImage;
    }//fullResolutionImage    fullScreenImage
//    UIImage *fullImage = [UIImage imageWithCGImage:[self.asset.defaultRepresentation fullScreenImage]
//                                             scale:[self.asset.defaultRepresentation scale] orientation:
//                          (UIImageOrientation)[self.asset.defaultRepresentation orientation]];
//    return fullImage;
    UIImage * image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    _originImage = [image fixOrientation];
    return _originImage;
}


@end
