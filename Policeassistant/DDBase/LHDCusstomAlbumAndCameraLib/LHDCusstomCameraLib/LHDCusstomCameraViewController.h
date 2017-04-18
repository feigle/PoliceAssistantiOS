//
//  LHDCusstomCameraViewController.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/27.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDBaseViewController.h"
#import "LHDAlbumAssetsManager.h"

@class LHDCusstomCameraViewController;

typedef void (^LHDCusstomCameraGetPhotoImageBlock)(LHDCusstomCameraViewController * cameraVC, UIImage * image);

/**
 *  自定义照相机
 */
@interface LHDCusstomCameraViewController : LHDBaseViewController

@property (nonatomic,assign) BOOL isNeedEditPhoto;//是否需要编辑图片，默认不需要
@property (nonatomic,weak) UIViewController * fromeViewController;//
@property (nonatomic, assign) BOOL  isHeader;//是不是头像，用于，图片剪切的正方形
/**宽度除以高度的 比例，默认是 0.56*/
@property (nonatomic, assign) CGFloat editWideHighRatio;

- (void)cusstomCameraGetPhotoImageBlock:(LHDCusstomCameraGetPhotoImageBlock)block;

- (void)show;

@end
