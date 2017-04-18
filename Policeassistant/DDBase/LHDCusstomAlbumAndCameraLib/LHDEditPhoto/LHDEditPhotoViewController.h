//
//  LHDEditPhotoViewController.h
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/27.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDBaseViewController.h"
#import "LHDCusstomAlbumCommonHeader.h"

@class LHDEditPhotoViewController;

typedef void (^LHDPhotoEditGetResultBlock)(LHDEditPhotoViewController * epVC,UIImage * editedImage);

/**
 *  编辑照片
 */
@interface LHDEditPhotoViewController : LHDBaseViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage editFrame:(CGRect)editFrame limitScaleRatio:(NSInteger)limitRatio;

- (void)getPhotoEditedImageBlock:(LHDPhotoEditGetResultBlock)block;

- (void)dismissVCBlock:(DismissViewControllerCompletionBlock)block;

@end

/*
 LHDEditPhotoViewController * edVC = [[LHDEditPhotoViewController alloc] initWithImage:image editFrame:CGRectMake(0, 200, self.view.width, 300) limitScaleRatio:3];
 __weak typeof(self) weakSelf = self;
 [edVC getPhotoEditedImageBlock:^(LHDEditPhotoViewController *epVC, UIImage *editedImage) {
 self.cameraBlock(self,editedImage);
 }];
 [edVC dismissVCBlock:^(BOOL yes) {
 if (yes) {
    [weakSelf dismissViewControllerAnimated:NO completion:nil];
 }
 }];
 [self presentViewController:edVC animated:NO completion:^{
 
 }];

 */
