//
//  LHDCusstomCameraPreviewViewController.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/28.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDBaseViewController.h"

#import "LHDCusstomAlbumCommonHeader.h"

@class LHDCusstomCameraPreviewViewController;

typedef void (^LHDCusstomCameraPreviewGetImageBlock)(LHDCusstomCameraPreviewViewController * cameraPreviewVC,UIImage * image);

/**
 *  拍完照片后的预览照片
 */
@interface LHDCusstomCameraPreviewViewController : LHDBaseViewController

@property (nonatomic, strong) UIImage * image;

- (void)getCusstomCameraPreviewImageBlock:(LHDCusstomCameraPreviewGetImageBlock)block;

- (void)dismissVCBlock:(DismissViewControllerCompletionBlock)block;


@end
