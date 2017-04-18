//
//  LHDAlbumAssetsManager.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHDCusstomAlbumAssetsModel.h"


@class LHDCusstomAlbumGroupModel;
// 回调
typedef void(^callBackBlock)(id objc);

/**
 *  读取相册管理器
 */
@interface LHDAlbumAssetsManager : NSObject

/**
 *  获取所有组
 */
+ (instancetype) defaultAlbum;

/**
 * 获取所有组对应的图片
 */
- (void) getAllGroupWithAlbums : (callBackBlock ) callBack;

/**
 * 获取所有组对应的Videos
 */
- (void) getAllGroupWithVideos : (callBackBlock ) callBack;

/**
 *  传入一个组获取组里面的Asset
 */
- (void) getGroupPhotosWithGroup : (LHDCusstomAlbumGroupModel *) AlbumGroup finished : (callBackBlock ) callBack;

/**
 *  传入一个AssetsURL来获取UIImage
 */
- (void) getAssetsPhotoWithURLs:(NSURL *) url callBack:(callBackBlock ) callBack;

/**
 *  保存一张图片，得到 LHDCusstomAlbumAssetsModel一个模型
 *
 *  @param image    保存的图片
 *  @param callBack LHDCusstomAlbumAssetsModel
 */
- (void)saveImage:(UIImage *)image callBack:(callBackBlock) callBack;
/**
 *  保存一张图片，得到 LHDCusstomAlbumAssetsModel一个模型
 *
 *  @param image    保存的图片
 *  @param callBack LHDCusstomAlbumAssetsModel
 */
+ (void)saveImage:(UIImage *)image callBack:(callBackBlock) callBack;
/**
 *  保存一张图片，得到 LHDCusstomAlbumAssetsModel一个模型
 *
 *  @param image    保存的图片
 *  @param callBack LHDCusstomAlbumAssetsModel
 */
+ (void)saveImageData:(NSData *)imageData callBack:(callBackBlock) callBack;

@end
